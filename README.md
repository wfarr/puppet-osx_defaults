# Defaults

This is a simple puppet module for managing the defaults system in OS X.

It currently has support for defaults domain keys whose values are
boolean, integer, or string types.

## Requirements

* Ruby 1.8 or 1.9
* Puppet 2.6.0 or later
* OS X

## Usage

```
osx_defaults { "require pass at screensaver":
  ensure => present,
  domain => 'com.apple.screensaver',
  key    => 'askForPassword',
  value  => 1,
  user   => 'dummy'
}
```

## Contributing

* Fork It
* Fix It
* Send a Pull Request
