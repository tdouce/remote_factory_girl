require 'remote_factory_girl/config.rb'
require 'remote_factory_girl/http.rb'
require 'remote_factory_girl/config_applier'
require 'remote_factory_girl/hash_to_dot'

describe RemoteFactoryGirl::Config do

  describe 'initialize' do

    describe 'default configuration' do
      it 'should be configured with correct defaults' do
        config = RemoteFactoryGirl::Config.new
        expect(config.home).to eq({ :host      => nil, 
                                    :port      => nil, 
                                    :end_point => '/remote_factory_girl/home'})
        expect(config.return_response_as).to eq(:as_hash) 
        expect(config.return_with_root).to be_true 
      end
    end
  end

  describe '#home_url' do

    let(:config) { RemoteFactoryGirl::Config.new }

    it 'should return a url with port if port is configured' do
      config.home[:host] = 'localhost'
      config.home[:port] = 5555
      expect(config.home_url).to eq('http://localhost:5555/remote_factory_girl/home')
    end

    it 'should return a url without a port if port is not configured' do
      config.home[:host] = 'localhost_no_port'
      config.home[:port] = nil 
      expect(config.home_url).to eq('http://localhost_no_port/remote_factory_girl/home')
    end
  end
end
