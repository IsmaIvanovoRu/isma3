class DivisionsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index, :show]
  #before_action :current_user_administrator?, only: [:new, :create, :edit, :destroy]
  before_action :set_division, only: [:show, :edit, :update, :destroy]
  before_action :set_division_types, only: [:new, :edit]
  
  def index
    @divisions = Division.order(:name).all
  end
  
  def show
    @articles = @division.articles
    @posts = @division.posts
    @head = @posts.select{|e| e if e.is_head?}
    @employees = @posts - @head
    @childs = Post.where(parent_id: @head.first.id).where.not(division_id: @head.first.division_id) unless @head.empty?
  end
  
  def new
    @division = Division.new
  end
  
  def create
    @division = Division.new(division_params)
    if @division.save
      redirect_to @division, notice: 'Division was successfully created.'
    else
      render action: 'new'
    end
  end
  
  def update
    if @division.update(division_params)
      redirect_to @division, notice: 'Division was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @division.destroy
    
    redirect_to divisions_url
  end
  
  private
  def set_division
    @division = Division.find(params[:id])
  end

  def division_params
    params.require(:division).permit(:id, :name, :division_type_id, :address, :latitude, :longitude)
  end
  
  def set_division_types
    @division_types = DivisionType.all
  end
end
