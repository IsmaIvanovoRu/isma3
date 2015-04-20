#encoding: UTF-8
class SvedenController < ApplicationController
  skip_before_filter :authenticate_user!
  def struct
    @divisions = Division.order(:name).includes([:division_type]).group_by{|d| t(d.division_type.name, scope: [:divisions])}.sort
  end
  
  def employees
    @posts = Post.includes(:profile).select{|p| p.name =~ /^(про|)ректор/}
    @employees = Profile.includes([:user, :degree, :academic_title]).joins(:divisions).where(divisions: {division_type_id: 3}).sort_by(&:full_name)
  end
end