class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @article = Article.find(params[:id])
    @comment = @article.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = "评论成功"
      redirect_to article_path(@article)
    else
      redirect_to article_path(@article)
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end
end
