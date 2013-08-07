# Class: fail2ban::spec
#
# This class is used only for rpsec-puppet tests
# Can be taken as an example on how to do custom classes but should not
# be modified.
#
# == Usage
#
# This class is not intended to be used directly.
# Use it as reference
#
class fail2ban::spec inherits fail2ban {

  # This just a test to override the arguments of an existing resource
  # Note that you can achieve this same result with just:
  # class { "fail2ban": template => "fail2ban/spec.erb" }

  File['fail2ban.local'] {
    content => template('fail2ban/spec.erb'),
  }

}
