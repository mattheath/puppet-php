module Puppet::Parser::Functions
  newfunction(:php_require) do |args|
    Puppet::Parser::Functions.function('require')
    function_require( [ ['php', args[0].split('.').join('_')].join('::') ] )
  end
end
