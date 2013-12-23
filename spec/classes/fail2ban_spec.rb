require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'fail2ban' do

  let(:title) { 'fail2ban' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard installation' do
    it { should contain_package('fail2ban').with_ensure('present') }
    it { should contain_service('fail2ban').with_ensure('running') }
    it { should contain_service('fail2ban').with_enable('true') }
    it { should_not contain_file('fail2ban.local') }
    it { should_not contain_file('jail.local') }
  end

  describe 'Test jails config undefined' do
    let(:params) { {:jails_config => '' } }
    it { should_not contain_file('jail.local') }
  end

  describe 'Test jails managed throuh file - source' do
    let(:params) { {:jails_config => 'file', :jails_source => 'puppet:///modules/fail2ban/spec' } }
    it { should contain_file('jail.local').with_source('puppet:///modules/fail2ban/spec') }
    it { should contain_file('jail.local').without_content }
  end

  describe 'Test jails managed throuh file - template' do
    let(:facts) { {:operatingsystem => 'Debian' } }
    let(:params) { {:jails_config => 'file', :jails_template => 'fail2ban/jail.local.erb', :jails => 'ssh' } }
    it { should contain_file('jail.local').without_source }
    it { should contain_file('jail.local').with_content(/ssh-iptables\]
enabled  = true/) }
  end

  describe 'Test jails managed throuh file - custom template' do
    let(:params) { {:jails_config => 'file', :jails_template => 'fail2ban/spec.erb', :options => { 'opt_a' => 'value_a' } } }
    it { should contain_file('jail.local').with_content(/fqdn: rspec.example42.com/) }
    it { should contain_file('jail.local').without_source }
    it { should contain_file('jail.local').with_content(/value_a/) }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('fail2ban').with_ensure('1.0.42') }
  end

  describe 'Test standard installation with monitoring' do
    let(:params) { {:monitor => true } }
    it { should contain_package('fail2ban').with_ensure('present') }
    it { should contain_service('fail2ban').with_ensure('running') }
    it { should contain_service('fail2ban').with_enable('true') }
    it { should_not contain_file('fail2ban.local') }
    it { should_not contain_file('jail.local') }
    it { should contain_monitor__process('fail2ban_process').with_enable('true') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true, :monitor => true } }
    it 'should remove Package[fail2ban]' do should contain_package('fail2ban').with_ensure('absent') end
    it 'should stop Service[fail2ban]' do should contain_service('fail2ban').with_ensure('stopped') end
    it 'should not enable at boot Service[fail2ban]' do should contain_service('fail2ban').with_enable('false') end
    it 'should remove fail2ban configuration file' do should contain_file('fail2ban.local').with_ensure('absent') end
    it { should contain_monitor__process('fail2ban_process').with_enable('false') }
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:disable => true, :monitor => true } }
    it { should contain_package('fail2ban').with_ensure('present') }
    it 'should stop Service[fail2ban]' do should contain_service('fail2ban').with_ensure('stopped') end
    it 'should not enable at boot Service[fail2ban]' do should contain_service('fail2ban').with_enable('false') end
    it { should_not contain_file('fail2ban.local') }
    it { should_not contain_file('jail.local') }
    it { should contain_monitor__process('fail2ban_process').with_enable('false') }
  end

  describe 'Test decommissioning - disableboot' do
    let(:params) { {:disableboot => true, :monitor => true } }
    it { should contain_package('fail2ban').with_ensure('present') }
    it { should_not contain_service('fail2ban').with_ensure('present') }
    it { should_not contain_service('fail2ban').with_ensure('absent') }
    it 'should not enable at boot Service[fail2ban]' do should contain_service('fail2ban').with_enable('false') end
    it { should_not contain_file('fail2ban.local') }
    it { should_not contain_file('jail.local') }
    it { should contain_monitor__process('fail2ban_process').with_enable('false') }
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true, :monitor => true } }
    it { should contain_package('fail2ban').with_noop('true') }
    it { should contain_service('fail2ban').with_noop('true') }
    it { should contain_file('fail2ban.local').with_noop('true') }
    it { should contain_monitor__process('fail2ban_process').with_noop('true') }
    it { should contain_monitor__process('fail2ban_process').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "fail2ban/spec.erb" , :options => { 'opt_a' => 'value_a' } } }
    it 'should generate a valid template' do
      should contain_file('fail2ban.local').with_content(/fqdn: rspec.example42.com/)
    end
    it 'should generate a template that uses custom options' do
      should contain_file('fail2ban.local').with_content(/value_a/)
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet:///modules/fail2ban/spec"} }
    it { should contain_file('fail2ban.local').with_source('puppet:///modules/fail2ban/spec') }
  end

  describe 'Test customizations - source_dir' do
    let(:params) { {:source_dir => "puppet:///modules/fail2ban/dir/spec" , :source_dir_purge => true } }
    it { should contain_file('fail2ban.dir').with_source('puppet:///modules/fail2ban/dir/spec') }
    it { should contain_file('fail2ban.dir').with_purge('true') }
    it { should contain_file('fail2ban.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) do
      {
        :my_class => "fail2ban::spec",
        :template => "fail2ban/spec.erb"
      }
    end
    it { should contain_file('fail2ban.local').with_content(/rspec.example42.com/) }
  end

  describe 'Test service autorestart' do
    let(:params) do
      { 
        :service_autorestart => "no",
        :template => "fail2ban/spec.erb"
      }
    end
    it 'should not automatically restart the service, when service_autorestart => false' do
      should contain_file('fail2ban.local').with_notify(nil)
    end
  end

  describe 'Test Puppi Integration' do
    let(:params) { {:puppi => true, :puppi_helper => "myhelper"} }
    it { should contain_puppi__ze('fail2ban').with_helper('myhelper') }
  end

  describe 'Test Monitoring Tools Integration' do
    let(:params) { {:monitor => true, :monitor_tool => "puppi" } }
    it { should contain_monitor__process('fail2ban_process').with_tool('puppi') }
  end

  describe 'Test OldGen Module Set Integration' do
    let(:params) { {:monitor => "yes" , :monitor_tool => "puppi", :puppi => "yes" } }
    it { should contain_monitor__process('fail2ban_process').with_tool('puppi') }
    it { should contain_puppi__ze('fail2ban').with_ensure('present') }
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => true , :ipaddress => '10.42.42.42' } }
    it 'should honour top scope global vars' do should contain_monitor__process('fail2ban_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :fail2ban_monitor => true , :ipaddress => '10.42.42.42' } }
    it 'should honour module specific vars' do should contain_monitor__process('fail2ban_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :fail2ban_monitor => true , :ipaddress => '10.42.42.42' } }
    it 'should honour top scope module specific over global vars' do should contain_monitor__process('fail2ban_process').with_enable('true') end
  end

  describe 'Test params lookup' do
    let(:facts) { { :monitor => false , :ipaddress => '10.42.42.42' } }
    let(:params) { { :monitor => true } }
    it 'should honour passed params over global vars' do should contain_monitor__process('fail2ban_process').with_enable('true') end
  end

end

