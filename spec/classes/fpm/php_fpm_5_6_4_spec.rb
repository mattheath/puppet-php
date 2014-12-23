require 'spec_helper'

describe "php::fpm::5_6_4" do
  let(:facts) { default_test_facts }

  it do
    should contain_php__fpm("5.6.4")
  end
end
