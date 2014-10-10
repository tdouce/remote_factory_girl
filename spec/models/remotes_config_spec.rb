require 'remote_factory_girl/remotes_config.rb'

describe RemoteFactoryGirl::Config do

  let(:remotes_config) { RemoteFactoryGirl::RemotesConfig.new }
  let(:home_1_config) { double('config') }
  let(:home_2_config) { double('config') }
  let(:default_remote_name) { RemoteFactoryGirl::RemotesConfig::DEFAULT_REMOTE_NAME }

  describe '#initialize' do
    context 'default configuration' do
      it 'should be configured with correct defaults' do
        expect(remotes_config.remotes).to eq({})
      end
    end
  end

  context 'adding a remote' do
    before do
      remotes_config.remotes[:home_1] = home_1_config
    end

    it 'should return configuration for home_1' do
      expect(remotes_config.remotes[:home_1]).to eq(home_1_config)
    end
  end

  describe '#reset' do

    let(:reset_config) { double('config') }

    before do
      remotes_config.remotes[:home_1] = home_1_config
      remotes_config.remotes[:home_2] = home_2_config
      remotes_config.reset(reset_config)
    end

    it 'should return an empty hash' do
      expect(remotes_config.to_hash).to eq({:default => reset_config })
    end
  end
end
