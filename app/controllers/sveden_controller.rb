#encoding: UTF-8
class SvedenController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def common
    redirect_to article_path(1137)
  end
  
  def struct
    @divisions = Division.order(:name).includes([:division_type]).where(in_structure: true).group_by{|d| t(d.division_type.name, scope: [:divisions])}.sort
  end
  
  def document
    redirect_to article_path(1144)
  end
  
  def education
    redirect_to article_path(1145)
  end
  
  def eduStandarts
    redirect_to article_path(1146)
  end
  
  def employees
    @posts = Post.includes(:profile).select{|p| p.name =~ /^(про|)ректор/}
    @employees = Profile.includes([:user, :degree, :academic_title]).joins(:divisions).where(divisions: {division_type_id: 3}).sort_by(&:full_name)
    respond_to do |format|
      format.html
      format.xls if current_user_administrator?
    end
  end

  def objects
    redirect_to article_path(1148)
  end
  
  def grants
    redirect_to article_path(1149)
  end
  
  def paid_edu
    redirect_to article_path(1150)
  end
  
  def budget
    redirect_to article_path(1151)
  end
  
  def vacant
    redirect_to article_path(1152)
  end
end