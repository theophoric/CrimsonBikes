class MessagesController < ApplicationController
  layout 'admin'
  uses_tiny_mce :options => { 
                              :theme => "advanced",
                              :theme_advanced_buttons3 => "pasteword, fullscreen, fontsizeselect, separator, tablecontrols",
                              :plugins => %w{ fullscreen paste spellchecker table }
                            }
  
  def notification_new
    if params[:to]
      @to = User.find(params[:to])._id
    end
    @users = User.asc(:email)
    render "program/notifications/new"
  end
  
  def notification_send
    recipients = params[:recipients].to_a
    for recipient in recipients do
      user = User.find(recipient)
      if user
        notice_options = params[:notice_options].merge(:to => user.email)
        notice = Notifier.send_notice(notice_options, params[:body], user)
        notice.deliver
      end
    end
    flash[:notice] = "Message Sent"
    redirect_to :notification_new
  end
  
  
end