module ApplicationHelper
  def flash_message
    flash.each do |key, msg|
      alert_box msg, dismissible: true, context: key
    end
  end
end
