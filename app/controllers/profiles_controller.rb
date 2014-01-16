class ProfilesController < UsersController
  skip_before_filter :authenticate_user!, only: [:show]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :new, :create]
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :set_degrees, only: [:new, :edit]
  before_action :set_academic_titles, only: [:new, :edit]
  def index
    @profiles = Profile.all
  end
  
  def show
    @last_image_attachment = @profile.attachments.last
    @posts = @user.posts
    @groups = Group.order(:name).load - @user.groups
    @articles = {}
    if current_user.nil?
      ArticleType.all.each do |article_type|
	@articles = Article.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: nil).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil).paginate(:page => params[:page])
      end
    else
      current_user_groups = @user.groups + @user.groups.joins(:parent).map{|g| g.parent} + [nil]
	@articles = Article.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: current_user_groups).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil).paginate(:page => params[:page])
    end
  end
  
  def new
    @profile = Profile.new
  end
  
  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = params[:user_id]
    respond_to do |format|
      if @profile.save
        format.html { redirect_to user_profile_path(@user), notice: 'Profile was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end
  
  def update
    if @profile.update(profile_params)
      @profile.user.groups << Group.where(name: "entrants") if params[:entrant]
      if params[:attachment]
	@attachment = Attachment.new
	@attachment.uploaded_file = params[:attachment]
	@attachment.thumbnail = avatar(@attachment.data) if @attachment.mime_type =~ /image/
	if @attachment.save
	  @profile.attachments << @attachment
	end
      end
      redirect_to user_profile_path(@user), notice: 'Profile was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @profile.destroy
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
  
  private
  def set_user
    @user = User.find(params[:user_id])
  end
  
  def set_profile
    @profile = @user.profile
  end
  
  def profile_params
    params.require(:profile).permit(:id, :user_id, :first_name, :middle_name, :last_name, :degree_id, :academic_title_id, :phone, :about, :entrant)
  end
  
  def current_user_owner?
    current_user.id == @profile.user_id unless current_user.nil?
  end
  
  def set_degrees
    @degrees = Degree.all
  end
  
  def set_academic_titles
    @academic_titles = AcademicTitle.all
  end
 
  def avatar(image)
    img = Magick::Image.from_blob(image).first
    img.resize_to_fill!(150, 150, ::Magick::NorthGravity).to_blob
  end
end
