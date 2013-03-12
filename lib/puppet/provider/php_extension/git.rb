require 'puppet/util/execution'

Puppet::Type.type(:php_extension).provide(:git) do
  include Puppet::Util::Execution
  desc "Provides PHP extensions compiled from a git repository"

  # Build and install our PHP extension
  def create

    # Let's get a few things straight
    @work_dir = "#{@resource[:cache_dir]}/#{@resource[:extension]}"
    @php_version_prefix = "#{@resource[:phpenv_root]}/versions/#{@resource[:php_version]}"

    # Update the repository
    fetch @resource[:version], @resource[:extension]

    # Prepare for building
    prep_build @resource[:version]

    # PHPize, build & install
    phpize
    configure
    make
    install
  end

  def destroy
    FileUtils.rm_rf "#{@resource[:phpenv_root]}/versions/#{@resource[:php_version]}/modules/#{@resource[:extension]}.so"
  end

  def exists?
    File.exists? "#{@resource[:phpenv_root]}/versions/#{@resource[:php_version]}/modules/#{@resource[:extension]}.so"
  end

protected

  # Update the cached git repository
  def fetch(version, extension)
    # Check if tag exists in current repo, if not fetch & recheck
    if !version_present_in_cache?(version)
      update_repository
      raise "Version #{version} not found in #{extension} source" if !version_present_in_cache?(version)
    end
  end

  # Update and fetch new tags from the remote repository
  #
  def update_repository
    %x( cd #{@work_dir} && git fetch --tags )
  end

  # Check for a specific version within the source repository
  #
  def version_present_in_cache?(version)
    tag = %x( cd #{@work_dir} && git tag -l "#{version}" )
    tag.strip == "#{version}"
  end

  # Prepare the source repository for building by checkout out the correct
  # tag, and cleaning the source tree
  #
  def prep_build(version)
    # Reset back to master and ensure the build branch is removed
    %x( cd #{@work_dir} && git checkout -f master && git branch -D build &> /dev/null )

    # Checkout version as build branch
    %x( cd #{@work_dir} && git checkout #{version} -b build )

    # Clean everything
    %x( cd #{@work_dir} && git clean -f -d -x )
  end

  # PHPize the extension, using the correct version of PHP
  def phpize
    %x( cd #{@work_dir} && #{@php_version_prefix}/bin/phpize )
  end

  # Configure with the correct version of php-config and prefix and any additional configure parameters
  def configure
    %x( cd #{@work_dir} && ./configure --prefix=#{@php_version_prefix} --with-php-config=#{@php_version_prefix}/bin/php-config #{@resource[:configure_params]})
  end

  # Make the module
  def make
    puts %x( cd #{@work_dir} && make )

    raise "Failed to build module #{@resource[:name]}" unless File.exists?("#{@work_dir}/modules/#{@resource[:compiled_name]}")
  end

  # Make the module
  def install
    %x( cp #{@work_dir}/modules/#{@resource[:compiled_name]} #{@php_version_prefix}/modules/#{@resource[:compiled_name]} )

    raise "Failed to install module #{@resource[:name]}" unless File.exists?("#{@php_version_prefix}/modules/#{@resource[:compiled_name]}")
  end

end
