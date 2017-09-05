# Create a fact named :role based on the hostname.

if Facter.value(:hostname) =~ /^selenium-grid$/
  Facter.add(:role) do
    confine :virtual => 'virtualbox'
    setcode do
      'selenium_grid_developers'
    end
  end

elsif Facter.value(:hostname) =~ /^planet4$/
  Facter.add(:role) do
    confine :virtual => 'virtualbox'
    setcode do
      'planet4_aio'
    end
  end

else
  Facter.add(:role) do
    setcode do
      'default'
    end
  end

end
