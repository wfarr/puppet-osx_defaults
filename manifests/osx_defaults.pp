define osx_defaults(
  $ensure = 'present',
  $domain = undef,
  $key    = undef,
  $value  = undef,
  $user   = undef,
  $host   = undef,
) {
  $defaults_cmd = "/usr/bin/defaults"

  if $host != undef {
    if $host == 'currentHost' {
      $defaults_cmd = "${defaults_cmd} -currentHost"
    } else {
      $defaults_cmd = "${defaults_cmd} -host ${host}"
    }
  }

  if $ensure == 'present' {
    if ($domain != undef) and ($key != undef) and ($value != undef) {
      exec { "osx_defaults write ${domain}:${key}=>${value}":
        command => "${defaults_cmd} write ${domain} ${key} ${value}",
        unless  => "${defaults_cmd} read ${domain} ${key}|egrep '^${value}$'",
        user    => $user
      }
    } else {
      warn("Cannot ensure present without domain, key, and value attributes")
    }
  } else {
    exec { "osx_defaults delete ${domain}:${key}":
      command => "${defaults_cmd} delete ${domain} ${key}",
      onlyif  => "${defaults_cmd} read ${domain} | grep ${key}",
      user    => $user
    }
  }
}
