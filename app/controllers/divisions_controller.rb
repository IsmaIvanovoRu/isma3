class DivisionsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index, :show]
  before_action :require_administrator, only: [:new, :create, :edit, :destroy]
  before_action :set_division, only: [:show, :edit, :update, :destroy]
  before_action :set_division_types, only: [:new, :edit]
  
  def index
    @divisions = Division.order(:name).includes(:division_type).all.group_by{|d| d.division_type.name}.sort
    respond_to do |format|
      format.html
      format.xls
    end
  end
  
  def show
    if current_user.nil?
      @articles_fixed = (@division.articles.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: nil, fixed: true, division_id: nil).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil) + Article.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: nil, division_id: @division, fixed: true).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil)).uniq
      @articles_not_fixed = (@division.articles.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: nil, fixed: false, division_id: nil).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil) + Article.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: nil, division_id: @division, fixed: false).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil)).uniq.first(5)
    else
      if current_user_moderator?
	current_user_groups = Group.all + [nil]
      else
	current_user_groups = current_user.groups + current_user.groups.joins(:parent).map{|g| g.parent} + [nil]
      end
      @articles_fixed = (@division.articles.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: current_user_groups, fixed: true, division_id: nil).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil) + Article.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: current_user_groups, division_id: @division, fixed: true).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil)).uniq
      @articles_not_fixed = (@division.articles.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: current_user_groups, fixed: false, division_id: nil).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil) + Article.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: current_user_groups, division_id: @division, fixed: false).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil)).uniq.first(5)
    end
    @posts = @division.posts.order(:name)
    @head = @posts.select{|e| e if e.is_head?}
    @employees = @posts - @head
    @childs = Post.where(parent_id: @head.first.id).where.not(division_id: @head.first.division_id) unless @head.empty?
    @attachment = Attachment.new
    @last_image_attachment = @division.attachments.last
    @menu_title = @division.name if current_user_administrator?
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
  
  def import
    Division.import(params[:file])
    redirect_to divisions_url, notice: "Divisions imported."
  end
  
  private
  def set_division
    @division = Division.find(params[:id])
  end

  def division_params
    params.require(:division).permit(:id, :name, :division_type_id, :address, :latitude, :longitude, :email, :about)
  end
  
  def set_division_types
    @division_types = DivisionType.all
  end
end
