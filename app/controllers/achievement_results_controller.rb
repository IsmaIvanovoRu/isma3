class AchievementResultsController < ApplicationController
before_action :require_administrator
before_action :set_achievement_result, only: [:show, :edit, :update,:destroy]

def index
  @achievement_results = AchievementResult.order(:name)
end

def show
end

def new
  @achievement_result = AchievementResult.new
end

def edit
end

def create
  @achievement_result = AchievementResult.new(achievement_result_params)
  if @achievement_result.save!
  	redirect_to @achievement_result, notice: "Achievement result created successfully"
  else
  	render action 'new'
  end
end

def update
	if @achievement_result.update(achievement_result_params)
	  redirect_to @achievement_result, notice: "Achievement result updated successfully"
	else
		render action 'edit'
  end
end

def destroy
  @achievement_result.destroy
  redirect_to achievement_results_path
end

private

def set_achievement_result
  @achievement_result = AchievementResult.find(params[:id])
end

def achievement_result_params
	params.require(:achievement_result).permit(:name, :description)
end
end