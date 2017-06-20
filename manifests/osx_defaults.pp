define osx_defaults(
  $ensure = 'present',
  $domain = undef,
  $key    = undef,
  $value  = undef,
  $user   = undef,
  $host   = "",
) {
  $defaults_cmd = "/usr/bin/defaults"
  if $host == "local" {
    $hostarg="-currentHost"
  }elsif $host != ""{
    $hostarg="-host $host"
  }else{
    $hostarg=""
  }
  
  if $ensure == 'present' {
    if ($domain != undef) and ($key != undef) and ($value != undef) {
      exec { "osx_defaults write ${domain}:${key}=>${value}":
        command => "${defaults_cmd} $hostarg write ${domain} '${key}' ${value}",
        unless  => "${defaults_cmd} $hostarg read ${domain} '${key}'|egrep '^${value}$'",
        user    => $user
      }
    } else {
      notify { "osx_defaults_warn":
        message => "Cannot ensure present without domain, key, and value attributes",
      }

    }
  } else {
    exec { "osx_defaults delete ${domain}:${key}":
      command => "${defaults_cmd} $hostarg delete ${domain} '${key}'",
      onlyif  => "${defaults_cmd} $hostarg read ${domain} | grep ${key}",
      user    => $user
    }
  }
}

