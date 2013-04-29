#
# Class fail2ban::concat
#
# This class builds the fail2ban jails.local file using RIPienaar's concat module
# We build it using several fragments.
# Being the sequence of lines important we define these boundaries:
# 01 - General header
# Note that the fail2ban::jail define
# inserts (by default) its rules with priority 50.
#
class fail2ban::jailsconcat {

  include fail2ban
  include concat::setup

  concat { $fail2ban::jails_file:
    mode    => $fail2ban::jails_file_mode,
    owner   => $fail2ban::jails_file_owner,
    group   => $fail2ban::jails_file_group,
    notify  => Service['fail2ban'],
  }

  # The File Header. With Puppet comment
  concat::fragment{ 'fail2ban_header':
    target  => $fail2ban::jails_file,
    content => "# File Managed by Puppet\n",
    order   => 01,
    notify  => Service['fail2ban'],
  }

  # The DEFAULT header with the default policies
  concat::fragment{ 'fail2ban_jails_header':
    target  => $fail2ban::jails_file,
    content => template($fail2ban::jails_template_header),
    order   => 05,
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
