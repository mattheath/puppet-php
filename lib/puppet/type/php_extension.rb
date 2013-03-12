Puppet::Type.newtype(:php_extension) do
  @doc = "Install a PHP extension within a version of PHP"

  ensurable do
    newvalue :present do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end

    defaultto :present
  end

  newparam(:name) do
    isnamevar
  end

  newparam(:extension) do
  end

  newparam(:version) do
    defaultto '>= 0'
  end

  newparam(:package_name) do
  end

  newparam(:package_url) do
  end

  newparam(:phpenv_root) do
  end

  newparam(:php_version) do
  end

  # Occasionally compiled PECL modules have different names than the original
  # package - for example pecl_http creates http.so
  newparam(:compiled_name) do
  end

  newparam(:cache_dir) do
  end

  newparam(:configure_params) do
    defaultto ''
  end

end
