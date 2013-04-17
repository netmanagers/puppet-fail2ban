# Define: fail2ban::jail
#
# Adds a custom fail2ban jail
# Supported arguments:
# $jailname - The name you want to give the jail. If not set, defaults to == $title
# $order    - The order in the jail.local file. Default 50. Generally you don't need to change it
# $status   - enabled / disabled. If disabled, the rule _IS ADDED_  to the jail.local file
#             but it will not be active. Compare with the next one.
# $enable   - true / false. If false, the rule _IS NOT ADDED_ to the jail.local file
# $filter   - The filter rule to use. If empty, defaults to == $jailname.
# $port     - The port to filter. It can be an array of ports.
# $action   - The action to take when
# $logpath  - The log file to monitor
# $maxretry - How many fails are acceptable
# $bantime  - How much time to apply the ban, in seconds

define fail2ban::jail (
  $jailname  = '',
  $order     = '',
  $status    = '',
  $filter    = '',
  $port      = '',
  $action    = '',
  $logpath   = '',
  $maxretry  = '',
  $bantime   = '',
  $enable    = true ) {

  include fail2ban
  include concat::setup

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

  # If we don't specify a filter, we take as a default the jailname as filtername
  $real_filter = $filter ? {
    ''      => $real_jailname,
    default => $filter,
  }

  $array_port = is_array($port) ? {
    false     => $port ? {
      ''      => [],
      default => [$port],
    },
    default   => $port,
  }

  $array_action = is_array($action) ? {
    false     => $action ? {
      ''      => [],
      default => [$action],
    },
    default   => $action,
  }

  $real_logpath = $logpath ? {
    ''      => '',
    default => $logpath,
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

  concat::fragment{ "fail2ban_jail_$name":
    ensure  => $ensure,
    target  => $fail2ban::jails_file,
    content => template('fail2ban/concat/jail.local-stanza.erb'),
    order   => $real_order,
    notify  => Service['fail2ban'],
  }
}
