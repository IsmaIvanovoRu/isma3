#encoding: UTF-8
class DivisionsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index, :show]
  before_action :require_administrator, only: [:new, :create, :destroy]
  before_action :set_division, only: [:show, :edit, :update, :destroy]
  before_filter :is_student, only: [:show]
  before_action :set_division_types, only: [:new, :edit, :create]
  before_action :set_posts, only: [:show, :edit]
  before_action :set_division_posts, only: [:show, :edit]
  before_action :set_head, only: [:show, :edit]
  before_action :can, only: [:edit]
  
  def index
    @divisions = Division.order(:name).includes(:division_type).group_by{|d| t(d.division_type.name, scope: [:divisions])}.sort
    respond_to do |format|
      format.html
      format.xls
    end
  end
  
  def show
    @division_type = @division.division_type.name
    case @division_type
    when 'representative'
      if current_user.nil?
	@articles_fixed = Article.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: nil, division_id: @division, fixed: true).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil).uniq
	@articles_not_fixed = Article.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: nil, division_id: @division, fixed: false).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil).uniq.first(5)
      else
	if current_user_moderator?
	  current_user_groups = Group.all + [nil]
	else
	  current_user_groups = current_user.groups + current_user.groups.joins(:parent).map{|g| g.parent} + [nil]
	end
	@articles_fixed = Article.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: current_user_groups, division_id: @division, fixed: true).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil).uniq
	@articles_not_fixed = Article.includes(:attachments).includes(:article_type).order('updated_at DESC').where(published: true, group_id: current_user_groups, division_id: @division, fixed: false).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil).uniq.first(5)
      end
    else
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
    @childs = Post.where(parent_id: @head).where.not(division_id: @division).map{|p| p.division}.uniq.sort_by(&:name)  
    end
    @clerks = @division.posts.select{|p| p.name =~ /(секретарь|документовед|помощник)/} - @head
    @employees = @division_posts - @head - @clerks
    if can?
      @attachment = Attachment.new
      @attachments = Attachment.select(:id, :title).order(:title).load
    end
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
    @division = Division.includes(:division_type).includes(:posts).includes(:users).includes(:profiles).find(params[:id])
  end
  
  def set_division_posts
    @division_posts = @division.posts.sort_by{ |p| p.user.nil? ? p.name : p.user.profile.last_name }

  end

  def division_params
    params.require(:division).permit(:id, :name, :division_type_id, :address, :latitude, :longitude, :email, :about)
  end
  
  def set_division_types
    @division_types = DivisionType.all
  end
  
  def set_posts
    @posts = Post.order(:name).all
  end
  
  def set_head
    @head = @division.head
  end
  
  def can?
    current_user_administrator? || (current_user == @head.first.user if @head.first && current_user)
  end
  
  def can
    unless can?
      flash[:error] = "You must have permissions"
      redirect_to @division
    else
      @can = true
    end
  end
  def is_student?
    unless current_user.nil?
      groups_names = current_user_groups.map(&:name)
      (groups_names.include?('students') || groups_names.include?('employees') || current_user_administrator?)
    end
  end
  
  def is_student
    if @division.division_type_id == 6
      unless is_student?
	flash[:error] = "You must have permissions"
	redirect_to root_path
      end
    end
  end
end
