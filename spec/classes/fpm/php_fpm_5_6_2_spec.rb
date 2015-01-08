require 'spec_helper'

describe "php::fpm::5_6_2" do
  let(:facts) { default_test_facts }

  it do
    should contain_php__fpm("5.6.2")
  end
end
