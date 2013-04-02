define osx_defaults(
  $ensure = 'present',
  $domain = undef,
  $key    = undef,
  $value  = undef,
  $host   = undef,
  $user   = 'root',
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
