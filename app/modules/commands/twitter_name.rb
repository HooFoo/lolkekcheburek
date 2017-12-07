module Commands
  class TwitterName < Commands::Base
    def self.run(opts)
      user = TwitterService.update_profile_name(opts[:text])
      "Ok, #{user.name}"
    end
  end
end
