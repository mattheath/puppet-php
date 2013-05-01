require 'puppet/util/execution'

Puppet::Type.type(:php_extension).provide(:php_source) do
  include Puppet::Util::Execution
  desc "Provides PHP extensions which are bundled with the PHP source code"

  # Build and install our PHP extension
  def create

    # Let's get a few things straight
    @work_dir = "#{@resource[:phpenv_root]}/php-src/ext/#{@resource[:extension]}"
    @php_version_prefix = "#{@resource[:phpenv_root]}/versions/#{@resource[:php_version]}"
    @resource[:compiled_name] ||= "#{@resource[:extension]}.so"

    # First check we have a cached copy of the php source code repository, with this version tag
    confirm_cached_source

    # Checkout the version as a build branch and prepare for building
    prep_build

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

  # Check that the cached repository is in place, and the version requested exists
  # as a tag in the repository
  #
  def confirm_cached_source
    raise "PHP Source repository is not present" if !File.directory? "#{@resource[:phpenv_root]}/php-src/.git"

    # Check if tag exists in current repo, if not fetch & recheck
    if !version_present_in_cache?
      update_repository
      raise "Version #{@resource[:php_version]} not found in PHP source" if !version_present_in_cache? version
    end
  end

  # Update and fetch new tags from the remote repository
  #
  def update_repository
    %x( cd #{@resource[:phpenv_root]}/php-src/ && git fetch --tags )
  end

  # Check for a specific version within the PHP source repository
  #
  def version_present_in_cache?
    tag = %x( cd #{@resource[:phpenv_root]}/php-src/ && git tag -l "php-#{@resource[:php_version]}" )
    tag.strip == "php-#{@resource[:php_version]}"
  end

  # Prepare the source repository for building by checking out the correct
  # tag, and cleaning the source tree
  #
  def prep_build
    # Reset back to master and ensure the build branch is removed
    %x( cd #{@resource[:phpenv_root]}/php-src/ && git checkout -f master && git branch -D build &> /dev/null )

    # Checkout version as build branch
    %x( cd #{@resource[:phpenv_root]}/php-src/ && git checkout php-#{@resource[:php_version]} -b build )

    # Clean everything
    %x( cd #{@resource[:phpenv_root]}/php-src/ && git clean -f -d -x )
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
