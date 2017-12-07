require 'open-uri'

module Commands
  class Tweet < Commands::Base

    def self.run(opts)
      message = opts[:message][:reply_to_message] ? opts[:message][:reply_to_message] : opts[:message]
      if !message[:photo].blank? || !message[:document].blank?
        tmp = TelegramService.get_file(message)
        tweet = TwitterService.update_with_media("", File.new(tmp))
        File.delete(tmp)
      else
        tweet = TwitterService.update("#{message.text.sub('/tweet ','')}")
      end
      tweet.url
    end

  end
end
