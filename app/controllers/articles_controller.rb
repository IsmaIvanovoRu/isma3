class ArticlesController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index, :show]
  before_action :require_writer, only: [:new, :edit, :update, :create, :destroy, :published_toggle, :up, :cleanup_message]
  before_action :set_article, only: [:show, :edit, :update, :destroy, :published_toggle, :up, :cleanup_message]
  before_action :can, only: [:edit, :update, :destroy]
  before_action :set_article_types, only: [:new, :edit, :create, :update]
  before_action :set_divisions, only: [:new, :edit, :create, :update]
  before_action :set_groups, only: [:new, :edit, :create, :update]
  before_action :set_employees, only: [:new, :edit, :create, :update]

  # GET /articles
  # GET /articles.json
  def index
      @articles = {}
    if current_user.nil?
      ArticleType.all.each do |article_type|
	@articles[article_type.name] = Article.includes(:division).includes(:user).order('articles.updated_at DESC').where(published: true, group_id: nil, article_type_id: article_type).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil).limit(6)
      end
    else
      if current_user_moderator?
	current_user_groups = Group.all + [nil]
      else
	current_user_groups = current_user.groups + current_user.groups.joins(:parent).map{|g| g.parent} + [nil]
      end
      ArticleType.all.each do |article_type|
	@articles[article_type.name] = Article.includes(:division).includes(:user).order('articles.updated_at DESC').where(published: true, group_id: current_user_groups, article_type_id: article_type).where("exp_date >= ? or exp_date IS ?", Time.now.to_date, nil).limit(6)
      end
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    if can?
      @attachment = Attachment.new
      @attachments = Attachment.select(:id, :title).order(:title).load
    end
    @first_image_attachment = @article.attachments.select {|a| a.mime_type =~ /image/}.first
    @image_attachments = (@article.attachments.select {|a| a.mime_type =~ /image/}.count > 1 ? @article.attachments.select {|a| a.mime_type =~ /image/} : [])
    @not_image_attachments = @article.attachments.select {|a| a.mime_type !~ /image/}
    @menu_title = @article.title if current_user_administrator?
    @comment = @article.comments.new
    @comments = current_user_moderator? ? @article.comments.includes(:user).where.not(id: nil) : @article.comments.includes(:user).where.not(id: nil).where(published: true)
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit 
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    respond_to do |format|
      if @article.save
	Events.new_article(@article).deliver
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render action: 'show', status: :created, location: @article }
      else
        format.html { render action: 'new' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
   
  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end
  
  def published_toggle
    @article.toggle!(:published)
    redirect_to :back
  end
  
  def up
    @article.update_attributes(updated_at: Time.now)
    redirect_to :back
  end
  
  def cleanup_message
    tmp_datetime = @article.updated_at
    @article.message = ""
    @article.updated_at = tmp_datetime
    @article.save!
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.includes(:attachments).includes(:comments).includes(:division).includes(:user).find(params[:id])
    end
    
    def set_article_types
      @article_types = ArticleType.order(:name).all
    end
    
    def current_user_owner?
      current_user == @article.user unless current_user.nil?
    end
    
    def can?
      current_user_moderator? || current_user_owner?
    end
    
    def can
      unless can?
	flash[:error] = "You must have permissions"
	redirect_to @article
      end
    end
    
    def set_divisions
      @divisions = (current_user_moderator? ? Division.order(:name).all : current_user.divisions.order(:name)) if current_user
    end
    
    def set_groups
      @groups = (current_user_moderator? ? Group.order(:name).load : current_user.groups + current_user.groups.map {|g| g.parent}.select {|g| !g.nil?}.uniq) if current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params[:article][:user_id] = current_user.id unless current_user_moderator?
      params[:article][:user_id] = current_user.id unless params[:article][:user_id]
      params[:article][:published] = false unless current_user_moderator?
      params.require(:article).permit(:title, :content, :article_type_id, :exp_date, :published, :fixed, :commentable, :division_id, :group_id, :user_id, :message)
    end
    
    def set_employees
      @employees = User.includes(:profile).joins(:groups).where(groups: {name: 'employees'}).sort_by{|user| user.profile.full_name} if current_user_moderator?
    end
end
