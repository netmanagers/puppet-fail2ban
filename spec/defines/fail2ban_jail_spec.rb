require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'fail2ban::jail' do

  let(:title) { 'fail2ban::jail' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42', :jails_file => '/etc/fail2ban/jail.local', :concat_basedir => '/var/lib/puppet/concat'} }

  describe 'Test basic jail.local is created' do
    let(:params) { { :name     => 'sample1',
                     :port     => '42',
                     :logpath  => '/path/to/somelog',
                     :enable   => true,
                     :findtime => '9000', } }

    it { should include_class('concat::setup') }
#    it { should contain_concat__fragment('fail2ban_jail_sample1').with_target('/etc/fail2ban/jail.local').with_content(/*port     = 42
#logpath  = \/path\/to\/somelog*/) }
    it { should contain_concat__fragment('fail2ban_jail_sample1').with_target('/etc/fail2ban/jail.local').with_content("##################\n[fail2ban::jail]\nenabled  = true\nfilter   = fail2ban::jail\nport     = 42\nlogpath  = /path/to/somelog\nfindtime = 9000\n\n") }
  end
end
