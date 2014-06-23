require 'rest-client'

module RemoteFactoryGirl
  class Http
    def self.post(config, params, http_lib = RestClient)
      new(config, params, http_lib).post
    end

    def self.get(config, params, http_lib = RestClient)
      new(config, params, http_lib).get
    end

    attr_reader :config, :params, :http_lib, :response_json

    def initialize(config, params, http_lib = RestClient)
      config.raise_if_host_not_set
      @config   = config
      @params   = params
      @http_lib = http_lib
    end

    def get
      @response_json = http_lib.get config.home_url, params.merge!(content_type: :json, accept: :json)
      self
    end

    def post
      @response_json = http_lib.post config.home_url, params, content_type: :json, accept: :json
      self
    end

    def to_hash
      JSON.parse(response_json)
    end
  end
end
