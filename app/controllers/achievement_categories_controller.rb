class AchievementCategoriesController < ApplicationController
before_action :require_administrator
before_action :set_achievement_category, only: [:show, :edit, :update,:destroy]

def index
  @achievement_categories = AchievementCategory.order(:name)
end

def show
end

def new
  @achievement_category = AchievementCategory.new
end

def edit
end

def create
  @achievement_category = AchievementCategory.new(achievement_category_params)
  if @achievement_category.save!
  	redirect_to @achievement_category, notice: "Achievement category created successfully"
  else
  	render action 'new'
  end
end

def update
	if @achievement_category.update(achievement_category_params)
	  redirect_to @achievement_category, notice: "Achievement category updated successfully"
	else
		render action 'edit'
  end
end

def destroy
  @achievement_category.destroy
  redirect_to achievement_categories_path
end

private

def set_achievement_category
  @achievement_category = AchievementCategory.find(params[:id])
end

def achievement_category_params
	params.require(:achievement_category).permit(:name, :description)
end
end
