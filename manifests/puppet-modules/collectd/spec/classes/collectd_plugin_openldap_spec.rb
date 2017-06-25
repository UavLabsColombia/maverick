require 'spec_helper'

describe 'collectd::plugin::openldap', type: :class do
  ######################################################################
  # Default param validation, compilation succeeds
  let :facts do
    {
      osfamily: 'RedHat',
      collectd_version: '4.8.0',
      operatingsystemmajrelease: '7',
      python_dir: '/usr/local/lib/python2.7/dist-packages'
    }
  end

  context ':ensure => present, default params' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.4',
        operatingsystemmajrelease: '7',
        python_dir: '/usr/local/lib/python2.7/dist-packages'
      }
    end

    it 'Will create /etc/collectd.d/10-openldap.conf' do
      is_expected.to contain_file('openldap.load').with(ensure: 'present',
                                                        path: '/etc/collectd.d/10-openldap.conf',
                                                        content: "#\ Generated by Puppet\n<LoadPlugin openldap>\n  Globals false\n</LoadPlugin>\n\n<Plugin \"openldap\">\n  <Instance \"localhost\">\n    URL \"ldap://localhost/\"\n  </Instance>\n</Plugin>\n\n")
    end
  end

  context ':instances param is a hash' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.4',
        operatingsystemmajrelease: '7',
        python_dir: '/usr/local/lib/python2.7/dist-packages'
      }
    end

    let :params do
      { instances: { 'ldap1' => { 'url' => 'ldap://ldap1.example.com' }, 'ldap2' => { 'url' => 'ldap://ldap2.example.com' } } }
    end

    it 'Will create /etc/collectd.d/10-openldap.conf with two :instances params' do
      is_expected.to contain_file('openldap.load').with(ensure: 'present',
                                                        path: '/etc/collectd.d/10-openldap.conf',
                                                        content: "#\ Generated by Puppet\n<LoadPlugin openldap>\n  Globals false\n</LoadPlugin>\n\n<Plugin \"openldap\">\n  <Instance \"ldap1\">\n    URL \"ldap://ldap1.example.com\"\n  </Instance>\n  <Instance \"ldap2\">\n    URL \"ldap://ldap2.example.com\"\n  </Instance>\n</Plugin>\n\n")
    end
  end

  ######################################################################
  # Remaining parameter validation, compilation fails

  context ':interval is not default and is an integer' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.4',
        operatingsystemmajrelease: '7',
        python_dir: '/usr/local/lib/python2.7/dist-packages'
      }
    end
    let :params do
      { interval: 15 }
    end

    it 'Will create /etc/collectd.d/10-openldap.conf' do
      is_expected.to contain_file('openldap.load').with(ensure: 'present',
                                                        path: '/etc/collectd.d/10-openldap.conf',
                                                        content: %r{^  Interval 15})
    end
  end

  context ':ensure => absent' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.4',
        operatingsystemmajrelease: '7',
        python_dir: '/usr/local/lib/python2.7/dist-packages'
      }
    end
    let :params do
      { ensure: 'absent' }
    end

    it 'Will not create /etc/collectd.d/10-openldap.conf' do
      is_expected.to contain_file('openldap.load').with(ensure: 'absent',
                                                        path: '/etc/collectd.d/10-openldap.conf')
    end
  end
end