class SitemapsController < ApplicationController
  layout nil
  caches_action :index, expires_in: 12.hours

  def index
    headers['Content-Type'] = 'application/xml'
    respond_to do |format|
      format.xml
    end
  end
end
