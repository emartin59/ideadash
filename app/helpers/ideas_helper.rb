module IdeasHelper
  ORDER_MAPPING = {
      newest: 'Newest first',
      oldest: 'Oldest first'
  }
  FILTER_MAPPING = {
      all: 'All',
      current: 'Current'
  }

  def order_dropdown
    dropdown ORDER_MAPPING.fetch(params[:order].try(:to_sym)){ 'Newest first' } do
      link_to('Newest first', current_ideas_path(filter: params[:filter], order: :newest)) +
          link_to('Oldest first', current_ideas_path(filter: params[:filter], order: :oldest))
    end
  end

  def filter_dropdown
    dropdown FILTER_MAPPING.fetch(params[:filter].try(:to_sym)){ 'All' } do
      link_to('All', current_ideas_path(filter: nil, order: params[:order])) +
          link_to('Current', current_ideas_path(filter: :current, order: params[:order]))
    end
  end

  private
  def current_ideas_path(*args)
    @user ? user_ideas_path(@user, *args) : ideas_path(*args)
  end
end
