class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.most_used(10)
    @tags = @tags.where("name LIKE '#{ params[:q] }%'") if params[:q].present?
    render json: { tags: @tags.pluck(:name) }
  end
end
