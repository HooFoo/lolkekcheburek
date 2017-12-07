require 'telegram/bot'

class TelegramService

  def self.init(token)
    Telegram::Bot::Client.run(token, logger: Logger.new($stdout)) do |bot|
      @@bot = bot
    end
  end

  def self.update(params)
    begin
      update = Telegram::Bot::Types::Update.new(params.permit!)

      message = update.message

      process message

    rescue Exception => e
      Rails.logger.error e
      Rails.logger.error e.backtrace
    end
  end

  def self.set_webhook(url)
    @@bot.api.set_webhook(url: url)
  end

  def self.call_api(name, params={})
    @@bot.api.send name, params
  end

  def self.get_file(message)
    if message.photo.empty?
      file_id = message.document.file_id
    else
      file_id = message.photo.last[:file_id]
    end
    file = call_api :get_file, file_id: file_id
    file_path = file.dig('result', 'file_path')
    photo_url = "https://api.telegram.org/file/bot#{ENV['TG_TOKEN']}/#{file_path}"
    tmp = "tmp/#{file_path.split('/')[1]}"
    open(tmp, 'wb') do |file|
      file << open(photo_url).read
    end
    tmp
  end

  private

  def self.process(message)
    text = message.text
    if !text.blank? && text[0] == '/'
      regex = /\/(\w+)(@\w+)?(\s(.+))?/i
      groups = regex.match text
      begin
        plugin = "Commands::#{groups[1].camelize}".constantize
        reply = plugin.send :run, {text: groups.to_a.last, message: message}
        @@bot.api.send_message chat_id: message.chat.id, text: reply.to_s
      rescue Exception => e
        Rails.logger.debug e.message
      end
      p groups
    end
  end
end
