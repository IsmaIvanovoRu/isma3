class PostsController < DivisionsController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_division, only: [:index, :show, :edit, :create, :update, :destroy]
  before_action :current_user_administrator?, only: [:new, :create, :edit, :destroy]
  
  def index
  	@posts = Post.order(:name).all
  end
  
  def show
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render action: 'new'
    end
  end
  
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @post.destroy
    
    redirect_to posts_url
  end
  
  private
  def set_article
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:id, :parent_id, :division_id, :post_type_id, :name)
  end
end
