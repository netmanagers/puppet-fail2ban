# Define: fail2ban::filter
#
# Adds a custom fail2ban filter
# Documentation: Manpages & http://www.fail2ban.org/wiki/index.php/MANUAL_0_8
#
# Supported arguments:
# $filtername - The name you want to give the filter.
#               If not set, defaults to == $title
#               filter local file is named after this value, like
#               $name.local. The suffix "local" is automatically added.
#
# $filterenable     - true / false. If false, the rule _IS NOT ADDED_ to the
#               filter.local file
#               Defaults to true
#
# $filtersource     - Sets the content of source parameter for the new filter
#               It's mutually exclusive with $template.
#
# $filtertemplate   - Template to use when defining a new filter
#               It's mutually exclusive with $source.
#
# $filterfailregex      - command(s) executed when the jail failregexs.
#               Can be an array
#               Used only with $template
#
# $filterignoreregex       - command(s) executed when the jail ignoreregexs.
#               Can be an array
#               Used only with $template
#
# $filterbefore - indicates an filter file that is read before the
#                 [Definition] section.
#
# $filterafter  - indicates an filter file is read after the
#                 [Definition] section.
#
# $filterdefinitionvars   - Variables for the INIT stanza of the filter file.
#               They are tuples in the format
#                  "var = value"
#               Can be an array like
#               [ "var1 = value1", "var2 = value2",.., "varN = valueN" ]
#
define fail2ban::filter (
  $filtername     = '',
  $filtersource   = '',
  $filtertemplate = 'fail2ban/filter.local.erb',
  $filterfailregex    = '',
  $filterignoreregex     = '',
  $filterbefore   = '',
  $filterafter    = '',
  $filterdefinitionvars = '',
  $filterenable   = true ) {

  include fail2ban

  $real_filtername = $filtername ? {
    ''      => $title,
    default => $filtername,
  }

  $filter_file = "${fail2ban::data_dir}/filter.d/${real_filtername}.local"

  $array_failregex = is_array($filterfailregex) ? {
    false     => $filterfailregex ? {
      ''      => [],
      default => [$filterfailregex],
    },
    default   => $filterfailregex,
  }

  $array_ignoreregex = is_array($filterignoreregex) ? {
    false     => $filterignoreregex? {
      ''      => [],
      default => [$filterignoreregex],
    },
    default   => $filterignoreregex,
  }

  $array_definitionvars = is_array($filterdefinitionvars) ? {
    false     => $filterdefinitionvars? {
      ''      => [],
      default => [$filterdefinitionvars],
    },
    default   => $filterdefinitionvars,
  }

  $ensure = bool2ensure($filterenable)

  $manage_file_source = $filtersource ? {
    ''        => undef,
    default   => $filtersource,
  }

  $manage_file_content = $filtertemplate ? {
    ''        => undef,
    default   => $filtersource ? {
      ''        => template($filtertemplate),
      default   => undef,
    }
  }

  file { "${real_filtername}.local":
    ensure  => $fail2ban::manage_file,
    path    => $filter_file,
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
