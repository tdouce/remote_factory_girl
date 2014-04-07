require "remote_factory_girl/version"
require 'remote_factory_girl/config'
require 'remote_factory_girl/http'
require 'remote_factory_girl/response_parser'
require 'remote_factory_girl/config_struct'
require 'remote_factory_girl/hash_to_dot'
require 'remote_factory_girl/json_to_active_resource'

module RemoteFactoryGirl

  class JsonToActiveResourceDecorator

    attr_reader :json_to_active_resource

    def initialize(json_to_active_resource)
      @json_to_active_resource = json_to_active_resource
    end

    def resource(resource = nil)
      json
    end
  end

  class RemoteFactoryGirl

    attr_reader :name, :attributes, :config

    def initialize(name, attributes, config)
      @name       = name
      @attributes = attributes
      @config     = config 
    end

    def parse(parser = ResponseParser)
      parser.parse(post.json, config.to_hash)
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

  def self.create(factory, attributes = {}, parser = ResponseParser, http = Http, json_to_active_resource = JsonToActiveResource)
    factory  = RemoteFactoryGirl.new(factory, attributes, config)
    factory.post(http)

    if config.return_as_active_resource
      json_to_active_resource.new(factory.post.json)
    else
      factory.parse(parser)
    end
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
