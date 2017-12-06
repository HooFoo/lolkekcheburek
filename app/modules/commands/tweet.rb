require 'open-uri'

module Commands
  class Tweet < Commands::Base

    def self.run(opts)
      message = opts[:message][:reply_to_message] ? opts[:message][:reply_to_message] : opts[:message]
      if !message[:photo].blank? || !message[:document].blank?
        tmp = self.get_file(message)
        tweet = TwitterService.update_with_media("#{message.from.first_name} #{message.from.last_name}: ", File.new(tmp))
        File.delete(tmp)
      else
        tweet = TwitterService.update("#{message.from.first_name} #{message.from.last_name}: #{message.text.sub('/tweet ','')}")
      end
      tweet.url
    end

    private

    def self.get_file(message)
      if message.photo.empty?
        file_id = message.document.file_id
      else
        file_id = message.photo.last[:file_id]
      end
      file = TelegramService.call_api :get_file, file_id: file_id
      file_path = file.dig('result', 'file_path')
      photo_url = "https://api.telegram.org/file/bot#{ENV['TG_TOKEN']}/#{file_path}"
      tmp = "tmp/#{file_path.split('/')[1]}"
      open(tmp, 'wb') do |file|
        file << open(photo_url).read
      end
      tmp
    end
  end
end