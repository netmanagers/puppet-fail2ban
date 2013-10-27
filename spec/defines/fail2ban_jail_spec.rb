require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'fail2ban::jail' do

  let(:title) { 'fail2ban::jail' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress      => '10.42.42.42',
      :jails_file     => '/etc/fail2ban/jail.local',
      :concat_basedir => '/var/lib/puppet/concat'
    }
  end

  describe 'Test jail.local is created with no options' do
    let(:params) do
      {
        :name => 'sample1',
      }
    end
    let(:expected) do
"##################
[fail2ban::jail]
enabled  = true
filter   = fail2ban::jail

"
    end

    it { should contain_concat__fragment('fail2ban_jail_sample1').with_target('/etc/fail2ban/jail.local').with_content(expected) }
  end

  describe 'Test jail.local is created with all options' do
    let(:params) do
      {
        :name     => 'sample1',
        :port     => ['42', '43'],
        :logpath  => '/path/to/somelog',
        :enable   => true,
        :findtime => '9000',
        :maxretry => '5',
        :bantime  => '3600',
        :action   => [
          'iptables[name=SSH, port=ssh, protocol=tcp]',
          'mail-whois[name=SSH, dest=yourmail@mail.com]',
        ],
      }
    end
    let(:expected) do
"##################
[fail2ban::jail]
enabled  = true
filter   = fail2ban::jail
port     = 42,43
action   = iptables[name=SSH, port=ssh, protocol=tcp]
	mail-whois[name=SSH, dest=yourmail@mail.com]
logpath  = /path/to/somelog
maxretry = 5
bantime  = 3600
findtime = 9000

"
    end

    it { should contain_concat__fragment('fail2ban_jail_sample1').with_target('/etc/fail2ban/jail.local').with_content(expected) }
  end
end
