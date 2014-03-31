require 'rest-client'

module RemoteFactoryGirl
  class Http
    def self.post(config, params, rest_client = RestClient)
      new.post(config, params, rest_client)
    end

    def post(config, params, rest_client)
      config.raise_no_host_error
      rest_client.post config.home_url, params, content_type: :json, accept: :json
    end
  end
end
