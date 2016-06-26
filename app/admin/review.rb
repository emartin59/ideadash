ActiveAdmin.register_page "Review" do


  content title: "Items to review" do
    render partial: 'review'
    render partial: 'review_comments'
  end
end
