require 'spec_helper'

describe "php::5_5_20" do
  let(:facts) { default_test_facts }

  it do
    should contain_php__version("5.5.20")
  end
end
