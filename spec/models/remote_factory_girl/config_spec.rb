require 'remote_factory_girl/config.rb'
require 'remote_factory_girl/http.rb'
require 'remote_factory_girl/config_applier'
require 'remote_factory_girl/hash_to_dot'

describe RemoteFactoryGirl::Config do

  let(:config) { RemoteFactoryGirl::Config.new }

  describe 'initialize' do

    describe 'default configuration' do
      it 'should be configured with correct defaults' do
        expect(config.home).to eq({ :host      => nil, 
                                    :port      => nil, 
                                    :end_point => '/remote_factory_girl/home'})
        expect(config.return_response_as).to eq(:as_hash) 
        expect(config.return_with_root).to be_true 
        expect(config.return_as_active_resource).to be_false
        expect(config.https).to be_false
      end
    end
  end

  describe '#home_url' do

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

    it 'should return a url that is configured with https' do
      config.https       = true
      config.home[:host] = 'localhost'
      config.home[:port] = 5555

      expect(config.home_url).to eq('https://localhost:5555/remote_factory_girl/home')
    end
  end

  describe '#has_home?' do
    it 'should return false when host and end_point are not set' do
      config.home[:host]      = nil 
      config.home[:end_point] = nil 
      expect(config.has_home?).to be_false
    end

    it 'should return false when host is not set and end_point is set' do
      expect(config.has_home?).to be_false
    end

    it 'should return true when host and end_point is set' do
      config.home[:host]      = 'localhost'
      config.home[:end_point] = 'some_where'
      expect(config.has_home?).to be_true
    end
  end

  describe '#to_hash' do
    it 'should return a properly formatted hash' do
      config.home[:port]      = '3000'
      config.home[:host]      = 'localhost'
      config.home[:end_point] = '/some_where'

      expect(config.to_hash).to eq( { :home => { :host      => 'localhost', 
                                                 :port      => '3000', 
                                                 :end_point => '/some_where' },
                                      :home_url                  => 'http://localhost:3000/some_where',
                                      :return_response_as        => :as_hash,
                                      :return_with_root          => true,
                                      :return_as_active_resource => false })
    end
  end
end
