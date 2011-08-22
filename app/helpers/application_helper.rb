module ApplicationHelper
  def unlock_code reservation
    if reservation.class == Reservation
      if (reservation.date + (reservation.start / 2).hours) > (Time.now + 2.hours)
        link_to "View Code", "#", :class => "disabled", :onclick => "$('#dialog').attr('title','Notice').html('The unlock code is only visible within 2 hours of the start of your reservation.'); $('#dialog').dialog({modal:true});"
      elsif (reservation.date + (reservation.stop / 2).hours) < (Time.now - 2.hours)
        "Combination Expired"
      else
        link_to "View Code", "#unlock_code_link", :onclick => "$('#unlock_code').html('#{escape_javascript(render :partial => "program/shared/unlock_code")}');$('#unlock_code_link').click();", :class => "link"
      end
    end
  end
  
  def sortable(field, title = nil)
    title ||= field.to_s.titleize
    direction = (field == sort_field && sort_direction == "asc") ? "desc" : "asc"
    css_class = (field == sort_field) ? "#{direction} current sortable" : nil
    link_to title, object_manage_path(params[:_class], {:sort_field => field, :sort_direction => direction}), {:class => css_class}
  end
  
end