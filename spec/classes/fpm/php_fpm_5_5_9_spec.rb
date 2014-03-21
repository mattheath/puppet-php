require 'spec_helper'

describe "php::fpm::5_5_9" do
  let(:facts) { default_test_facts }

  it do
    should contain_php__fpm("5.5.9")
  end
end
