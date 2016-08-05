require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.before(:each) do
	# work around https://tickets.puppetlabs.com/browse/PUP-1547
	# ensure that there's at least one provider available by emulating that any command exists
	if Puppet::version < '3.4'
  	  # ONLY WORKING WITH PUPPET 2.X !!
  	  require 'puppet/provider/confine/exists'
  	  Puppet::Provider::Confine::Exists.any_instance.stubs(:which => '')
	else
  	  # ONLY WORKING WITH PUPPET 3.X !!
  	  require 'puppet/confine/exists'
  	  Puppet::Confine::Exists.any_instance.stubs(:which => '')
	end
	# avoid "Only root can execute commands as other users"
	Puppet.features.stubs(:root? => true)
	if ENV['PUPPET_DEBUG'] == '1'
  	  Puppet::Util::Log.level = :warning
  	  Puppet::Util::Log.newdestination(:console)
	end
	if ENV['PUPPET_DEBUG'] == '2'
  	  Puppet::Util::Log.level = :debug
  	  Puppet::Util::Log.newdestination(:console)
	end
  end
  c.mock_with :mocha
end

RSpec.shared_context "osfacts" do
  let(:facts) {{
	:kernel             	=> 'Linux',
	:ipaddress          	=> '192.168.0.1',
	:osfamily           	=> 'RedHat',
	:operatingsystem    	=> 'RedHat',
	:operatingsystemrelease => '6',
	:operatingsystemmajrelease => '6',
	:augeasversion => '0.10.0',
	:fqdn => 'rspec.b428.dvla.gov.uk'
	}}
end
