require 'spec_helper'

describe "the php_require function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  it "should exist" do
    Puppet::Parser::Functions.function("php_require").should == "function_php_require"
  end
end
