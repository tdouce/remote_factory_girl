require 'rest-client'

module RemoteFactoryGirl
  class Http
    def self.post(config, params, http_lib = RestClient)
      new(config, params, http_lib).post
    end

    attr_reader :config, :params, :http_lib, :response

    def initialize(config, params, http_lib = RestClient)
      @config   = config
      @params   = params
      @http_lib = http_lib
    end

    def post
      config.raise_no_host_error
      @response ||= http_lib.post config.home_url, params, content_type: :json, accept: :json
      self
    end

    def json 
      @json ||= JSON.parse(response)
    end
  end
end
