# Defined type: osx_defaults
#
# Manages the defaults system in Mac OS X.
#
# It currently has support for defaults domain keys whose values are
# string, data, int, float, bool, date, array, array-add, dict and dict-add. The
# default key type is string.
#
# Refer to the defaults(1) manpage for further information on how to set key 
# values.
#
# Usage:
# osx_defaults {' require pass at screensaver':
#   ensure => present,
#   domain => 'com.apple.screensaver',
#   key    => 'askForPassword',
#   value  => 1,
#   user   => 'dummy',
#   type   => 'int'
# }
#
define osx_defaults(
  $ensure = 'present',
  $domain = undef,
  $key    = undef,
  $value  = undef,
  $host   = undef,
  $user   = undef,
  $type   = 'string',
) {
  $defaults_cmd = '/usr/bin/defaults'

  if $host == undef {
    $host_arg = '-currentHost'
  } else {
    $host_arg = "-host ${host}"
  }

  if $ensure == 'present' {
    if $type =~ /string|data|int|float|bool|date|array|array-add|dict|dict-add/ {
      $type_arg = "-${type}"
    } else {
      warn('Invalid type declared')
    }

    if $domain or $key or $value != undef {
      exec { "osx_defaults write ${domain}:${key}=>${value}":
        command => "${defaults_cmd} ${host_arg} write ${domain} ${type_arg} ${key} ${value}",
        unless  => "${defaults_cmd} read ${domain} ${key}|egrep '^${value}$'",
        user    => $user
      }
    } else {
      warn('Cannot ensure present without domain, key, and value attributes')
    }

  } else {
    exec { "osx_defaults delete ${domain}:${key}":
      command => "${defaults_cmd} delete ${domain} ${key}",
      onlyif  => "${defaults_cmd} read ${domain} | grep ${key}",
      user    => $user
    }
  }
}
