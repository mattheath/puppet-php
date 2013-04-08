require 'puppet/util/execution'

Puppet::Type.type(:php_version).provide(:php_source) do
  include Puppet::Util::Execution
  desc "Provides PHP versions compiled from the official source code repository"

  def create
    # Not removing all pear.conf and .pearrc files from PHP path results in
    # the PHP configure not properly setting the pear binary to be installed
    # Source: https://github.com/josegonzalez/homebrew-php/blob/master/Formula/abstract-php.rb
    home_path = @resource[:user_home]
    user_pear = "#{home_path}/pear.conf"
    user_pearrc = "#{home_path}/.pearrc"
    if File.exists?(user_pear) || File.exists?(user_pearrc)
      puts "Backing up all known pear.conf and .pearrc files"
      FileUtils.mv(user_pear, "#{user_pear}-backup") if File.exists? user_pear
      FileUtils.mv(user_pearrc, "#{user_pearrc}-backup") if File.exists? user_pearrc
    end

    begin
      install "#{@resource[:version]}"
      FileUtils.rm_f("#{user_pear}-backup") if File.exists? "#{user_pear}-backup"
      FileUtils.rm_f("#{user_pearrc}-backup") if File.exists? "#{user_pearrc}-backup"
    rescue Exception => e

      # Clean up the failed install
      destroy

      # Move PEAR files back into place
      FileUtils.mv("#{user_pear}-backup", user_pear) if File.exists? "#{user_pear}-backup"
      FileUtils.mv("#{user_pearrc}-backup", user_pearrc) if File.exists? "#{user_pearrc}-backup"

      # Rethrow error
      throw e
    end
  end

  def destroy
    puts "DESTROYING PHP #{@resource[:version]}"
    FileUtils.rm_rf "#{@resource[:phpenv_root]}/versions/#{@resource[:version]}"
  end

  def exists?
    # First check if the version folder exists
    does_exist = File.directory? "#{@resource[:phpenv_root]}/versions/#{@resource[:version]}"

    # We also want to ensure that all of the binaries exist
    required_binaries = %w(php phpize php-config pear pecl)
    required_binaries.map { |bin|
      does_exist &&= File.exists? "#{@resource[:phpenv_root]}/versions/#{@resource[:version]}/bin/#{bin}"
    }

    # Including php-fpm if the version is >= 5.3.3
    # This will fix previously broken installs
    does_exist &&= File.exists? "#{@resource[:phpenv_root]}/versions/#{@resource[:version]}/sbin/php-fpm" unless @resource[:version].match(/\A5\.3\.[12]\z/)

    does_exist
  end

  def install(version)

    # First destroy any prior installation to avoid conflicts
    # We'll only be installing if the exists method has failed so has determined nothing is installed here
    # This does mean if new binaries are added to the required list in the exists check, it's likely all
    # installed versions of PHP will be reinstalled - running destroy should ensure this proceeds as expected
    destroy

    # First check we have a cached copy of the source repository, with this version tag
    confirm_cached_source(version)

    # Checkout the version as a build branch and prepare for building
    prep_build(version)

    # Configure - this is the hard part
    puts "Installing PHP #{@resource[:version]}, this may take a while..."
    configure(version)

    # Make & install
    make
    make_install
    make_clean

    # Ensure we've actually installed something...
    raise "Failed to install PHP #{@resource[:version]}" unless exists?

    # Fix permissions
    puts %x( chown -R #{@resource[:user]}:staff #{@resource[:phpenv_root]}/versions/#{@resource[:version]} )
  end

  private

  # Check that the cached repository is in place, and the version requested exists
  # as a tag in the repository
  #
  def confirm_cached_source(version)
    raise "Source repository is not present" if !File.directory?("#{@resource[:phpenv_root]}/php-src/.git")

    # Check if tag exists in current repo, if not fetch & recheck
    if !version_present_in_cache?(version)
      update_repository
      raise "Version #{version} not found in PHP source" if !version_present_in_cache?(version)
    end
  end

  # Update and fetch new tags from the remote repository
  #
  def update_repository
    %x( cd #{@resource[:phpenv_root]}/php-src/ && git fetch --tags )
  end

  # Check for a specific version within the PHP source repository
  #
  def version_present_in_cache?(version)
    tag = %x( cd #{@resource[:phpenv_root]}/php-src/ && git tag -l "php-#{version}" )
    tag.strip == "php-#{version}"
  end

  # Prepare the source repository for building by checkout out the correct
  # tag, and cleaning the source tree
  #
  def prep_build(version)
    # Reset back to master and ensure the build branch is removed
    %x( cd #{@resource[:phpenv_root]}/php-src/ && git checkout -f master && git branch -D build &> /dev/null )

    # Checkout version as build branch
    %x( cd #{@resource[:phpenv_root]}/php-src/ && git checkout php-#{version} -b build )

    # Clean everything
    %x( cd #{@resource[:phpenv_root]}/php-src/ && git clean -f -d -x )
  end

  # Configure our version of PHP for compilation
  #
  def configure(version)

    # Final bit of cleanup, just in case
    %x( cd #{@resource[:phpenv_root]}/php-src/ && rm -rf configure autom4te.cache )

    # Run buildconf to prepare build system for compilation
    puts "export PHP_AUTOCONF=#{autoconf} && export PHP_AUTOHEADER=#{autoheader} && cd #{@resource[:phpenv_root]}/php-src/ && ./buildconf --force"
    puts %x( export PHP_AUTOCONF=#{autoconf} && export PHP_AUTOHEADER=#{autoheader} && cd #{@resource[:phpenv_root]}/php-src/ && ./buildconf --force )
    exit_code = $?

    # Ensure buildconf exited successfully
    unless exit_code == 0
      puts "Buildconf exit code: #{exit_code}\n\n"
      raise "Error occured while running buildconf for PHP #{@resource[:version]}"
    end

    # Build configure options
    install_path = "#{@resource[:phpenv_root]}/versions/#{@resource[:version]}"
    config_path = "/opt/boxen/config/php/#{@resource[:version]}"
    args = get_configure_args(version, install_path, config_path)
    args = args.join(" ")

    # Right, the hard part - configure for our system
    puts "Configuring PHP #{version}: #{args}"
    puts %x( cd #{@resource[:phpenv_root]}/php-src/ && export ac_cv_exeext='' && ./configure #{args} )
    exit_code = $?

    # Ensure Configure exited successfully
    unless exit_code == 0
      puts "Configure exit code: #{exit_code}\n\n"
      raise "Error occured while configuring PHP #{@resource[:version]}"
    end

    # Configure should create a Makefile - we need this
    raise "Could not configure PHP #{@resource[:version]} - no makefile" unless File.exists? "#{@resource[:phpenv_root]}/php-src/Makefile"
  end

  def make
    puts %x( cd #{@resource[:phpenv_root]}/php-src/ && make )
    raise "Could not compile PHP @resource[:version]" unless $? == 0
  end

  def make_install
    puts %x( cd #{@resource[:phpenv_root]}/php-src/ && make install )
    raise "Could not install PHP @resource[:version]" unless $? == 0
  end

  def make_clean
    puts %x( cd #{@resource[:phpenv_root]}/php-src/ && make clean )
  end


  # Get a default set of configure options
  #
  def get_configure_args(version, install_path, config_path)

    args = [
      "--prefix=#{install_path}",
      "--localstatedir=/var",
      "--sysconfdir=#{config_path}",
      "--with-config-file-path=#{config_path}",
      "--with-config-file-scan-dir=#{config_path}/conf.d",

      "--with-iconv-dir=/usr",
      "--enable-dba",
      "--with-ndbm=/usr",
      "--enable-exif",
      "--enable-soap",
      "--enable-wddx",
      "--enable-ftp",
      "--enable-sockets",
      "--enable-zip",
      "--enable-pcntl",
      "--enable-shmop",
      "--enable-sysvsem",
      "--enable-sysvshm",
      "--enable-sysvmsg",
      "--enable-mbstring",
      "--enable-mbregex",
      "--enable-bcmath",
      "--enable-calendar",
      "--with-ldap",
      "--with-ldap-sasl=/usr",
      "--with-xmlrpc",
      "--with-kerberos=/usr",
      "--with-xsl=/usr",
      "--with-gd",
      "--enable-gd-native-ttf",
      "--with-freetype-dir=#{@resource[:homebrew_path]}/opt/freetype",
      "--with-jpeg-dir=#{@resource[:homebrew_path]}/opt/jpeg",
      "--with-png-dir=#{@resource[:homebrew_path]}/opt/libpng",
      "--with-gettext=#{@resource[:homebrew_path]}/opt/gettext",
      "--with-gmp=#{@resource[:homebrew_path]}/opt/gmp",
      "--with-zlib=#{@resource[:homebrew_path]}/opt/zlibphp",
      "--with-snmp=/usr",
      "--with-libedit",
      "--with-libevent-dir=#{@resource[:homebrew_path]}/opt/libevent",
      "--with-mhash",
      "--with-curl",
      "--with-openssl=/usr",
      "--with-bz2=/usr",

      "--with-mysql-sock=/tmp/mysql.sock",
      "--with-mysqli=mysqlnd",
      "--with-mysql=mysqlnd",
      "--with-pdo-mysql=mysqlnd",

    ]

    # PHP-FPM isn't available until 5.3.3
    args << "--enable-fpm" unless @resource[:version].match(/\A5\.3\.[12]\z/)

    args
  end

  def autoconf
    autoconf = "#{@resource[:homebrew_path]}/bin/autoconf"

    # We need an old version of autoconf for PHP 5.3...
    autoconf << "213" if @resource[:version].match(/5\.3\../)

    autoconf
  end

  def autoheader
    autoheader = "#{@resource[:homebrew_path]}/bin/autoheader"

    # We need an old version of autoheader for PHP 5.3...
    autoheader << "213" if @resource[:version].match(/5\.3\../)

    autoheader
  end

end
