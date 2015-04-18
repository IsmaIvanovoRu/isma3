class SvedenController < ApplicationController
  skip_before_filter :authenticate_user!
  def struct
    @divisions = Division.order(:name).includes(:division_type).group_by{|d| t(d.division_type.name, scope: [:divisions])}.sort
  end
end