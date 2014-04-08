require 'remote_factory_girl/hash_to_dot'
require 'remote_factory_girl/json_to_active_resource'
require 'ostruct'
require 'json'

# TODO rename class to RepsonseConfigApplier
module  RemoteFactoryGirl
  class ResponseParser 

    attr_reader :json, :config

    def self.parse(json, config = {})
      new(json, config).parse
    end

    def initialize(json, config = {})
      @json   = json
      @config = default_config.merge(config)
    end

    def parse
      apply_config_options
    end

    def default_config
      { :hash_to_dot_klass             => HashToDot, 
        :json_to_active_resource_klass => JsonToActiveResource }
    end

    private

    def apply_config_options
      if config[:return_as_active_resource]
        configured_json = config[:json_to_active_resource_klass].convert(json)
      else
        configured_json = return_with_root(json)   
        configured_json = return_response_as(configured_json)
      end
      configured_json
    end

    def return_response_as(parsed_json) 
      config[:return_response_as] == :dot_notation ? config[:hash_to_dot_klass].convert(parsed_json) : parsed_json
    end

    def return_with_root(parsed_json)
      config[:return_with_root] == false ? Array(parsed_json).flatten.last : parsed_json
    end
  end
end
