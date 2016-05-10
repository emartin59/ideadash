module ApplicationHelper
  def flash_messages
    out = ''
    flash.each do |key, msg|
      out << alert_box(msg, dismissible: true, context: key)
    end if flash.any?
    return out.html_safe
  end

  def unbreakable_lines(*str)
    str.map{|s| s.split(' ').join('&nbsp;')}.join(' ').html_safe
  end
end
