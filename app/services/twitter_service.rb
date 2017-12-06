class TwitterService

  def self.init(cfg={})
    @@client = Twitter::REST::Client.new do |config|
      config.consumer_key        = cfg[:consumer_key]
      config.consumer_secret     = cfg[:consumer_secret]
      config.access_token        = cfg[:access_token]
      config.access_token_secret = cfg[:access_secret]
    end
  end

  def self.update(text)
    @@client.update(text)
  end

  def self.update_with_media(text, file)
    @@client.update_with_media(text, file)
  end

end