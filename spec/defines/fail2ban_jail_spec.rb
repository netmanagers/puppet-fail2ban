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

    it 'should create a named jail, enabled and with a filter of the same name' do
      should contain_concat__fragment('fail2ban_jail_sample1').with_target('/etc/fail2ban/jail.local').with_content(expected)
    end
  end

  describe 'Test jail.local is created with all options' do
    let(:params) do
      {
        :name     => 'sample1',
        :port     => ['42', '43'],
        :protocol => 'udp',
        :logpath  => '/path/to/somelog',
        :enable   => true,
        :ignoreip => [ '10.3.2.0/24', '192.168.56.0/24' ],
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
ignoreip = 10.3.2.0/24 192.168.56.0/24
port     = 42,43
protocol = udp
action   = iptables[name=SSH, port=ssh, protocol=tcp]
	mail-whois[name=SSH, dest=yourmail@mail.com]
logpath  = /path/to/somelog
maxretry = 5
bantime  = 3600
findtime = 9000

"
    end

    it 'should create a customized jail, with own actions parsing a single log file' do
      should contain_concat__fragment('fail2ban_jail_sample1').with_target('/etc/fail2ban/jail.local').with_content(expected)
    end
  end
  describe 'Test jail.local is created with multiple logpaths' do
    let(:params) do
      {
        :name     => 'title_sample2',
        :jailname => 'sample2',
        :port     => '44',
        :logpath  => [ '/path/to/somelog_1', '/path/to/somelog_2' ],
        :bantime  => '3003',
      }
    end
    let(:expected) do
"##################
[sample2]
enabled  = true
filter   = sample2
port     = 44
logpath  = /path/to/somelog_1
	/path/to/somelog_2
bantime  = 3003

"
    end

    it 'should create a customized jail, with own actions parsing a single log file' do
      should contain_concat__fragment('fail2ban_jail_title_sample2').with_target('/etc/fail2ban/jail.local').with_content(expected)
    end
  end
end
