class AttachmentsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:show, :inline, :minify_img]
  skip_before_filter :current_user, only: [:inline, :minify_img]
  skip_before_filter :set_permissions, only: [:inline, :minify_img]
  skip_before_filter :set_menus, only: [:inline, :minify_img]
  skip_before_filter :profile_empty?, only: [:inline, :minify_img]
  skip_before_filter :set_alert, only: [:inline, :minify_img]
  skip_before_filter :set_details, only: [:inline, :minify_img]
  skip_before_filter :feedbacks_count, only: [:inline, :minify_img]
  skip_before_filter :articles_count, only: [:inline, :minify_img]
  before_action :set_attachment, only: [:show, :edit, :update, :destroy, :minify_img, :inline]
  before_action :require_administrator, only: [:index]
  before_action :require_writer, only: [:edit, :create, :update, :destroy]

  # GET /attachments
  # GET /attachments.json
  def index
    @mime_types = Attachment.select(:mime_type).all.map{|a| a.mime_type}.uniq
    @attachments = Attachment.select(:id, :title, :mime_type, :score, :thumbnail_name).order("score DESC").where(attachments_params).paginate(:page => params[:page])
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
    Attachment.record_timestamps = false
    @attachment.score += 1
    @attachment.save
    Attachment.record_timestamps = true
    path = @attachment.file_name[0..2].split('').join('/')
    send_file Rails.root.join('public', 'storage', path, @attachment.file_name), :filename => @attachment.title, :type => @attachment.mime_type, :disposition => "inline"
  end
  
  def inline
    path = @attachment.file_name[0..2].split('').join('/')
    send_file Rails.root.join('public', 'storage', path, @attachment.file_name), :filename => @attachment.title, :type => @attachment.mime_type, :disposition => "inline"
  end
  
  def edit
    @article = Article.select(:id).find(params[:article_id])
  end

  # POST /attachments
  # POST /attachments.json
  def create
    if attachment_params[:id].blank? && attachment_params[:files].nil?
      flash[:error] = "There was a problem submitting your attachment."
      redirect_to :back
    else
      unless attachment_params[:id].blank?
	@attachment = Attachment.find(attachment_params[:id])
	case 
	  when params[:article_id]
	    article = Article.find(params[:article_id])
	    @attachment.articles << article
	    article.update_attributes(published: false) unless current_user_moderator?
	    article.update_attributes(updated_at: Time.now)
	  when params[:division_id]
	    @attachment.divisions << Division.find(params[:division_id])
	end
	flash[:notice] = "Thank you for your submission..."
	redirect_to :back
      else
        attachment_params[:files].each do |file|	
          @attachment = Attachment.new
          gravity = params[:user_id] ? 'north' : 'default'
          @attachment.uploaded_file(file, gravity)
          if @attachment.save
            case
            when params[:article_id]
              article = Article.find(params[:article_id])
              @attachment.articles << article
              article.update_attributes(published: false) unless current_user_moderator?
              article.update_attributes(updated_at: Time.now)
            when params[:division_id]
              division = Division.find(params[:division_id])
              @attachment.divisions << division
            when params[:user_id]
              user = User.find(params[:user_id])
              user.profile.attachments << @attachment
            end
          else
              flash[:error] = "There was a problem submitting your attachment."
              redirect_to :back
          end
        end
        flash[:notice] = "Thank you for your submission..."
        redirect_to :back
      end
    end
  end

  def update
    if attachment_params[:id].blank? && attachment_params[:file].nil?
      flash[:error] = "There was a problem submitting your attachment."
      redirect_to :back
    else
      @attachment.user_id = current_user.id
      @attachment.uploaded_file(attachment_params[:file])
      if @attachment.save
        if params[:article_id]
          article = Article.find(params[:article_id])
          article.update_attributes(published: false) unless current_user_moderator?
          article.update_attributes(updated_at: Time.now)
          flash[:notice] = "Thank you for your submission..."
          redirect_to article
        end
      else
        flash[:error] = "There was a problem submitting your attachment."
        redirect_to :back
      end
    end
  end
  
  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    if (@attachment.articles.count + @attachment.divisions.count + @attachment.profiles.count) > 1 && params[:article_id]
      article = Article.find(params[:article_id])
      @attachment.articles.delete(article) if article
      redirect_to :back
    else
      file_name = @attachment.file_name
      thumbnail_name = @attachment.thumbnail_name
      attachments_count = Attachment.where(file_name: file_name).count
      if @attachment.destroy && attachments_count == 1
        path = @attachment.file_name[0..2].split('').join('/')
        File.delete(Rails.root.join('public', 'storage', path, file_name)) if file_name
        File.delete(Rails.root.join('public', 'storage', path, thumbnail_name)) if thumbnail_name
      end
      redirect_to :back
    end
  end

  def minify_img()
    path = @attachment.file_name[0..2].split('').join('/')
    send_file Rails.root.join('public', 'storage', path, @attachment.thumbnail_name), :filename => @attachment.title, :type => @attachment.mime_type, :disposition => "inline"
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_params
      params.require(:attachment).permit(:id, :file, files: [])
    end
    
    def attachments_params
      params.permit(:mime_type)
    end
end
