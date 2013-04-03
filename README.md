# Defaults

This is a simple puppet module for managing the defaults system in OS X.

It currently has support for defaults domain keys whose values are
string, data, int, float, bool, date, array, array-add, dict and dict-add. The
default key type is string.

Refer to the [defaults(1)](https://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man1/defaults.1.html) manpage for further information on how to set key
values.

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
  user   => 'dummy',
  type   => 'int'
}
```

## Contributing

* Fork It
* Fix It
* Send a Pull Request
