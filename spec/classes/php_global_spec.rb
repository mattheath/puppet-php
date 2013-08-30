require 'spec_helper'

describe "php::global" do
  let(:facts) { default_test_facts }
  let(:params) do
    {
      :version => '5.4.17'
    }
  end

  it do
    should include_class("php::config")
    should include_class("php::5_4_17")

    should contain_file("/test/boxen/phpenv/version").with({
      :ensure  => "present",
      :owner   => "testuser",
      :mode    => "0644",
      :content => "5.4.17\n",
    })
  end
end
