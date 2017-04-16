class AchievementsController < ApplicationController
  before_action :require_administrator, only: [:index, :published_toggle]
  before_action :set_achievement, only: [:edit, :update, :published_toggle, :destroy, :achievement_owner?]
  before_action :set_selects, only: [:edit]
  before_action :can, only: [:edit, :update, :destroy]

  def index
    @achievements = Achievement.order(:updated_at).includes(:achievement_category, :achievement_result).where(achievement_params)
  end
  
  def create
    @achievement = Achievement.new(achievement_params)
    @achievement.user_id = current_user.id
    if @achievement.save!
      if params[:attachment]
        attachment_params[:files].each do |file|
          @attachment = Attachment.new
          gravity = 'default'
          @attachment.uploaded_file(file, gravity)
          if @attachment.save
            @achievement.attachments << @attachment
          end
        end
      end
      redirect_to :back, notice: "Achievement added successfully"
    end
  end
  
  def edit
  end
  
  def update
    @achievement.update(achievement_params)
    if params[:attachment]
      attachment_params[:files].each do |file|
        @attachment = Attachment.new
        gravity = 'default'
        @attachment.uploaded_file(file, gravity)
        if @attachment.save
          @achievement.attachments << @attachment
        end
      end
    end
    redirect_to :back
  end
  
  def published_toggle
    @achievement.toggle!(:published)
    redirect_to :back
  end
  
  def destroy
    @achievement.destroy
    redirect_to :back
  end

  private

  def set_achievement
    @achievement = Achievement.find(params[:id])
  end
  
  def achievement_params
    params.require(:achievement).permit(:event_name, :event_date, :comment, :achievement_category_id, :achievement_result_id, :published)
  end
  
  def attachment_params
    params.require(:attachment).permit(files: [])
  end
  
  def set_selects
    @achievement_categories = AchievementCategory.order(:name).load
    @achievement_results = AchievementResult.order(:name).load
  end
  
  def can?
    current_user_administrator? || achievement_owner?
  end
  
  def can
    unless can?
      flash[:error] = "You must have permissions"
      redirect_to root_path
    else
      @can = true
    end
  end
  
  def achievement_owner?
    @achievement.user == current_user
  end
end
