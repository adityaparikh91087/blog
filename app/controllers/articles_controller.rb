class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

=begin
With the validation now in place, when you call @article.save on an invalid article, it will return false.
If you open app/controllers/articles_controller.rb again, you'll notice that we don't
check the result of calling @article.save inside the create action.
If @article.save fails in this situation, we need to show the form back to the user.
To do this, change the new (instead of blank method)
and create actions inside app/controllers/articles_controller.rb.
Notice that inside the create action we use render instead of redirect_to when save returns false.
The render method is used so that the @article object is passed back to the new template when it is rendered.
This rendering is done within the same request as the form submission, whereas the redirect_to will tell the
browser to issue another request.

=end

  def new
    @article = Article.new
  end

  def create
  #  render plain: params[:article].inspect
  #  @article = Article.new(params[:article])
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render 'new'
    end
  end

  def show
  end

  # GET /articles
  def index
    # @articles = Article.all
    # add pagination (50 is default. can omit :per_page argument)
    @articles = Article.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 30) # arrange pins in reverse chronological order
  end

  def edit
  end

  # PATCH/PUT /articles/1 Similarly update is first edit then update
  #  As before, if there was an error updating the article we want to show the form back to the user.
  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end

  # Since there is no view associated with destroy, redirect back to index action
  def destroy
    @article.destroy
    redirect_to articles_path, notice: 'Article was successfully destroyed.'
  end

  private
    def article_params
      params.require(:article).permit(:title, :text)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_article
      #  @article = Article.find(params[:id]) # this version raises an error if article not found
      @article = Article.find_by(id: params[:id]) # this version doesn't
    end

end
