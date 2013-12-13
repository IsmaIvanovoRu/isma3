class ProfilesController < UsersController
  skip_before_filter :authenticate_user!, only: [:show]
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  def index
    @profiles = Profile.all
  end
  
  def show
  end
  
  def new
    @profile = Profile.new
  end
  
  def create
    @profile = @profiles.new(profile_params)
    respond_to do |format|
      if @profile.save
        format.html { redirect_to :back, notice: 'Profile was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end
  
  def update
    if @profile.update(profile_params)
      redirect_to @profile, notice: 'Profile was successfully updated.'
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
  def set_profile
    @profile = Profile.find(params[:id])
  end
  
  def set_user
    @user = @profile.user
  end
  
  def profile_params
    params.require(:article).permit(:id, :user_id, :first_name, :middle_name, :last_name, :degree_id, :academic_title_id, :email, :phone, :avatar)
  end
  
  def current_user_owner?
    current_user.id == @profile.user_id unless current_user.nil?
  end
end
