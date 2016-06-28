module IdeasHelper
  ORDER_MAPPING = {
      rating: 'Highest rated',
      backers: 'Most backers',
      balance: 'Total funds raised',
      newest: 'Newest first',
      oldest: 'Oldest first'
  }
  FILTER_MAPPING = {
      current: 'Current month',
      previous: 'Previous month',
      all: 'All'
  }

  def order_dropdown
    dropdown ORDER_MAPPING.fetch(params[:order].try(:to_sym)){ 'Highest rated' } do
      ORDER_MAPPING.map do |k, v|
        link_to(v, current_ideas_path(filter: params[:filter], order: k))
      end.join('').html_safe
    end
  end

  def filter_dropdown
    dropdown FILTER_MAPPING.fetch(params[:filter].try(:to_sym)){ 'Current month' } do
      FILTER_MAPPING.map do |k, v|
        link_to(v, current_ideas_path(filter: k, order: params[:order]))
      end.join('').html_safe
    end
  end

  private
  def current_ideas_path(*args)
    @user ? user_ideas_path(@user, *args) : ideas_path(*args)
  end
end
