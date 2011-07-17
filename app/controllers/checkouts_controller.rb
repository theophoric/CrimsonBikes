require 'cb_checkout'

class CheckoutsController < ApplicationController
  # before_filter :configuration, :load_frontend
  before_filter :verify_merchant_credentials, :only => [:process_response]
  def process_checkout
    membership_type = (params[:membership_type] || "BASIC").upcase
    redirect_to CbCheckout.transact(membership_type, current_user._id)
  end
  
  def process_response
    handler = frontend.create_notification_handler
    begin
       notification = handler.handle(request.raw_post) # raw_post contains the XML
    rescue Google4R::Checkout::UnknownNotificationType
       # This can happen if Google adds new commands and Google4R has not been
       # upgraded yet. It is not fatal.
       logger.warn "Unknown notification type"
       return render :text => 'ignoring unknown notification type', :status => 200
    end

    case notification
    when Google4R::Checkout::NewOrderNotification then

      # handle a NewOrderNotification

    when Google4R::Checkout::OrderStateChangeNotification then

      # handle an OrderStateChangeNotification

    else
      return head :text => "I don't know how to handle a #{notification.class}", :status => 500
    end

    notification_acknowledgement = Google4R::Checkout::NotificationAcknowledgement.new(notification)
    render :xml => notification_acknowledgement, :status => 200
  end

  private
  # make sure the request authentication headers use the right merchant_id and merchant_key
  def verify_merchant_credentials
    authenticate_or_request_with_http_basic("Google Checkout notification endpoint") do |merchant_id, merchant_key|
      (conf['merchant_id'].to_s == @configuration[:merchant_id]) and (conf['merchant_key'].to_s == @configuration[:merchant_key])
    end
  end
  def configuration
    @configuration = {
      :merchant_id     => "618974739863729",
      :merchant_key    => "4zkYk_TKGOxSsalUuKTZAw",
      :use_sandbox         => true
    }
  end
  
  def load_frontend
    @frontend ||= Google4R::Checkout::Frontend.new(@configuration)
  end
    
end
