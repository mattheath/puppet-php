require 'spec_helper'

describe "php::composer" do
  let(:facts) { default_test_facts }

  it do
    should include_class("php")

    should contain_exec("download-php-composer").with({
      :command => "curl -sS -o /test/boxen/phpenv/bin/composer https://getcomposer.org/download/1.0.0-alpha8/composer.phar",
      :unless  => "[ -f /test/boxen/phpenv/bin/composer ] && [ \"`md5 -q /test/boxen/phpenv/bin/composer`\" = \"df1001975035f07d09307bf1f1e62584\" ]",
      :cwd     => "/test/boxen/phpenv",
      :require => "Exec[phpenv-setup-root-repo]"
    })

    should contain_file("/test/boxen/phpenv/bin/composer").with({
      :mode => "0755"
    })
  end
end
