class ArticlesController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index, :show]
  before_action :require_writer, only: [:edit, :update, :create, :destroy]
  before_action :set_moderator_permission, only: [:index, :show]
  before_action :set_writer_permission, only: [:show]
  before_action :set_article, only: [:show, :edit, :update, :mercury_update, :destroy]
  before_action :set_article_types, only: [:new, :edit]

  # GET /articles
  # GET /articles.json
  def index
    @articles = ArticleType.where(name: 'articles').first.articles.limit(5)
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @attachment = Attachment.new
    @first_image_attachment = @article.attachments.select {|a| a.mime_type =~ /image/}.first
    @image_attachments = @article.attachments.select {|a| a.mime_type =~ /image/} - [@first_image_attachment]
    @not_image_attachments = @article.attachments.select {|a| a.mime_type !~ /image/}
  end

  # GET /articles/new
  def new
    @article = Article.new
    @divisions = current_user.divisions unless current_user
    @groups = current_user.groups.uniq + current_user.groups.map {|g| g.parent}.select {|g| !g.nil?}.uniq
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    @article.title = ""
    @article.content = ""
    respond_to do |format|
      if @article.save
	redirect_path = '/editor' + article_path(@article)
        format.html { redirect_to redirect_path, notice: 'Article was successfully created.' }
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
   
  def mercury_update
    @article.title = params[:content][:article_title][:value]
    @article.content = params[:content][:article_content][:value]
    @article.save!
    render text: ""
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end
    
    def set_article_types
      @article_types = ArticleType.order(:name).all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :content, :article_type_id, :exp_date, :published, :fixed, :commentable, :division_id, :group_id)
    end
    
    def set_moderator_permission
      @moderator_permission = current_user_moderator?
    end
    def set_writer_permission
      @writer_permission = current_user_writer?
    end
end
