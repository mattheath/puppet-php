require 'puppet/util/execution'

Puppet::Type.type(:php_extension).provide(:pecl_source) do
  include Puppet::Util::Execution
  desc "Provides PHP extensions compiled from their pecl source code"

  # Build and install our PHP extension
  def create

    # Fetch & cache the download from PECL
    fetch unless File.exists?("#{@resource[:cache_dir]}/#{@resource[:package_name]}.tgz")

    # Extract, build & install
    extract
    phpize
    configure
    make
    install
  end

  def destroy
    FileUtils.rm_rf("#{@resource[:phpenv_root]}/versions/#{@resource[:php_version]}/modules/#{@resource[:extension]}.so")
  end

  def exists?
    File.exists?("#{@resource[:phpenv_root]}/versions/#{@resource[:php_version]}/modules/#{@resource[:extension]}.so")
  end

  # Fetch the packaged source to a cached file
  def fetch
    %x( wget -q -O "#{@resource[:cache_dir]}/#{@resource[:package_name]}.tgz" #{@resource[:package_url]} )
    raise "Could not download #{@resource[:package_name]}" unless File.exists?("#{@resource[:cache_dir]}/#{@resource[:package_name]}.tgz")
  end

protected

  def extract
    # Nuke currently extracted source folder if it exists
    FileUtils.rm_rf("#{@resource[:cache_dir]}/#{@resource[:package_name]}")

    # Re-extract tgz to folder
    Dir.mkdir("#{@resource[:cache_dir]}/#{@resource[:package_name]}")
    %x( tar -xvzf "#{@resource[:cache_dir]}/#{@resource[:package_name]}.tgz" -C "#{@resource[:cache_dir]}/#{@resource[:package_name]}" )
  end

  # PHPize the extension, using the correct version of PHP
  def phpize
    working_dir = "#{@resource[:cache_dir]}/#{@resource[:package_name]}/#{@resource[:package_name]}"
    php_version_prefix = "#{@resource[:phpenv_root]}/versions/#{@resource[:php_version]}"
    %x( cd #{working_dir} && #{php_version_prefix}/bin/phpize )
  end

  # Configure with the correct version of php-config and prefix and any additional configure parameters
  def configure
    working_dir = "#{@resource[:cache_dir]}/#{@resource[:package_name]}/#{@resource[:package_name]}"
    php_version_prefix = "#{@resource[:phpenv_root]}/versions/#{@resource[:php_version]}"
    puts "cd #{working_dir} && ./configure --prefix=#{php_version_prefix} --with-php-config=#{php_version_prefix}/bin/php-config"
    puts %x( cd #{working_dir} && ./configure --prefix=#{php_version_prefix} --with-php-config=#{php_version_prefix}/bin/php-config #{@resource[:configure_params]})
  end

  # Make the module
  def make
    working_dir = "#{@resource[:cache_dir]}/#{@resource[:package_name]}/#{@resource[:package_name]}"
    puts %x( cd #{working_dir} && make )

    raise "Failed to build module #{@resource[:name]}" unless File.exists?("#{working_dir}/modules/#{@resource[:extension]}.so")
  end

  # Make the module
  def install
    working_dir = "#{@resource[:cache_dir]}/#{@resource[:package_name]}/#{@resource[:package_name]}"
    php_version_prefix = "#{@resource[:phpenv_root]}/versions/#{@resource[:php_version]}"

    %x( cp #{working_dir}/modules/#{@resource[:extension]}.so #{php_version_prefix}/modules/#{@resource[:extension]}.so )

    raise "Failed to install module #{@resource[:name]}" unless File.exists?("#{php_version_prefix}/modules/#{@resource[:extension]}.so")
  end

end
