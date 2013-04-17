#
# Class fail2ban::file
#
# This class configures fail2ban via a base rule file
# The file itselt is not provided. Use this class (or, better,
# your custom $my_project class that inherits this) to
# manage the fail2ban file in the way you want
#
# It's used if $fail2ban_config = "file"
#
class fail2ban::file inherits fail2ban {

  if $fail2ban::manage_file_jails_source or $fail2ban::manage_file_jails_template {
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
      noop    => $fail2ban::bool_noops,
    }
  }
}
