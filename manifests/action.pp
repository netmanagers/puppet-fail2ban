# Define: fail2ban::action
#
# Adds a custom fail2ban action
# Documentation: Manpages & http://www.fail2ban.org/wiki/index.php/MANUAL_0_8
#
# Supported arguments:
# $actionname     - The name you want to give the action.
#                   If not set, defaults to == $title
#                   action local file is named after this value, like
#                   $actionname.local. The suffix "local" is automatically added.
#
# $actionenable   - true / false. If false, the rule _IS NOT ADDED_ to the
#                   action.local file
#                   Defaults to true
#
# $actionsource   - Sets the content of source parameter for the new action
#                   It's mutually exclusive with $actiontemplate.
#
# $actiontemplate - Template to use when defining a new action
#                   It's mutually exclusive with $actionsource.
#
# $actionstart    - command(s) executed when the jail starts.
#                   Can be an array
#                   Used only with $actiontemplate
#
# $actionstop     - command(s) executed when the jail stops.
#                   Can be an array
#                   Used only with $actiontemplate
#
# $actioncheck    - the command ran before any other action.
#                   It aims to verify if the environment is still ok.
#                   Used only with $actiontemplate
#
# $actionban      - command(s) that bans the IP address after maxretry
#                   log lines matches within last findtime seconds.
#                   Used only with $actiontemplate
#
# $actionunban    - command(s) that unbans the IP address after bantime.
#                   Used only with $actiontemplate
#
# $actionbefore   - indicates an action file that is read before the
#                   [Definition] section.
#
# $actionafter    - indicates an action file is read after the
#                   [Definition] section.
#
# $actioninitvars - Variables for the INIT stanza of the action file.
#                   They are tuples in the format
#                       "var = value"
#                   Can be an array like
#                   [ "var1 = value1", "var2 = value2",.., "varN = valueN" ]
#
define fail2ban::action (
  $actionname     = '',
  $actionsource   = '',
  $actiontemplate = 'fail2ban/action.local.erb',
  $actionstart    = '',
  $actionstop     = '',
  $actioncheck    = '',
  $actionban      = '',
  $actionunban    = '',
  $actionbefore   = '',
  $actionafter    = '',
  $actioninitvars = '',
  $actionenable   = true ) {

  include fail2ban

  $real_actionname = $actionname ? {
    ''      => $title,
    default => $actionname,
  }

  $action_file = "${fail2ban::data_dir}/action.d/${real_actionname}.local"

  $array_start = is_array($actionstart) ? {
    false     => $actionstart ? {
      ''      => [],
      default => [$actionstart],
    },
    default   => $actionstart,
  }

  $array_stop = is_array($actionstop) ? {
    false     => $actionstop? {
      ''      => [],
      default => [$actionstop],
    },
    default   => $actionstop,
  }

  $array_check = is_array($actioncheck) ? {
    false     => $actioncheck? {
      ''      => [],
      default => [$actioncheck],
    },
    default   => $actioncheck,
  }

  $array_ban = is_array($actionban) ? {
    false     => $actionban? {
      ''      => [],
      default => [$actionban],
    },
    default   => $actionban,
  }

  $array_unban = is_array($actionunban) ? {
    false     => $actionunban? {
      ''      => [],
      default => [$actionunban],
    },
    default   => $actionunban,
  }

  $array_initvars = is_array($actioninitvars) ? {
    false     => $actioninitvars? {
      ''      => [],
      default => [$actioninitvars],
    },
    default   => $actioninitvars,
  }

  $ensure = bool2ensure($actionenable)

  $manage_file_source = $actionsource ? {
    ''        => undef,
    default   => $actionsource,
  }

  $manage_file_content = $actiontemplate ? {
    ''        => undef,
    default   => template($actiontemplate),
  }

  file { "${real_actionname}.local":
    ensure  => $fail2ban::manage_file,
    path    => $action_file,
    mode    => $fail2ban::config_file_mode,
    owner   => $fail2ban::config_file_owner,
    group   => $fail2ban::config_file_group,
    require => Package[$fail2ban::package],
    notify  => $fail2ban::manage_service_autorestart,
    source  => $manage_file_source,
    content => $manage_file_content,
    replace => $fail2ban::manage_file_replace,
    audit   => $fail2ban::manage_audit,
    noop    => $fail2ban::noops,
  }

}
