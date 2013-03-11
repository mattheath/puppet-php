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

  newparam(:version) do
    defaultto '>= 0'
  end

end
