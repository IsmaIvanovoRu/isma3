class MethodologicalSupportsController < ApplicationController
  before_action :set_methodological_supports, only: [:destroy]
  before_action :methodological_support_params, only: [:create]

  def create
    @methodological_support = MethodologicalSupport.new(methodological_support_params)
    if @methodological_support.save
      redirect_to @methodological_support.educational_program
    end
  end
  
  def destroy
    @methodological_support.destroy
    redirect_to :back 
  end
  
  private
  
  def set_methodological_supports
    @methodological_support = MethodologicalSupport.find(params[:id])
  end
  
  def methodological_support_params
    params.require(:methodological_support).permit(:id, :attachment_id, :educational_program_id)
  end
  
end