require 'spec_helper'

describe "php::composer" do
  let(:facts) { default_test_facts }

  it do
    should include_class("php")

    should contain_exec("download-php-composer").with({
      :command => "curl -sS -o /test/boxen/phpenv/bin/composer http://getcomposer.org/download/1.0.0-alpha7/composer.phar",
      :unless  => "[ -f /test/boxen/phpenv/bin/composer ] && [ \"`md5 -q /test/boxen/phpenv/bin/composer`\" = \"ef51599395560988ea3e16912bfd70f8\" ]",
      :cwd     => "/test/boxen/phpenv",
      :require => "Exec[phpenv-setup-root-repo]"
    })

    should contain_file("/test/boxen/phpenv/bin/composer").with({
      :mode => "0755"
    })
  end
end
