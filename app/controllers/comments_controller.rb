class CommentsController < ArticlesController
  before_filter :require_moderator, only: [:published_toggle]
  before_filter :require_commentator, only: [:new, :create, :destroy]
  before_action :set_article
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :published_toggle]
  before_action :set_comments, only: [:create, :destroy, :published_toggle]
  def index
    @comments = @article.comments.all
  end
  
  def show
  end
  
  def new
    @comment = @article.comments.new
  end
  
  def create
    @comment = @article.comments.new(comment_params)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        format.html { redirect_to :back, notice: 'Comment was successfully created.' }
	format.js
      else
        format.html { render action: "new" }
      end
    end
  end
  
  def update
    if @comment.update(comment_params)
      redirect_to @comment, notice: 'Comment was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @comment.destroy if current_user_moderator?
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
  
  def published_toggle
    @comment.toggle!(:published)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
  
  private
  def set_article
    @article = Article.find(params[:article_id])
  end  
  def set_comment
    @comment = @article.comments.find(params[:id])
  end
  
  def comment_params
    params.require(:comment).permit(:article_id, :user_id, :content)
  end
  
  def set_comments
    @comments = current_user_moderator? ? @article.comments.where.not(id: nil) : @article.comments.where.not(id: nil).where(published: true)
  end
end
