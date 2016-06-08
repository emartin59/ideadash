module IdeasHelper
  ORDER_MAPPING = {
      newest: 'Newest first',
      oldest: 'Oldest first',
      rating: 'Highest rated'
  }
  FILTER_MAPPING = {
      all: 'All',
      current: 'Current month'
  }

  def order_dropdown
    dropdown ORDER_MAPPING.fetch(params[:order].try(:to_sym)){ 'Highest rated' } do
      ORDER_MAPPING.inject('') do |tmp, itm|
        tmp + link_to(itm[1], current_ideas_path(filter: params[:filter], order: itm[0]))
      end.html_safe
    end
  end

  def filter_dropdown
    dropdown FILTER_MAPPING.fetch(params[:filter].try(:to_sym)){ 'Current month' } do
      link_to('All', current_ideas_path(filter: :all, order: params[:order])) +
          link_to('Current month', current_ideas_path(filter: nil, order: params[:order]))
    end
  end

  private
  def current_ideas_path(*args)
    @user ? user_ideas_path(@user, *args) : ideas_path(*args)
  end
end
