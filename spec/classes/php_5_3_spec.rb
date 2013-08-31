require 'spec_helper'

describe "php::5_3" do
  let(:facts) { default_test_facts }

  it do
    should include_class("php")
    should include_class("php::5_3_26")

    should contain_file("/test/boxen/phpenv/versions/5.3").with({
      :ensure => "symlink",
      :force  => true,
      :target => "/test/boxen/phpenv/versions/5.3.26"
    })
  end
end
