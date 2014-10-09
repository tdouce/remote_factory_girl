require 'remote_factory_girl/config'

module RemoteFactoryGirl
  class RemotesConfig

    attr_writer :current_remote

    def initialize
      @remotes = {}
    end

    def current_remote
      @current_remote || default_remote_name
    end

    def to_hash
      remotes
    end

    def add_remote(config, remote_name)
      @remotes[remote_name] = config
    end

    def config_for(remote_name)
      remotes.fetch(remote_name)
    end

    def default_remote_name
      :default
    end

    def reset(config = Config.new)
      self.current_remote = default_remote_name
      self.remotes        = {}
      add_remote(config, default_remote_name)
    end

    private

    def remotes=(obj)
      @remotes = obj
    end

    def remotes
      @remotes
    end
  end
end
