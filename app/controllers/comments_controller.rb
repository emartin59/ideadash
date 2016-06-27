class CommentsController < ApplicationController
  def create
    @comment = Comment.build_from(parent, current_user.id, body)

    if @comment.save
      make_child_comment if comment_id.present?
      redirect_to :back, success: 'Comment was successfully added.'
    else
      redirect_to :back, success: 'There was an error, please try again.'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type, :comment_id)
  end

  def comment_id
    comment_params[:comment_id]
  end

  def body
    comment_params[:body]
  end

  def make_child_comment
    parent_comment = Comment.find(comment_id)
    @comment.move_to_child_of(parent_comment)
  end

  def parent
    return @parent ||= Idea.find(params[:idea_id]) if params[:idea_id]
  end
end
