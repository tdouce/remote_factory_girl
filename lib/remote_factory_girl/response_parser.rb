require 'remote_factory_girl/hash_to_dot'
require 'ostruct'
require 'json'

module  RemoteFactoryGirl
  class ResponseParser 

    attr_reader :json, :config

    def self.parse(json, config = {})
      new(json, config).parse
    end

    def initialize(json, config = {})
      @json   = json
      @config = hash_to_dot_klass.merge(config)
    end

    def parse
      apply_config_options
    end

    private

    def hash_to_dot_klass
      {:hash_to_dot_klass => HashToDot}
    end

    def parse_json
      JSON.parse(json)
    end

    def apply_config_options
      configured_json = return_with_root(parse_json)   
      configured_json = return_response_as(configured_json)
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
