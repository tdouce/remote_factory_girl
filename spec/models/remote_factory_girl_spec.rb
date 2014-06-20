require 'remote_factory_girl'

describe RemoteFactoryGirl do

  let(:config) { double('config', :to_hash => {}) }

  describe '#create' do
    it 'should send a post request' do
      http       = double('RemoteFactoryGirl::Http')
      attributes = { :first_name => 'Sam' }
      expect(http).to receive(:post).with(config, {:factory => 'user', :attributes => { :first_name => 'Sam'}})
      RemoteFactoryGirl::RemoteFactoryGirl.new(config).create('user', attributes, http)
    end
  end

  describe '#apply_config' do
    it 'should apply config options to json with supplied configuration' do
      attributes     = { :first_name => 'Sam' }
      config_applier = double('RemoteFactoryGirl::ConfigApplier')
      response       = double('RemoteFactoryGirl::Http', :to_hash => {})
      RemoteFactoryGirl::Http.stub(:post).and_return(response)
      expect(config_applier).to receive(:apply_config).with(response.to_hash, config.to_hash)
      remote_factory_girl = RemoteFactoryGirl::RemoteFactoryGirl.new(config)
      remote_factory_girl.create('user', attributes)
      remote_factory_girl.apply_config(config_applier)
    end
  end

  it 'should be able to configure with a block' do
    pending
  end

  describe '.config' do
    it 'should be able to set and get config' do
      config = double('config')
      RemoteFactoryGirl.config = config
      expect(RemoteFactoryGirl.config).to equal(config)
    end
  end

  describe '.reset' do
    it 'should be able to reset the configuration' do
      config = double('config')
      RemoteFactoryGirl.config = config
      RemoteFactoryGirl.reset(double('config'))
      expect(RemoteFactoryGirl.config).to_not equal(config)
    end
  end

  describe '.create' do
    describe 'when not returning active resource object' do
      pending
    end

    describe 'when returning active resource object' do
      pending
    end
  end
end
