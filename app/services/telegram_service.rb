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
    end
  end

  def self.set_webhook(url)
    @@bot.api.set_webhook(url: url)
  end

  def self.call_api(name, params={})
    @@bot.api.send name, params
  end

  private

  def self.process(message)
    text = message.text
    if text[0] == '/'
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
