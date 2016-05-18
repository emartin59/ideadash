module IdeasHelper
  def order_dropdown
    dropdown ORDER_MAPPING.fetch(params[:order].try(:to_sym)){ 'Newest first' } do
      link_to('Newest first', ideas_path(filter: params[:filter], order: :newest)) +
          link_to('Oldest first', ideas_path(filter: params[:filter], order: :oldest))
    end
  end

  ORDER_MAPPING = {
      newest: 'Newest first',
      oldest: 'Oldest first'
  }
end
