module Puppet::Parser::Functions
  newfunction(:php_require) do |args|
    Puppet::Parser::Functions.function('ensure_resource')
    function_ensure_resource( [ 'php::version', args[0], {'ensure' => 'present'} ] )
  end
end
