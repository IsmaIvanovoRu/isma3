class PostsController < DivisionsController
  before_action :require_administrator, only: [:index, :new, :create, :edit, :destroy]
  before_action :set_division, only: [:index, :show, :edit, :new, :create, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_post_types, only: [:new, :edit]
  before_action :set_divisions, only: [:new, :edit]
  before_action :set_posts, only: [:new, :edit]
  before_action :set_division_posts, only: [:index, :show, :edit]
  before_action :set_users, only: [:new, :edit]
  before_action :set_head, only: [:show, :edit]
  before_action :can, only: [:edit]
  
  
  def index
  end
  
  def show
    @profile = @post.user.profile if @post.user
    @last_image_attachment = @profile.attachments.last if @profile
    @menu_title = @post.name if current_user_administrator?
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
  
  def set_division_posts
    @division_posts = @division.posts.order(:name).all
  end
  
  def set_post_types
    @post_types = PostType.all
  end
  
  def set_posts
    @posts = @division.order(:name).all
  end
  
  def set_head
    @head = @division_posts.select{|e| e if e.is_head?}
  end
  
  def can?
    current_user_administrator? || (current_user == @head.first.user if @head.first)
  end
  
  def can
    unless can?
      flash[:error] = "You mast have permissions"
      redirect_to division_post_path(@division, @post)
    end
  end
  
  def set_users
    @users = User.joins(:groups).where(groups: {name: 'employees'}).sort_by{|user| user.profile.full_name}
  end

  def post_params
    params.require(:post).permit(:id, :user_id, :parent_id, :division_id, :post_type_id, :name, :phone)
  end
end
