require 'spec_helper'

describe "php::5_3" do
  let(:facts) { default_test_facts }

  it do
    should contain_class("php")
    should contain_class("php::5_3_27")

    should contain_file("/test/boxen/phpenv/versions/5.3").with({
      :ensure => "symlink",
      :force  => true,
      :target => "/test/boxen/phpenv/versions/5.3.27"
    })
  end
end
