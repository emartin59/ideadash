module ApplicationHelper
  def flash_messages
    content_tag :div, class: 'alerts' do
      flash.map do |key, msg|
        alert_box(msg, dismissible: true, context: key)
      end.join.html_safe
    end.html_safe
  end

  def unbreakable_lines(*str)
    str.map{|s| s.split(' ').join('&nbsp;')}.join(' ').html_safe
  end

  def active_admin
    ObjectSpace.each_object(
        ActiveAdmin::Resource::Routes
    ).first.namespace.name
  end
end
