require 'spec_helper'

describe "php::5_3_17" do
  let(:facts) { default_test_facts }

  it do
    should contain_php__version("5.3.17")
  end
end
