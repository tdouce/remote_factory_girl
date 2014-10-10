require "remote_factory_girl/version"
require 'remote_factory_girl/config'
require 'remote_factory_girl/remotes_config'
require 'remote_factory_girl/http'
require 'remote_factory_girl/config_applier'
require 'remote_factory_girl/hash_to_dot'
require 'remote_factory_girl/json_to_active_resource'

module RemoteFactoryGirl
  class RemoteFactoryGirl

    attr_reader :config, :response

    def initialize(config)
      @config = config
    end

    def create(factory, attributes = {}, http = Http)
      @response ||= http.post(config, { factory: factory, attributes: attributes })
    end

    def factories(attributes = {}, http = Http)
      @response ||= http.get(config, attributes)
    end
  end

  def self.configure(remote_name = remotes_config.default_remote_name, config = Config, &block)
    configuration = Config.new
    yield(configuration)
    remotes_config.add_remote(configuration, remote_name)
  end

  def self.factories(params = {}, http = Http)
    config_for_remote = config(remotes_config.current_remote)
    factory = RemoteFactoryGirl.new(config_for_remote)
    factory.factories(params, http).to_hash
  end

  def self.create(factory_name, attributes = {}, config_applier = ConfigApplier, http = Http)
    config_for_remote = config(remotes_config.current_remote)
    factory = RemoteFactoryGirl.new(config_for_remote)
    factory.create(factory_name, attributes, http)
    config_applier.apply_config(factory.response.to_hash, config_for_remote.to_hash)
  end

  def self.with_remote(remote_name = remotes_config.default_remote_name)
    remotes_config.current_remote = remote_name
    self
  end

  def self.config=(config, remote_name = remotes_config.default_remote_name)
    remotes_config.add_remote(config, remote_name)
  end

  def self.config(remote_name = remotes_config.default_remote_name)
    remotes_config.config_for(remote_name)
  end

  def self.remotes_config
    @remotes_config ||= RemotesConfig.new
  end
end
