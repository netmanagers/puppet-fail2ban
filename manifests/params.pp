# Class: fail2ban::params
#
# This class defines default parameters used by the main module class fail2ban
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to fail2ban class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class fail2ban::params {

  ### Application related parameters

  $package = $::osfamily ? {
    default => 'fail2ban',
  }

  $service = $::osfamily ? {
    default => 'fail2ban',
  }

  $service_status = $::osfamily ? {
    default => true,
  }

  $process = $::osfamily ? {
    'Debian' => 'fail2ban-server',
    'RedHat' => 'fail2ban-server',
    default  => 'fail2ban',
  }

  $process_args = $::osfamily ? {
    default => '',
  }

  $process_user = $::osfamily ? {
    default => 'fail2ban',
  }

  $config_dir = $::osfamily ? {
    default => '/etc/fail2ban',
  }

  $config_file = $::osfamily ? {
    default => '/etc/fail2ban/fail2ban.local',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
  }

  # Define how you want to manage jails configuration:
  # "file" - To provide jails stanzas as a normal file
  # "concat" - To build them up using different fragments
  #          - This option, preferred, permits the use of the
  #            fail2ban::jail define
  $jails_config = ''

  $jails_file = $::osfamily ? {
    default => '/etc/fail2ban/jail.local',
  }

  $jails_file_mode = $::osfamily ? {
    default => '0644',
  }

  $jails_file_owner = $::osfamily ? {
    default => 'root',
  }

  $jails_file_group = $::osfamily ? {
    default => 'root',
  }

  $config_file_init = $::osfamily ? {
    'Debian' => '/etc/default/fail2ban',
    default  => '/etc/sysconfig/fail2ban',
  }

  $pid_file = $::osfamily ? {
    'Debian' => '/var/run/fail2ban/fail2ban.pid',
    default  => '/var/run/fail2ban.pid',
  }

  $data_dir = $::osfamily ? {
    default => '/etc/fail2ban',
  }

  $log_dir = $::osfamily ? {
    default => '/var/log/fail2ban',
  }

  $log_file = $::osfamily ? {
    default => '/var/log/fail2ban/fail2ban.log',
  }

  $log_level = '3'
  $socket    = '/var/run/fail2ban/fail2ban.sock'

  $ignoreip  = ['127.0.0.1/8']
  $bantime   = '600'
  $findtime  = '600'
  $maxretry  = '5'
  $backend   = 'auto'
  $mailto    = "hostmaster@${::domain}"
  $banaction = 'iptables-multiport'
  $mta       = 'sendmail'
  $jails_protocol  = 'tcp'
  $jails_chain     = 'INPUT'

  $jails = ''
  $jails_source = ''
  $jails_template = ''
  $jails_template_header = 'fail2ban/concat/jail.local-header.erb'
  $jails_template_footer = 'fail2ban/concat/jail.local-footer.erb'

  # General Settings
  $my_class = ''
  $source = ''
  $template = ''
  $source_dir = ''
  $source_dir_purge = false
  $source_dir_owner = 'root'
  $source_dir_group = 'root'
  $options = ''
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false
  $noops = undef

}
