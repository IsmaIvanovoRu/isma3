class PostsController < DivisionsController
  before_action :set_division, only: [:index, :show, :edit, :new, :create, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_post_types, only: [:new, :edit]
  before_action :set_divisions, only: [:new, :edit]
  before_action :set_posts, only: [:index, :new, :edit]
  before_action :set_users, only: [:new, :edit]
  
  before_action :current_user_administrator?, only: [:new, :create, :edit, :destroy]
  
  def index
    @posts = @division.posts.order(:name).all
  end
  
  def show
    @profile = @post.user.profile
    @last_image_attachment = @profile.attachments.last
  end
  
  def new
    @post = @division.posts.new
  end
  
  def create
    @post = @division.posts.new(post_params)
    
    if @post.save
      redirect_to division_post_path(@division, @post), notice: 'Post was successfully created.'
    else
      render action: 'new'
    end
  end
  
  def update
    if @post.update(post_params)
      redirect_to division_post_path(@division, @post), notice: 'Post was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @post.destroy
    
    redirect_to posts_url
  end
  
  private
  def set_post
    @post = @division.posts.find(params[:id])
  end
  
  def set_division
    @division = Division.find(params[:division_id])
  end
  
  def set_divisions
    @divisions = Division.all
  end
  
  def set_post_types
    @post_types = PostType.all
  end
  
  def set_posts
    @posts = Post.order(:name).all
  end
  
  def set_users
    @users = User.all.sort_by{|user| user.profile.full_name}
  end

  def post_params
    params.require(:post).permit(:id, :user_id, :parent_id, :division_id, :post_type_id, :name, :phone)
  end
end
