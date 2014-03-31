require "remote_factory_girl/version"
require 'remote_factory_girl/config'
require 'remote_factory_girl/http'
require 'remote_factory_girl/response_parser'
require 'remote_factory_girl/config_struct'
require 'remote_factory_girl/hash_to_dot'

module RemoteFactoryGirl
  class RemoteFactoryGirl
    attr_reader :name, :attributes

    def initialize(name, attributes)
      @name       = name
      @attributes = attributes
    end

    def params 
      { factory: name, attributes: attributes }
    end
  end

  def self.configure(opts = { :config_struct => ConfigStruct, :config => Config }, &block)
    config      = opts.fetch(:config_struct).block_to_hash(block)
    self.config = opts.fetch(:config).configure(config)
  end

  def self.create(factory, attributes = {}, parser = ResponseParser, http = Http)
    factory  = RemoteFactoryGirl.new(factory, attributes)
    response = http.post(config.home_url, factory.params)
    parser.parse(response, config.to_hash)
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
