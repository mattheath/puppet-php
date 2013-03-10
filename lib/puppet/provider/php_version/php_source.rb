require 'puppet/util/execution'

Puppet::Type.type(:php_version).provide(:php_source) do
  include Puppet::Util::Execution
  desc ""

  def create
    install "#{@resource[:version]}"
  end

  def destroy
    raise "method 'destroy' not yet implemented"
  end

  def exists?

    false
  end

  def install(version)
    raise "method 'install' not yet implemented. version #{version}"
  end
end
