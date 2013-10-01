require 'spec_helper'

describe "php::fpm::5_4_5" do
  let(:facts) { default_test_facts }

  it do
    should contain_php__fpm("5.4.5")
  end
end
