require 'spec_helper'

describe "php::5_5" do
  let(:facts) { default_test_facts }

  it do
    should contain_class("php")
    should contain_class("php::5_5_0")

    should contain_file("/test/boxen/phpenv/versions/5.5").with({
      :ensure => "symlink",
      :force  => true,
      :target => "/test/boxen/phpenv/versions/5.5.0"
    })
  end
end
