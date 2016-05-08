module ApplicationHelper
  def flash_messages
    out = ''
    flash.each do |key, msg|
      out << alert_box(msg, dismissible: true, context: key)
    end if flash.any?
    return out.html_safe
  end
end
