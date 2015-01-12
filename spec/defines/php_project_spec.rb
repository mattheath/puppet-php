require 'spec_helper'

describe "php::project" do
  let(:facts) { default_test_facts }
  let(:title) { "testproject" }
  let(:default_test_params) do
    {
      :source => "testuser/testproject-repo"
    }
  end
  let(:params) { default_test_params }

  it do
    should contain_class("boxen::config")
    should contain_repository("/Users/testuser/src/testproject").with({
      :source => "testuser/testproject-repo"
    })

    should_not contain_class("elasticsearch")
    should_not contain_class("memcached")
    should_not contain_class("mongodb")
    should_not contain_class("cassandra")
    should_not contain_class("beanstalk")
    should_not contain_class("zookeeper")
    should_not contain_class("zeromq")
    should_not contain_class("nsq")

    should_not contain_mysql__db

    should_not contain_class("nginx::config")
    should_not contain_class("nginx")
    should_not contain_file("/test/boxen/config/nginx/sites/testproject.conf")

    should_not contain_nodejs__local("/Users/testuser/src/testproject")

    should_not contain_postgresql__db

    should_not contain_class("redis")

    should_not contain_ruby__local("/Users/testuser/src/testproject")

    should_not contain_php__local("/Users/testuser/src/testproject")
    should_not contain_php__fpm__pool("testproject-5.4.17")
  end

  context "dotenv => true" do
    let(:params) do
      default_test_params.merge({
        :dotenv => "true"
      })
    end

    it do
      should contain_file("/Users/testuser/src/testproject/.env").with({
        :source  => "puppet:///modules/projects/testproject/dotenv",
        :require => "Repository[/Users/testuser/src/testproject]"
      })
    end
  end

  context "elasticsearch => true" do
    let(:pre_condition) { "class elasticsearch {}" }
    let(:params) do
      default_test_params.merge({
        :elasticsearch => "true"
      })
    end

    it { should contain_class("elasticsearch") }
  end

  context "memcached => true" do
    let(:pre_condition) { "class memcached {}" }
    let(:params) do
      default_test_params.merge({
        :memcached => "true"
      })
    end

    it { should contain_class("memcached") }
  end

  context "mongodb => true" do
    let(:pre_condition) { "class mongodb {}" }
    let(:params) do
      default_test_params.merge({
        :mongodb => "true"
      })
    end

    it { should contain_class("mongodb") }
  end

  context "cassandra => true" do
    let(:pre_condition) { "class cassandra {}" }
    let(:params) do
      default_test_params.merge({
        :cassandra => "true"
      })
    end

    it { should contain_class("cassandra") }
  end

  context "beanstalk => true" do
    let(:pre_condition) { "class beanstalk {}" }
    let(:params) do
      default_test_params.merge({
        :beanstalk => "true"
      })
    end

    it { should contain_class("beanstalk") }
  end

  context "zookeeper => true" do
    let(:pre_condition) { "class zookeeper {}" }
    let(:params) do
      default_test_params.merge({
        :zookeeper => "true"
      })
    end

    it { should contain_class("zookeeper") }
  end

  context "zeromq => true" do
    let(:pre_condition) { "class zeromq {}" }
    let(:params) do
      default_test_params.merge({
        :zeromq => "true"
      })
    end

    it { should contain_class("zeromq") }
  end

  context "nsq => true" do
    let(:pre_condition) { "class nsq {}" }
    let(:params) do
      default_test_params.merge({
        :nsq => "true"
      })
    end

    it { should contain_class("nsq") }
  end

  context "mysql => a_database_name" do
    let(:params) do
      default_test_params.merge({
        :mysql => "a_database_name"
      })
    end

    it { should contain_mysql__db("a_database_name") }
  end

  context "nginx => php/nginx/nginx.conf.erb" do
    let(:params) do
      default_test_params.merge({
        :nginx => "php/nginx/nginx.conf.erb"
      })
    end

    it do
      should contain_class("nginx::config")
      should contain_class("nginx")

      should contain_file("/test/boxen/config/nginx/sites/testproject.conf").with({
        :content => File.read("spec/fixtures/nginx.conf"),
        :require => "File[/test/boxen/config/nginx/sites]",
        :notify  => "Service[dev.nginx]"
      })
    end
  end

  context "nodejs => v0.10" do
    let(:pre_condition) { "define nodejs::local($version = undef, $path = $title, $ensure = present) {}" }
    let(:params) do
      default_test_params.merge({
        :nodejs => "v0.10"
      })
    end

    it do
      should contain_nodejs__local("/Users/testuser/src/testproject").with({
        :version => "v0.10",
        :require => "Repository[/Users/testuser/src/testproject]"
      })
    end
  end

  context "postgresql => a_database_name" do
    let(:pre_condition) do
      <<-EOF
        class sysctl {}
        define sysctl::set($value) {}
      EOF
    end
    let(:params) do
      default_test_params.merge({
        :postgresql => "a_database_name"
      })
    end

    it { should contain_postgresql__db("a_database_name") }
  end

  context "redis => true" do
    let(:pre_condition) { "class redis {}" }
    let(:params) do
      default_test_params.merge({
        :redis => "true"
      })
    end

    it { should contain_class("redis") }
  end

  context "ruby => 2.0.0" do
    let(:pre_condition) { "define ruby::local($version = undef, $path = $title, $ensure = present) {}" }
    let(:params) do
      default_test_params.merge({
        :ruby => "2.0.0"
      })
    end

    it do
      should contain_ruby__local("/Users/testuser/src/testproject").with({
        :version => "2.0.0",
        :require => "Repository[/Users/testuser/src/testproject]"
      })
    end
  end

  context "php => 5.4.17" do
    let(:params) do
      default_test_params.merge({
        :php   => "5.4.17",
        :nginx => "php/nginx/nginx.conf.erb"
      })
    end

    it do
      should contain_php__local("/Users/testuser/src/testproject").with({
        :version => "5.4.17",
        # :require => "Repository[/Users/testuser/src/testproject]"
      })

      should contain_php__fpm__pool("testproject-5.4.17").with({
        :version     => "5.4.17",
        :socket_path => "/test/boxen/data/project-sockets/testproject",
        # :require     => "File[/test/boxen/config/nginx/sites/testproject.conf]"
      })
    end
  end
end
