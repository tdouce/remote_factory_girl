require 'remote_factory_girl/hash_to_dot'
require 'remote_factory_girl/json_to_active_resource'
require 'remote_factory_girl/factory_girl_json_parser'

module  RemoteFactoryGirl
  class ConfigApplier 

    attr_reader :json, :config

    def self.apply_config(json, config = {})
      new(json, config).apply_config
    end

    def initialize(json, config = {})
      @json   = json
      @config = default_config.merge(config)
    end

    def apply_config
      apply_config_options
    end

    private

    def default_config
      { :hash_to_dot_klass             => HashToDot, 
        :json_to_active_resource_klass => JsonToActiveResource,
        :response_parser               => FactoryGirlJsonParser }
    end

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

    def return_with_root(response_hash)
      config[:return_with_root] == false ? config[:response_parser].without_root(response_hash) : response_hash
    end
  end
end
