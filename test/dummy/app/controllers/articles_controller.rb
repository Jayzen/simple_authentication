class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  def show
  end

  def new
    @article = Article.new
  end

  def edit
    render 'new'
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = params[:user_id]
    if @article.save
      redirect_to @article
      flash[:success] = "文章发布成功!"
    else
      render :new
    end
  end

  def update
    @article.user_id = params[:user_id]
    if @article.update(article_params)
      redirect_to @article
      flash[:success] = '文章更新成功!'
    else
      render :edit
    end
  end
  
  def index
    @articles = current_user.articles.order("created_at desc").page(params[:page])
  end

  def destroy
    @article.destroy
    redirect_to articles_url 
    flash[:success] = '文章删除成功!'
  end

  private
    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :content)
    end

    def correct_user
      @article = current_user.articles.find_by(id: params[:id])
      redirect_to root_url if @article.nil?
    end
end
