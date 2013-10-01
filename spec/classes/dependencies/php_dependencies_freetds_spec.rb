require 'spec_helper'

describe "php::dependencies::freetds" do
  let(:facts) { default_test_facts }

  it do
    should contain_homebrew__formula("freetds").with({
      :source => "puppet:///modules/php/brews/freetds.rb",
      :before => "Package[freetds]"
    })

    should contain_package("freetds").with_ensure("0.91")
  end
end
