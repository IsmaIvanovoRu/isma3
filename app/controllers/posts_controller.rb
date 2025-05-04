class PostsController < DivisionsController
  before_action :require_administrator, only: [:index, :new, :create, :edit, :destroy]
  skip_before_filter :is_student, only: [:show]
  before_action :set_division, only: [:index, :show, :edit, :new, :create, :update, :destroy, :add_subject, :remove_subject]
  before_filter :is_student, only: [:show]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :add_subject, :remove_subject]
  before_action :set_post_types, only: [:new, :edit, :create]
  before_action :set_posts, only: [:new, :edit, :create]
  before_action :set_division_posts, only: [:index, :show, :edit, :create]
  before_action :set_users, only: [:new, :edit, :create]
  before_action :set_head, only: [:show, :edit]
  before_action :can, only: [:edit]
    
  def index
  end
  
  def show
    @profile = @post.user.profile if @post.user
    @last_image_attachment = @profile.attachments.last if @profile
    if current_user_administrator?
      @menu_title = @post.name
      if @post.division.division_type_id == 3
        @division_subjects = @post.division.subjects.includes(:educational_program).where(educational_programs: {adaptive: false}) - @post.subjects
        @subjects = Subject.includes(:educational_program).order(:name).where(educational_programs: {adaptive: false}) - @division_subjects - @post.subjects
      end
    end
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
    redirect_to division_path(@division)
  end
  
  def add_subject
    @post.subjects << Subject.find(params[:subject_id])
    redirect_to :back
  end
  
  def remove_subject
    @post.subjects.delete(Subject.find(params[:subject_id]))
    redirect_to :back
  end
  
  private
  def set_post
    @post = @division.posts.includes(:subjects).find(params[:id])
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
    @division.division_type.name == 'student' ? @posts = Post.order(:name).joins(:division).where(divisions: {division_type_id: [2, 6]}) : @posts = Post.order(:name).joins(:division).where.not(divisions: {division_type_id: 6})
  end
  
  def set_head
    @head = @division_posts.select{|e| e if e.is_head?}
  end
  
  def can?
    current_user_administrator? || (current_user == @head.first.user if @head.first)
  end
  
  def can
    unless can?
      flash[:error] = "You must have permissions"
      redirect_to division_post_path(@division, @post)
    end
  end
  
  def set_users
    @division.division_type.name == 'student' ? @users = User.joins(:groups).includes(:profile).where(groups: {name: 'students'}).sort_by{|user| user.profile.full_name} : @users = User.joins(:groups).includes(:profile).where(groups: {name: 'employees'}).sort_by{|user| user.profile.full_name}
  end

  def post_params
    params.require(:post).permit(:id, :user_id, :parent_id, :division_id, :post_type_id, :name, :phone, :feedback)
  end
end
