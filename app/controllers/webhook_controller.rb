class WebhookController < ApplicationController

  skip_before_action :verify_authenticity_token

  def twitter
  end

  def telegram
    TelegramService.update(params)
    render nothing: true, status: 200
  end
end
