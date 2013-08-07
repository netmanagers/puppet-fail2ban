# Puppet module: fail2ban

This is a Puppet module for fail2ban based on the second generation layout ("NextGen") of Example42 Puppet Modules.

Made by Javier Bértoli / Netmanagers

Official site: http://www.netmanagers.com.ar

Official git repository: http://github.com/netmanagers/puppet-fail2ban

Released under the terms of Apache 2 License.

This module depends on R.I.Pienaar's concat module (https://github.com/ripienaar/puppet-concat).

This module requires functions provided by the Example42 Puppi module (you need it even if you don't use and install Puppi)

For detailed info about the logic and usage patterns of Example42 modules check the DOCS directory on Example42 main modules set.

## USAGE - Basic management

* All parameters can be set using Hiera. See the manifests to see what can be set.

* Install fail2ban with default settings. No configuration changes are done, and distro defaults are
  respected.

        class { 'fail2ban': }

* Configure jails using your own jail.local file

        class { 'fail2ban':
          jails_config => 'file',
          jails_source => 'puppet:///path/to/your/jail.local'.
        }

* Configure jails using a template file. An example is provided. In this case, you can enable or
  disable jails using an array named "jails". See the template "jail.local.erb".

        class { 'fail2ban':
          jails_config   => 'file',
          jails_template => 'fail2ban/jail.local.erb',
          jails          => ['ssh', 'imap'],
        }

* You can configure and set a jail using fail2ban::jail. In this case, stanzas for jail.local are
  created using R.I.Pienaar's concat module. This method permits you better handling of your jails.

        class { 'fail2ban':
          jails_config   => 'concat',
        }

        fail2ban::jail { 'sshd':
          port     => '22',
          logpath  => '/var/log/secure',
          maxretry => '2',
        }

* Install a specific version of fail2ban package

        class { 'fail2ban':
          version => '1.0.1',
        }

* Disable fail2ban service.

        class { 'fail2ban':
          disable => true
        }

* Remove fail2ban package

        class { 'fail2ban':
          absent => true
        }

* Enable auditing without without making changes on existing fail2ban configuration *files*

        class { 'fail2ban':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'fail2ban':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'fail2ban':
          source => [ "puppet:///modules/example42/fail2ban/fail2ban.local-${hostname}" , "puppet:///modules/example42/fail2ban/fail2ban.local" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'fail2ban':
          source_dir       => 'puppet:///modules/example42/fail2ban/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative.
  In this new version, and following fail2ban recommendations, fail2ban.conf is untouched and 
  fail2ban.local is created instead, overriding parameters.

        class { 'fail2ban':
          template => 'example42/fail2ban/fail2ban.local.erb',
        }

* Automatically include a custom subclass

        class { 'fail2ban':
          my_class => 'example42::my_fail2ban',
        }


## USAGE - Example42 extensions management 
* Activate puppi (recommended, but disabled by default)

        class { 'fail2ban':
          puppi    => true,
        }

* Activate puppi and use a custom puppi_helper template (to be provided separately with a puppi::helper define ) to customize the output of puppi commands 

        class { 'fail2ban':
          puppi        => true,
          puppi_helper => 'myhelper', 
        }

* Activate automatic monitoring (recommended, but disabled by default). This option requires the usage of Example42 monitor and relevant monitor tools modules

        class { 'fail2ban':
          monitor      => true,
          monitor_tool => [ 'nagios' , 'monit' , 'munin' ],
        }

* Activate automatic firewalling. This option requires the usage of Example42 firewall and relevant firewall tools modules

        class { 'fail2ban':       
          firewall      => true,
          firewall_tool => 'iptables',
          firewall_src  => '10.42.0.0/24',
          firewall_dst  => $ipaddress_eth0,
        }


## CONTINUOUS TESTING

Travis {<img src="https://travis-ci.org/netmanagers/puppet-fail2ban.png?branch=master" alt="Build Status" />}[https://travis-ci.org/netmanagers/puppet-fail2ban]
