require 'remote_factory_girl/exceptions'

module RemoteFactoryGirl
  class Config

    attr_accessor :home, :return_response_as, :return_with_root, :return_as_active_resource, :https

    def initialize
      @return_response_as        = :as_hash
      @return_with_root          = true
      @return_as_active_resource = false
      @home                      = default_home_config
      @https                     = false
    end

    def home=(home_config)
      @home = home.merge(home_config)
    end

    def home_url
      raise_if_host_not_set
      if home[:port]
        "#{ hyper_text_transfer_protocal }://#{ home.fetch(:host) }:#{ home.fetch(:port) }#{ home.fetch(:end_point) }"
      else
        "#{ hyper_text_transfer_protocal }://#{ home.fetch(:host) }#{ home.fetch(:end_point) }"
      end
    end

    def to_hash
      { home:                      home,
        home_url:                  home_url,
        return_response_as:        return_response_as,
        return_with_root:          return_with_root,
        return_as_active_resource: return_as_active_resource }
    end

    def raise_if_host_not_set
      raise RemoteFactoryGirlConfigError.new('RemoteFactoryGirl.config.home[:host] and RemoteFactoryGirl.config.home[:end_point] can not be nil') unless has_home?
    end

    def has_home?
      !home[:host].nil? && !(home[:host] == '') && !home[:end_point].nil? && !(home[:end_point] == '')
    end

    private

    def hyper_text_transfer_protocal
      https == true ? 'https' : 'http'
    end

    def default_home_config
      { host:      nil,
        port:      nil,
        end_point: '/remote_factory_girl/home' }
    end
  end
end
