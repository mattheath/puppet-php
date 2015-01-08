require 'puppet/util/execution'

Puppet::Type.type(:php_extension).provide(:pecl) do
  include Puppet::Util::Execution
  desc "Provides PHP extensions compiled from their pecl source code"

  defaultfor :operatingsystem => :darwin

  # Build and install our PHP extension
  def create

    # Let's get a few things straight
    unless @resource[:extension_dir].nil?
      @work_dir = "#{@resource[:cache_dir]}/#{@resource[:package_name]}/#{@resource[:package_name]}/#{@resource[:extension_dir]}"
    else
      @work_dir = "#{@resource[:cache_dir]}/#{@resource[:package_name]}/#{@resource[:package_name]}"
    end
    @php_version_prefix = "#{@resource[:phpenv_root]}/versions/#{@resource[:php_version]}"
    @resource[:compiled_name] ||= "#{@resource[:extension]}.so"

    # Fetch & cache the download from PECL
    fetch unless File.exists?("#{@resource[:cache_dir]}/#{@resource[:package_name]}.tgz")

    # Prepare for building
    extract

    # PHPize, build & install
    phpize
    configure
    make
    install
  end

  def destroy
    @resource[:compiled_name] ||= "#{@resource[:extension]}.so"
    FileUtils.rm_rf("#{@resource[:phpenv_root]}/versions/#{@resource[:php_version]}/modules/#{@resource[:extension]}.so")
  end

  def exists?
    @resource[:compiled_name] ||= "#{@resource[:extension]}.so"
    File.exists?("#{@resource[:phpenv_root]}/versions/#{@resource[:php_version]}/modules/#{@resource[:compiled_name]}")
  end

protected

  # Fetch the packaged source to a cached file
  def fetch
    %x( #{@resource[:homebrew_path]}/bin/wget -q -O "#{@resource[:cache_dir]}/#{@resource[:package_name]}.tgz" #{@resource[:package_url]} )
    raise "Could not download #{@resource[:package_name]}" unless File.exists?("#{@resource[:cache_dir]}/#{@resource[:package_name]}.tgz")
  end

  # Prep the extension working directory
  def extract
    # Nuke currently extracted source folder if it exists
    FileUtils.rm_rf("#{@resource[:cache_dir]}/#{@resource[:package_name]}")

    # Re-extract tgz to folder
    Dir.mkdir("#{@resource[:cache_dir]}/#{@resource[:package_name]}")
    %x( tar -xvzf "#{@resource[:cache_dir]}/#{@resource[:package_name]}.tgz" -C "#{@resource[:cache_dir]}/#{@resource[:package_name]}" )
  end

  # PHPize the extension, using the correct version of PHP
  def phpize
    %x( export PHP_AUTOCONF=#{autoconf} && export PHP_AUTOHEADER=#{autoheader} && export PKG_CONFIG=#{@resource[:homebrew_path]}/bin/pkg-config && cd #{@work_dir} && #{@php_version_prefix}/bin/phpize )
  end

  # Configure with the correct version of php-config and prefix and any additional configure parameters
  def configure
    %x( export PKG_CONFIG=#{@resource[:homebrew_path]}/bin/pkg-config && cd #{@work_dir} && ./configure --prefix=#{@php_version_prefix} --with-php-config=#{@php_version_prefix}/bin/php-config #{@resource[:configure_params]})
  end

  # Make the module
  def make
    %x( cd #{@work_dir} && make )
    raise "Failed to build module #{@resource[:name]}" unless File.exists?("#{@work_dir}/modules/#{@resource[:compiled_name]}")
  end

  # Make the module
  def install
    %x( cp #{@work_dir}/modules/#{@resource[:compiled_name]} #{@php_version_prefix}/modules/#{@resource[:compiled_name]} )
    raise "Failed to install module #{@resource[:name]}" unless File.exists?("#{@php_version_prefix}/modules/#{@resource[:compiled_name]}")
  end

  # Define fully qualified paths to autoconf & autoheader

  def autoconf
    autoconf = "#{@resource[:homebrew_path]}/bin/autoconf"

    # We need an old version of autoconf for PHP 5.3...
    autoconf << "213" if @resource[:php_version].match(/5\.3\../)

    autoconf
  end

  def autoheader
    autoheader = "#{@resource[:homebrew_path]}/bin/autoheader"

    # We need an old version of autoheader for PHP 5.3...
    autoheader << "213" if @resource[:php_version].match(/5\.3\../)

    autoheader
  end

end
