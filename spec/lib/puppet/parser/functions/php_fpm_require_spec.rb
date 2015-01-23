require 'spec_helper'

describe "the php_fpm_require function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  it "should exist" do
    Puppet::Parser::Functions.function("php_fpm_require").should == "function_php_fpm_require"
  end
end
