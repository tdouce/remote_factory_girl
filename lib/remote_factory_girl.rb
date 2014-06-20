require "remote_factory_girl/version"
require 'remote_factory_girl/config'
require 'remote_factory_girl/http'
require 'remote_factory_girl/config_applier'
require'remote_factory_girl/config_struct'
require'remote_factory_girl/hash_to_dot'
require 'remote_factory_girl/json_to_active_resource'

module RemoteFactoryGirl
  class RemoteFactoryGirl

    attr_reader :name, :attributes, :config

    def initialize(name, attributes, config)
      @name       = name
      @attributes = attributes
      @config     = config
    end

    def apply_config(config_applier = ConfigApplier)
      config_applier.apply_config(post.json, config.to_hash)
    end

    def post(http = Http)
      @post ||= http.post(config, params)
    end

    def params
      { factory: name, attributes: attributes }
    end
  end

  def self.configure(opts = { :config_struct => ConfigStruct, :config => Config }, &block)
    config      = opts.fetch(:config_struct).block_to_hash(block)
    self.config = opts.fetch(:config).configure(config)
  end

  def self.create(factory, attributes = {}, config_applier = ConfigApplier, http = Http)
    factory = RemoteFactoryGirl.new(factory, attributes, config)
    factory.post(http)
    factory.apply_config(config_applier)
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
