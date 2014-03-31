require 'virtus'
require 'remote_factory_girl/config.rb'
require 'remote_factory_girl/http.rb'
require 'remote_factory_girl/response_parser'
require 'remote_factory_girl/config_struct'
require 'remote_factory_girl/hash_to_dot'

describe RemoteFactoryGirl::Config do

  describe 'initialize' do

    describe '.configure' do
      it 'should be able to set configurations' do
        config  = RemoteFactoryGirl::Config.configure({ :home => { :host => 'tifton', :port => 9999, :end_point => '/somewhere' },
                                                        :return_response_as => :as_dot_notation,
                                                        :return_with_root => false })
        expect(config.home).to eq({ :host      => 'tifton', 
                                    :port      => 9999, 
                                    :end_point => '/somewhere'})
        expect(config.return_response_as).to eq(:as_dot_notation) 
        expect(config.return_with_root).to be_false
      end
    end

    describe 'default configuration' do
      it 'should be configured with correct defaults' do
        config = RemoteFactoryGirl::Config.new
        expect(config.home).to eq({ :host      => nil, 
                                    :port      => nil, 
                                    :end_point => 'remote_factory_girl_homes'})
        expect(config.return_response_as).to eq(:as_hash) 
        expect(config.return_with_root).to be_true 
      end
    end

    describe '#home_url' do

      let(:config) { RemoteFactoryGirl::Config.new }

      it 'should return a url with port if port is configured' do
        config.home[:host] = 'localhost'
        config.home[:port] = 5555
        expect(config.home_url).to eq('http://localhost:5555/remote_factory_girl_homes')
      end

      it 'should return a url without a port if port is not configured' do
        config.home[:host] = 'localhost_no_port'
        config.home[:port] = nil 
        expect(config.home_url).to eq('http://localhost_no_port/remote_factory_girl_homes')
      end
    end
  end
end
