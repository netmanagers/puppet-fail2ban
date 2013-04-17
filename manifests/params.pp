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

  $package = $::operatingsystem ? {
    default => 'fail2ban',
  }

  $service = $::operatingsystem ? {
    default => 'fail2ban',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'fail2ban',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'fail2ban',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc/fail2ban',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/fail2ban/fail2ban.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  # Define how you want to manage jails configuration:
  # "file" - To provide jails stanzas as a normal file
  # "concat" - To build them up using different fragments
  #          - This option, set as default, permits the use of the fail2ban::jail define
  $jails_config = 'concat'

  $jails_file = $::operatingsystem ? {
    default => '/etc/fail2ban/jail.local',
  }

  $jails_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $jails_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $jails_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/fail2ban',
    default                   => '/etc/sysconfig/fail2ban',
  }

  $pid_file = $::operatingsystem ? {
    default => '/var/run/fail2ban.pid',
  }

  $data_dir = $::operatingsystem ? {
    default => '/etc/fail2ban',
  }

  $log_dir = $::operatingsystem ? {
    default => '/var/log/fail2ban',
  }

  $log_file = $::operatingsystem ? {
    default => '/var/log/fail2ban/fail2ban.log',
  }

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

  $jails = []
  $jails_source = ''
  $jails_template = ''
  $jails_template_header = 'fail2ban/concat/jail.local-header.erb'
  $jails_template_footer = 'fail2ban/concat/jail.local-footer.erb'

  $protocol  = ''
  $port = ''

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
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
  $firewall = false
  $firewall_tool = ''
  $firewall_src = '0.0.0.0/0'
  $firewall_dst = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false
  $noops = false

}
