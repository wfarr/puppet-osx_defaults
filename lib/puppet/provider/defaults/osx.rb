require 'rubygems'

Puppet::Type.type(:defaults).provide(:osx) do
  desc "Manage OSX defaults"

  confine :operatingsystem => :darwin

  commands :defaults => "/usr/bin/defaults"

  def create
    type_and_val = self.class.get_type_val_string(resource[:value])
    defaults(:write, resource[:domain], resource[:key], type_and_val)
  end

  def defaults(command)
    if resource[:user]
      asuser(resource[:user]) { super }
    end
  end

  def destroy
    defaults(:delete, resource[:domain], resource[:key])
  end

  def exists?
    su_str = "su - #{resource[:user]}" if resource[:user]
    `#{su_str} /usr/bin/defaults read #{resource[:domain]} | grep '#{resource[:key]}'`
    if $? == 0
      defaults(:read, resource[:domain], resource[:key]).split(' ')[1] == resource[:value].to_s
    else
      false
    end
  end

  def self.get_type_val_string(val)
    if val.kind_of? Numeric
      "-int #{val}"
    elsif val.kind_of? String
      "-string '#{val}'"
    elsif val.kind_of?(TrueClass) || val.kind_of?(FalseClass)
      "-bool #{val}"
    else
      raise ArgumentError, "The type of #{val} is not supported"
    end
  end
end
