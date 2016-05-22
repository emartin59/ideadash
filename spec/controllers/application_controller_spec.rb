require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      raise CanCan::AccessDenied.new 'Not Authorized'
    end
  end

  it 'redirects to root path when cancan raises error' do
    get :index

    expect(response).to redirect_to root_path
  end
end
