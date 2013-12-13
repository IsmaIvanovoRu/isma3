class CommentsController < ArticlesController
  skip_before_filter :authenticate_user!, only: [:index]
  before_action :require_editor, only: [:index, :new, :edit, :create, :update, :destroy]
  before_action :set_aritcle, only: [:index, :show, :edit, :create, :update, :destroy]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  def index
    @comments = Comment.all
  end
  
  def show
  end
  
  def new
    @comment = Comment.new
  end
  
  def create
    @comment = @comments.new(comment_params)
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
    @comment.destroy
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
  
  private
  def set_comment
    @comment = Comment.find(params[:id])
  end
  
  def comment_params
    params.require(:article).permit(:id, :article_id, :user_id, :content)
  end
end
