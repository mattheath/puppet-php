require 'spec_helper'

describe "php::fpm::5_3_28" do
  let(:facts) { default_test_facts }

  it do
    should contain_php__fpm("5.3.28")
  end
end
