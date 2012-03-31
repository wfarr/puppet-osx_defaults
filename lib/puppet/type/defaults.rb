Puppet::Type.newtype(:defaults) do
  ensurable

  newparam(:name, :namevar => true)
  newparam(:domain)
  newparam(:key)
  newparam(:value)
end
