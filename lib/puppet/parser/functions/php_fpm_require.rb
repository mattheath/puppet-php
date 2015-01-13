module Puppet::Parser::Functions
  newfunction(:php_fpm_require) do |args|
    Puppet::Parser::Functions.function('ensure_resource')
    function_ensure_resource( [ 'php::fpm', args[0] ] )
  end
end
