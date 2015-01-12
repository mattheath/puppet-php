require 'spec_helper'

describe "php::composer" do
  let(:facts) { default_test_facts }

  it do
    should contain_class("php")

    should contain_exec("download-php-composer").with({
      :command => "curl -sS -o /test/boxen/phpenv/bin/composer https://getcomposer.org/download/1.0.0-alpha9/composer.phar",
      :unless  => "[ -f /test/boxen/phpenv/bin/composer ] && [ \"`md5 -q /test/boxen/phpenv/bin/composer`\" = \"05df355b5277c8c9012470e699fa5494\" ]",
      :cwd     => "/test/boxen/phpenv",
      :require => "Exec[phpenv-setup-root-repo]"
    })

    should contain_file("/test/boxen/phpenv/bin/composer").with({
      :mode => "0755"
    })
  end
end
