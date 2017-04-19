class ProfilesController < UsersController
  skip_before_filter :authenticate_user!, only: [:show]
  skip_before_filter :require_administrator, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :new, :create, :published_toggle]
  before_action :set_profile, only: [:show, :edit, :update, :destroy, :published_toggle]
  before_action :can, only: [:edit, :update, :destroy]
  before_action :set_degrees, only: [:new, :edit]
  before_action :set_academic_titles, only: [:new, :edit]
  before_action :entrant?, only: [:edit]
  def index
    @profiles = Profile.all
  end
  
  def show
    if @profile.full_name.empty? && current_user_owner?
      redirect_to edit_user_profile_path(@user)
    else
      @last_image_attachment = @profile.attachments.last
      @posts = @user.posts.sort_by{|p| p.division.name}
      g = Group.where.not(parent_id: nil).map(&:parent_id)
      @user_groups = @user.groups
      @not_user_groups = Group.order(:name).where.not(id: g) - @user_groups
      @achievements = current_user_moderator? || current_user_owner? ? @user.achievements.order(:event_date).includes(:achievement_category, :achievement_result) : @user.achievements.order(:event_date).includes(:achievement_category, :achievement_result).where(published: true)
      if current_user.nil?
       @articles = Article.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: nil, user_id: @user).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil).paginate(:page => params[:page])
      else
        if current_user_moderator?
          current_user_groups = Group.all + [nil]
        else
          current_user_groups = current_user.groups + current_user.groups.joins(:parent).map{|g| g.parent} + [nil]
        end
        @articles = (@user == current_user || current_user_moderator? ?  Article.includes(:attachments).includes(:article_type).order('updated_at DESC').where(group_id: current_user_groups, user_id: @user).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil).paginate(:page => params[:page]) : Article.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: current_user_groups, user_id: @user).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil).paginate(:page => params[:page]))
        @attachment = Attachment.new
      end
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
      if params[:entrant]
  @profile.user.groups << Group.where(name: "entrants") if @profile.user.groups.where(groups: {name: 'entrants'}).empty?
      else
  @profile.user.groups.delete(Group.where(name: "entrants"))
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
  
  def published_toggle
    @profile.toggle!(:published)
    redirect_to :back
  end
  
  private
  def set_user
    @user = User.includes(:divisions).includes(:posts).includes(:profile).find(params[:user_id])
  end
  
  def set_profile
    @profile = @user.profile
  end
  
  def profile_params
    params[:profile][:published] = false unless current_user_moderator?
    params.require(:profile).permit(:id, :user_id, :first_name, :middle_name, :last_name, :degree_id, :academic_title_id, :phone, :about, :entrant, :email, :discipline, :qualification, :development, :general_experience, :special_experience, :published)
  end
  
  def current_user_owner?
    current_user == @user unless current_user.nil?
  end
  
  def set_degrees
    @degrees = Degree.all
  end
  
  def set_academic_titles
    @academic_titles = AcademicTitle.all
  end
  
  def can?
    current_user_administrator? || current_user_owner?
  end
  
  def can
    unless can?
      flash[:error] = "You must have permissions"
      redirect_to user_profile_path(@user)
    end
  end
  
  def entrant?
    @entrant = !@profile.user.groups.where(groups: {name: 'entrants'}).empty?
  end
end
