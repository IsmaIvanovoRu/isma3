class AttachmentsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:show, :minify_img]
  before_action :set_attachment, only: [:show, :destroy, :minify_img, :inline]
  before_action :require_administrator, only: [:index]

  # GET /attachments
  # GET /attachments.json
  def index
    @attachments = Attachment.all
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
      send_data @attachment.data, :filename => @attachment.title, :type => @attachment.mime_type, :disposition => "inline"
  end
  
  def inline
    send_data @attachment.data, :filename => @attachment.title, :type => @attachment.mime_type, :disposition => "inline"
  end

  # POST /attachments
  # POST /attachments.json
  def create      
      return if params[:attachment].blank?

      @attachment = Attachment.new
      @attachment.uploaded_file = params[:attachment]
      @attachment.thumbnail = thumb(@attachment.data, 0.25) if @attachment.mime_type =~ /image/
      case 
      when params[:article_id]
        @attachment.articles << Article.find(params[:article_id])
      when params[:profile_id]
        @attachment.profiles << Profile.find(params[:profile_id])
      end
      if @attachment.save
	  flash[:notice] = "Thank you for your submission..."
	  redirect_to :back
      else
	  flash[:error] = "There was a problem submitting your attachment."
	  render :action => "new"
      end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def minify_img()
    send_data @attachment.thumbnail, :filename => @attachment.title, :type => @attachment.mime_type, :disposition => "inline"
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_params
      params.require(:attachment).permit(:title, :data, :mime_type, :thumbnail, :content)
    end
      
    def thumb(image, size)
      img = Magick::Image.from_blob(image).first
      img.scale!(size).to_blob
    end
end
