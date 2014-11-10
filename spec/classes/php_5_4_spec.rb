require 'spec_helper'

describe "php::5_4" do
  let(:facts) { default_test_facts }

  it do
    should contain_class("php")
    should contain_class("php::5_4_17")

    should contain_file("/test/boxen/phpenv/versions/5.4").with({
      :ensure => "symlink",
      :force  => true,
      :target => "/test/boxen/phpenv/versions/5.4.17"
    })
  end
end
