class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :fetch_categories, only: [:new, :edit]

  def show
    @comment = Comment.new
    @comments = @article.comments.includes(:user).order("created_at desc")
    @article.increment!(:view_count)
    if request.path != article_path(@article) #当访问旧值时，链接地址会自动跳到更新后的新值中
      redirect_to @article, :status => :moved_permanently
    end
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
    @article.slug = nil
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
  
  def remove_select
    unless params[:article_ids].nil?
      @articles = Article.find(params[:article_ids])
      @articles.each do |article|
        article.destroy
      end
      redirect_to articles_url
      flash[:success] = '选中的文章被全部删除!'
    else
      redirect_to articles_url
      flash[:danger] = "文章未被选择!"
    end
  end

  private
    def set_article
      @article = Article.includes(:user).friendly.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :content, :category_id)
      #params.require(:article).permit(:title, :content, {article_ids: []})
    end

    def correct_user
      @article = current_user.articles.friendly.find(params[:id])
      redirect_to root_url if @article.nil?
    end

    def fetch_categories
      @root_categories = Category.roots.order(id: "desc")
    end
end
