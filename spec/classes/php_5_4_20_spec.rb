require 'spec_helper'

describe "php::5_4_20" do
  let(:facts) { default_test_facts }

  it do
    should contain_php__version("5.4.20")
  end
end
