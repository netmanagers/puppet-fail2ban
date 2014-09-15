# Define: fail2ban::jail
#
# Adds a custom fail2ban jail
# Supported arguments:
# $jailname - The name you want to give the jail.
#             If not set, defaults to == $title
# $order    - The order in the jail.local file.
#             Default 50. Generally you don't need to change it
# $status   - enabled / disabled. If disabled, the rule _IS ADDED_  to the
#             jail.local file but it will not be active. Compare with the
#             next one.
#             Defaults to enabled
# $enable   - true / false. If false, the rule _IS NOT ADDED_ to the
#             jail.local file
#             Defaults to true
# $filter   - The filter rule to use.
#             If empty, defaults to == $jailname.
# $ignoreip - Don't ban a host which matches an address in this list.
# $port     - The port to filter. It can be an array of ports.
# $protocol - The protocol for this jail's action.
# $logpath  - The log file to monitor
# $maxretry - How many fails are acceptable
# $action   - The action to take when fail2ban finds $maxretry $filter-matching
#             records in $logpath
# $bantime  - How much time to apply the ban, in seconds
# $findtime - The counter is set to zero if no match is found within "findtime"
#             seconds.

define fail2ban::jail (
  $jailname  = '',
  $order     = '',
  $status    = '',
  $filter    = '',
  $ignoreip  = '',
  $port      = '',
  $protocol  = '',
  $action    = '',
  $logpath   = '',
  $maxretry  = '',
  $bantime   = '',
  $findtime  = '',
  $enable    = true ) {

  include fail2ban

  $real_jailname = $jailname ? {
    ''      => $title,
    default => $jailname,
  }

  # If (concat) order is not defined we find out the right one
  $real_order = $order ? {
    ''      => '50',
    default => $order,
  }

  $real_status = $status ? {
    /(?i:disabled)/ => false,
    default         => true,
  }

  # If we don't specify a filter, we take as a default the
  # jailname as filtername
  $real_filter = $filter ? {
    ''      => $real_jailname,
    default => $filter,
  }

  $array_ignoreip = is_array($ignoreip) ? {
    false     => $ignoreip ? {
      ''      => [],
      default => [$ignoreip],
    },
    default   => $ignoreip,
  }

  $array_port = is_array($port) ? {
    false     => $port ? {
      ''      => [],
      default => [$port],
    },
    default   => $port,
  }

  $real_protocol = $protocol ? {
    ''      => undef,
    default => $protocol,
  }

  $array_action = is_array($action) ? {
    false     => $action ? {
      ''      => [],
      default => [$action],
    },
    default   => $action,
  }

  $array_logpath = is_array($logpath) ? {
    false     => $logpath ? {
      ''      => [],
      default => [$logpath],
    },
    default   => $logpath,
  }

  $real_maxretry = $maxretry ? {
    ''      => '',
    default => $maxretry,
  }

  $real_bantime = $bantime ? {
    ''      => '',
    default => $bantime,
  }

  $ensure = bool2ensure($enable)


  if ! defined(Concat[$fail2ban::jails_file]) {

    concat { $fail2ban::jails_file:
      mode    => $fail2ban::jails_file_mode,
      warn    => true,
      owner   => $fail2ban::jails_file_owner,
      group   => $fail2ban::jails_file_group,
      notify  => Service['fail2ban'],
      require => Package[$fail2ban::package],
    }

    concat::fragment{ 'fail2ban_jails_header':
      target  => $fail2ban::jails_file,
      content => template($fail2ban::jails_template_header),
      order   => 01,
      notify  => Service['fail2ban'],
    }

    # The jail.local footer
    concat::fragment{ 'fail2ban_jails_footer':
      target  => $fail2ban::jails_file,
      content => template($fail2ban::jails_template_footer),
      order   => 99,
      notify  => Service['fail2ban'],
    }
  }
  concat::fragment{ "fail2ban_jail_${name}":
    ensure  => $ensure,
    target  => $fail2ban::jails_file,
    content => template('fail2ban/concat/jail.local-stanza.erb'),
    order   => $real_order,
    notify  => Service['fail2ban'],
  }
}
