require "remote_factory_girl/version"
require 'remote_factory_girl/config'
require 'remote_factory_girl/http'
require 'remote_factory_girl/config_applier'
require 'remote_factory_girl/config_struct'
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

  def self.configure(opts = { :config_struct => ConfigStruct, :config => Config }, &block)
    config      = opts.fetch(:config_struct).block_to_hash(block)
    self.config = opts.fetch(:config).configure(config)
  end

  def self.factories(params = {}, http = Http)
    factory = RemoteFactoryGirl.new(config)
    factory.factories(params, http).to_hash
  end

  def self.create(factory_name, attributes = {}, config_applier = ConfigApplier, http = Http)
    factory = RemoteFactoryGirl.new(config)
    factory.create(factory_name, attributes, http)
    config_applier.apply_config(factory.response.to_hash, config.to_hash)
  end

  def self.config
    @config
  end

  def self.config=(config)
    @config = config
  end

  def self.reset(config = Config.new)
    self.config = config
  end
end
