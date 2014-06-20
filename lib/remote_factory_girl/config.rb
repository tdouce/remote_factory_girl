require 'remote_factory_girl/exceptions'

module RemoteFactoryGirl
  class Config

    attr_accessor :home, :return_response_as, :return_with_root, :return_as_active_resource

    def initialize
      @return_response_as        = :as_hash
      @return_as_active_resource = false
      @home                      = default_home_config
    end

    def home=(home_config)
      @home = home.merge(home_config)
    end

    def home_url
      raise_no_host_error
      http = 'http://'
      if home[:port]
        "#{ http }#{ home.fetch(:host) }:#{ home.fetch(:port) }#{ home.fetch(:end_point) }"
      else
        "#{ http }#{ home.fetch(:host) }#{ home.fetch(:end_point) }"
      end
    end

    def to_hash
      raise_no_host_error
      { home:                      home,
        return_response_as:        return_response_as,
        return_with_root:          return_with_root,
        return_as_active_resource: return_as_active_resource }
    end

    def raise_no_host_error
      raise RemoteFactoryGirlConfigError.new("RemoteFactoryGirl.config.home[:host] can not be nil") unless has_home?
    end

    def has_home?
      !home[:host].nil? && !(home[:host] == '') && !home[:end_point].nil? && !(home[:end_point] == '')
    end

    private

    def default_home_config
      { :host      => nil,
        :port      => nil,
        :end_point => '/remote_factory_girl/home' }
    end
  end
end
