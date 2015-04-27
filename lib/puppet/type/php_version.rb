Puppet::Type.newtype(:php_version) do
  @doc = "Install a version of PHP"

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

  newparam(:phpenv_version) do
  end

  newparam(:version) do
  end

  newparam(:phpenv_root) do
  end

  newparam(:homebrew_path) do
  end

  newparam(:user) do
  end

  newparam(:user_home) do
  end

  newparam(:configure_params) do
    defaultto ''
  end
end
