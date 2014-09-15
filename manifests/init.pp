# = Class: fail2ban
#
# This is the main fail2ban class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, fail2ban class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $fail2ban_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   (fail2ban.local)
#   If defined, fail2ban main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $fail2ban_source
#
# [*source_dir*]
#   If defined, the whole fail2ban.configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $fail2ban_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $fail2ban_source_dir_purge
#
# [*source_dir_owner*]
#   Configuration directory owner
#   Default: root
#
# [*source_dir_group*]
#   Configuration directory group
#   Default: root
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, fail2ban main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $fail2ban_template
#
# [*ignoreip*]
#   Fail2ban will not ban a host which matches an address in this list.
#   Can an IP address, a CIDR mask or a DNS host. Several addresses can be
#   definedin an array.
#   Default: 127.0.0.1/8
#
# [*bantime*]
#   Value in seconds that a host is banned
#   Default: 600
#
# [*maxretry*]
#   Is the number of failures before a host get banned.
#   Default: 5
#
# [*findtime*]
#   A host is banned if it has generated "maxretry" during the last "findtime"
#   seconds.
#   Default: 600
#
# [*backend*]
#   Specifies the backend used to get files modification.
#   Available options are "gamin", "polling" and "auto".
#   Default: auto
#
# [*mailto*]
#   Destination email address used solely for the interpolations in
#   jail.{conf,local} configuration files.
#   Default: "hostmaster@${::domain}"
#
# [*banaction*]
#   Default banning action (e.g. iptables, iptables-new, iptables-multiport,
#   shorewall, etc) It is used to define action_* variables.
#   Can be overridden globally or per section within jail.local file
#   Default: iptables-multiport
#
# [*mta*]
#   Since 0.8.1 upstream fail2ban uses sendmail MTA for the mailing.
#   Change mta configuration parameter to 'mail' if you want to revert
#   to conventional 'mail'.
#   Default: sendmail
#
# [*jails_file*]
#   Path to 'jail.local' file
#   Default: /etc/fail2ban/jail.local
#
# [*jails_config*]
#   Define how you want to manage jails configuration:
#    "file"   - To provide jail.local as a normal file. If you choose this
#               option,set ONE of [*jails_source*] or [*jails_template*]
#    "concat" - To build it up using different fragments
#             - This option, (preferred), permits the use of the
#               fail2ban::jail define
#   Default: empty. Uses "jail.local" from distribution, if any.
#
# [*jails_source*]
#   Sets the content of source parameter for the jail.local configuration file
#
# [*jails_template*]
#   Sets the path to the template to use as content for the jail.local
#   configuration file
#   If defined, fail2ban jails config file has:
#      content => content("$jails_template")
#   Note source and template parameters are mutually exclusive: don't use both
#
# [*jails*]
#   When using [*jails_template*] you can have some control on what jail is
#   enabled or not setting an array named "jails", containing the names of the
#   jail you want enabled.
#
# [*jails_template_header*]
#   Path to the template to use as header with concat
#   Used by fail2ban::jails
#
# [*jails_template_footer*]
#   Path to the template to use as footer with concat
#   Used by fail2ban::jails
#
# [*jails_protocol*]
#   Default: tcp
#
# [*jails_chain*]
#   Specify chain where jumps would need to be added in iptables-* actions
#   Default: INPUT
#
# [*options*]
#   A hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $fail2ban_options
#
# [*service_autorestart*]
#   Automatically restarts the fail2ban service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $fail2ban_absent
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $fail2ban_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $fail2ban_disableboot
#
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#   Can be defined also by the (top scope) variables $fail2ban_monitor
#   and $monitor
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for fail2ban checks
#   Can be defined also by the (top scope) variables $fail2ban_monitor_tool
#   and $monitor_tool
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#   Can be defined also by the (top scope) variables $fail2ban_monitor_target
#   and $monitor_target
#
# [*puppi*]
#   Set to 'true' to enable creation of module data files that are used by puppi
#   Can be defined also by the (top scope) variables $fail2ban_puppi and $puppi
#
# [*puppi_helper*]
#   Specify the helper to use for puppi commands. The default for this module
#   is specified in params.pp and is generally a good choice.
#   You can customize the output of puppi commands for this module using another
#   puppi helper. Use the define puppi::helper to create a new custom helper
#   Can be defined also by the (top scope) variables $fail2ban_puppi_helper
#   and $puppi_helper
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $fail2ban_debug and $debug
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $fail2ban_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: undef
#
# Default class params - As defined in fail2ban::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of fail2ban package
#
# [*service*]
#   The name of fail2ban service
#
# [*service_status*]
#   If the fail2ban service init script supports status argument
#
# [*process*]
#   The name of fail2ban process
#
# [*process_args*]
#   The name of fail2ban arguments. Used by puppi and monitor.
#   Used only in case the fail2ban process name is generic (java, ruby...)
#
# [*process_user*]
#   The name of the user fail2ban runs with. Used by puppi and monitor.
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*config_file_init*]
#   Path of configuration file sourced by init script
#
# [*pid_file*]
#   Path of pid file. Used by monitor
#
# [*data_dir*]
#   Path of application data directory. Used by puppi
#
# [*log_dir*]
#   Base logs directory. Used by puppi
#
# [*log_level*]
#   Set the log level output.
#          1 = ERROR
#          2 = WARN
#          3 = INFO
#          4 = DEBUG
#   Default:  3
#
# [*log_file*]
#   Log file(s). Used by puppi also.
#
# [*socket*]
#   Socket file used by fail2ban-client to communicate with fail2ban.
#   Default: /var/run/fail2ban/fail2ban.sock
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include fail2ban"
# - Call fail2ban as a parametrized class
#
# See README for details.
#
# == Author
#   Alessandro Franceschi <al@lab42.it/>
#   Javier Bertoli <javier@netmanagers.com.ar/>
#
class fail2ban (
  $my_class              = params_lookup( 'my_class' ),
  $source                = params_lookup( 'source' ),
  $source_dir            = params_lookup( 'source_dir' ),
  $source_dir_purge      = params_lookup( 'source_dir_purge' ),
  $source_dir_owner      = params_lookup( 'source_dir_owner' ),
  $source_dir_group      = params_lookup( 'source_dir_group' ),
  $template              = params_lookup( 'template' ),
  $service_autorestart   = params_lookup( 'service_autorestart' , 'global' ),
  $options               = params_lookup( 'options' ),
  $version               = params_lookup( 'version' ),
  $absent                = params_lookup( 'absent' ),
  $disable               = params_lookup( 'disable' ),
  $disableboot           = params_lookup( 'disableboot' ),
  $monitor               = params_lookup( 'monitor' , 'global' ),
  $monitor_tool          = params_lookup( 'monitor_tool' , 'global' ),
  $monitor_target        = params_lookup( 'monitor_target' , 'global' ),
  $puppi                 = params_lookup( 'puppi' , 'global' ),
  $puppi_helper          = params_lookup( 'puppi_helper' , 'global' ),
  $firewall              = params_lookup( 'firewall' , 'global' ),
  $firewall_tool         = params_lookup( 'firewall_tool' , 'global' ),
  $firewall_src          = params_lookup( 'firewall_src' , 'global' ),
  $firewall_dst          = params_lookup( 'firewall_dst' , 'global' ),
  $debug                 = params_lookup( 'debug' , 'global' ),
  $audit_only            = params_lookup( 'audit_only' , 'global' ),
  $noops                 = params_lookup( 'noops' ),
  $package               = params_lookup( 'package' ),
  $service               = params_lookup( 'service' ),
  $service_status        = params_lookup( 'service_status' ),
  $process               = params_lookup( 'process' ),
  $process_args          = params_lookup( 'process_args' ),
  $process_user          = params_lookup( 'process_user' ),
  $config_dir            = params_lookup( 'config_dir' ),
  $config_file           = params_lookup( 'config_file' ),
  $config_file_mode      = params_lookup( 'config_file_mode' ),
  $config_file_owner     = params_lookup( 'config_file_owner' ),
  $config_file_group     = params_lookup( 'config_file_group' ),
  $config_file_init      = params_lookup( 'config_file_init' ),
  $pid_file              = params_lookup( 'pid_file' ),
  $data_dir              = params_lookup( 'data_dir' ),
  $log_dir               = params_lookup( 'log_dir' ),
  $log_file              = params_lookup( 'log_file' ),
  $log_level             = params_lookup( 'log_level' ),
  $socket                = params_lookup( 'socket' ),
  $ignoreip              = params_lookup( 'ignoreip' ),
  $bantime               = params_lookup( 'bantime' ),
  $findtime              = params_lookup( 'findtime' ),
  $maxretry              = params_lookup( 'maxretry' ),
  $backend               = params_lookup( 'backend' ),
  $mailto                = params_lookup( 'mailto' ),
  $banaction             = params_lookup( 'banaction' ),
  $mta                   = params_lookup( 'mta' ),
  $jails_config          = params_lookup( 'jails_config' ),
  $jails_protocol        = params_lookup( 'jails_protocol' ),
  $jails_chain           = params_lookup( 'jails_chain' ),
  $jails_file            = params_lookup( 'jails_file' ),
  $jails_file_mode       = params_lookup( 'jails_file_mode' ),
  $jails_file_owner      = params_lookup( 'jails_file_owner' ),
  $jails_file_group      = params_lookup( 'jails_file_group' ),
  $jails                 = params_lookup( 'jails' ),
  $jails_source          = params_lookup( 'jails_source' ),
  $jails_template        = params_lookup( 'jails_template' ),
  $jails_template_header = params_lookup( 'jails_template_header' ),
  $jails_template_footer = params_lookup( 'jails_template_footer' )
  ) inherits fail2ban::params {

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_service_autorestart=any2bool($service_autorestart)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)
  $bool_monitor=any2bool($monitor)
  $bool_puppi=any2bool($puppi)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)

  ### Definition of some variables used in the module
  $manage_package = $fail2ban::bool_absent ? {
    true  => 'absent',
    false => $fail2ban::version,
  }

  $manage_service_enable = $fail2ban::bool_disableboot ? {
    true    => false,
    default => $fail2ban::bool_disable ? {
      true    => false,
      default => $fail2ban::bool_absent ? {
        true  => false,
        false => true,
      },
    },
  }

  $manage_service_ensure = $fail2ban::bool_disable ? {
    true    => 'stopped',
    default =>  $fail2ban::bool_absent ? {
      true    => 'stopped',
      default => 'running',
    },
  }

  $manage_service_autorestart = $fail2ban::bool_service_autorestart ? {
    true    => Service[fail2ban],
    false   => undef,
  }

  $manage_file = $fail2ban::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  if $fail2ban::bool_absent == true
  or $fail2ban::bool_disable == true
  or $fail2ban::bool_disableboot == true {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  $manage_audit = $fail2ban::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $fail2ban::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $fail2ban::source ? {
    ''        => undef,
    default   => $fail2ban::source,
  }

  $manage_file_content = $fail2ban::template ? {
    ''        => undef,
    default   => template($fail2ban::template),
  }

  ### Managed resources
  package { $fail2ban::package:
    ensure => $fail2ban::manage_package,
    noop   => $fail2ban::noops,
  }

  service { 'fail2ban':
    ensure    => $fail2ban::manage_service_ensure,
    name      => $fail2ban::service,
    enable    => $fail2ban::manage_service_enable,
    hasstatus => $fail2ban::service_status,
    pattern   => $fail2ban::process,
    require   => Package[$fail2ban::package],
    noop      => $fail2ban::noops,
  }

  if $fail2ban::manage_file_source
  or $fail2ban::manage_file_content
  or $manage_file == 'absent'
  or $fail2ban::noops {
    file { 'fail2ban.local':
      ensure  => $fail2ban::manage_file,
      path    => $fail2ban::config_file,
      mode    => $fail2ban::config_file_mode,
      owner   => $fail2ban::config_file_owner,
      group   => $fail2ban::config_file_group,
      require => Package[$fail2ban::package],
      notify  => $fail2ban::manage_service_autorestart,
      source  => $fail2ban::manage_file_source,
      content => $fail2ban::manage_file_content,
      replace => $fail2ban::manage_file_replace,
      audit   => $fail2ban::manage_audit,
      noop    => $fail2ban::noops,
    }
  }

  # How to manage fail2ban jail.local configuration
  if $fail2ban::jails_config == 'file' {
    $array_jails = is_array($fail2ban::jails) ? {
      false     => $fail2ban::jails ? {
        ''      => [],
        default => [$fail2ban::jails],
      },
      default   => $fail2ban::jails,
    }

    $manage_file_jails_source = $fail2ban::jails_source ? {
      ''        => undef,
      default   => $fail2ban::jails_source,
    }

    $manage_file_jails_content = $fail2ban::jails_template ? {
      ''        => undef,
      default   => template($fail2ban::jails_template),
    }

    if $fail2ban::manage_file_jails_source
    or $fail2ban::manage_file_jails_content
    or $manage_file == 'absent'
    or $fail2ban::noops {
      file { 'jail.local':
        ensure  => $fail2ban::manage_file,
        path    => $fail2ban::jails_file,
        mode    => $fail2ban::jails_file_mode,
        owner   => $fail2ban::jails_file_owner,
        group   => $fail2ban::jails_file_group,
        require => Package[$fail2ban::package],
        notify  => $fail2ban::manage_service_autorestart,
        source  => $fail2ban::manage_file_jails_source,
        content => $fail2ban::manage_file_jails_content,
        replace => $fail2ban::manage_file_replace,
        audit   => $fail2ban::manage_audit,
        noop    => $fail2ban::noops,
      }
    }
  }

  # The whole fail2ban.configuration directory can be recursively overriden
  if $fail2ban::source_dir {
    file { 'fail2ban.dir':
      ensure  => directory,
      path    => $fail2ban::config_dir,
      require => Package[$fail2ban::package],
      notify  => $fail2ban::manage_service_autorestart,
      source  => $fail2ban::source_dir,
      recurse => true,
      purge   => $fail2ban::bool_source_dir_purge,
      owner   => $fail2ban::source_dir_owner,
      group   => $fail2ban::source_dir_group,
      force   => $fail2ban::bool_source_dir_purge,
      replace => $fail2ban::manage_file_replace,
      audit   => $fail2ban::manage_audit,
      noop    => $fail2ban::noops,
    }
  }


  ### Include custom class if $my_class is set
  if $fail2ban::my_class {
    include $fail2ban::my_class
  }


  ### Provide puppi data, if enabled ( puppi => true )
  if $fail2ban::bool_puppi == true {
    $classvars=get_class_args()
    puppi::ze { 'fail2ban':
      ensure    => $fail2ban::manage_file,
      variables => $classvars,
      helper    => $fail2ban::puppi_helper,
      noop      => $fail2ban::noops,
    }
  }


  ### Service monitoring, if enabled ( monitor => true )
  if $fail2ban::bool_monitor == true {
    if $fail2ban::port != '' {
      monitor::port { "fail2ban_${fail2ban::protocol}_${fail2ban::port}":
        protocol => $fail2ban::protocol,
        port     => $fail2ban::port,
        target   => $fail2ban::monitor_target,
        tool     => $fail2ban::monitor_tool,
        enable   => $fail2ban::manage_monitor,
        noop     => $fail2ban::noops,
      }
    }
    if $fail2ban::service != '' {
      monitor::process { 'fail2ban_process':
        process  => $fail2ban::process,
        service  => $fail2ban::service,
        pidfile  => $fail2ban::pid_file,
        user     => $fail2ban::process_user,
        argument => $fail2ban::process_args,
        tool     => $fail2ban::monitor_tool,
        enable   => $fail2ban::manage_monitor,
        noop     => $fail2ban::noops,
      }
    }
  }


  ### Debugging, if enabled ( debug => true )
  if $fail2ban::bool_debug == true {
    file { 'debug_fail2ban':
      ensure  => $fail2ban::manage_file,
      path    => "${settings::vardir}/debug-fail2ban",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
      noop    => $fail2ban::noops,
    }
  }

}
