require 'spec_helper'

describe 'php' do
  let(:facts) do
    {
      :boxen_home => '/opt/boxen'
    }
  end

  it do
    should include_class('php::config')
    should include_class('homebrew')
    should include_class('wget')
    should include_class('autoconf')
    should include_class('libtool')
    should include_class('pkgconfig')
    should include_class('pcre')

    should contain_file('/opt/boxen/phpenv').with_ensure('directory')
    should contain_file('/opt/boxen/phpenv/phpenv.d').with_ensure('directory')
    should contain_file('/opt/boxen/phpenv/phpenv.d/install').with_ensure('directory')
    should contain_file('/opt/boxen/phpenv/shims').with_ensure('directory')
    should contain_file('/opt/boxen/phpenv/versions').with_ensure('directory')
    should contain_file('/opt/boxen/phpenv/libexec').with_ensure('directory')
  end
end
