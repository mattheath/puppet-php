require 'spec_helper'

describe "php::5_3_8" do
  let(:facts) { default_test_facts }

  it do
    should contain_php__version("5.3.8")
  end
end
