require 'cb_checkout'

class CheckoutsController < ApplicationController
  before_filter :verify_merchant_credentials, :only => [:process_response]
  before_filter :authenticate_user!, :only => [:process_checkout]
  def process_checkout
    membership_type = (params[:membership_type] || "BASIC").upcase

    checkout_response = CbCheckout.transact(membership_type, current_user._id)
    redirect_to checkout_response[:redirect_url]
  end
  
  def process_response
    handler = frontend.create_notification_handler
    begin
       notification = handler.handle(request.raw_post) # raw_post contains the XML
       puts [notification.google_order_number, notification.shopping_cart].join("\t")
       puts notification.shopping_cart.private_data["user_id"]
    rescue Google4R::Checkout::UnknownNotificationType
       # This can happen if Google adds new commands and Google4R has not been
       # upgraded yet. It is not fatal.
       logger.warn "Unknown notification type"
       return render :text => 'ignoring unknown notification type', :status => 200
    end
    
    shopping_cart = notification.shopping_cart
    items = shopping_cart.items
    puts items
    user = User.find(shopping_cart.private_data["user_id"])
    case notification
    when Google4R::Checkout::NewOrderNotification then
      puts "new order"
      user.update_attribute(:processed, true)
      user.memberships.create(:level => "basic", :_payment_status => "processed")
    when Google4R::Checkout::OrderStateChangeNotification then
      puts "order state changed"
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
      (CbCheckout::Config.merchant_id.to_s == merchant_id) and (CbCheckout::Config.merchant_key.to_s == merchant_key)
    end
  end
  
  def frontend
    CbCheckout.init_frontend
  end
end
