class ArchivesController < ApplicationController
  skip_before_filter :authenticate_user!
  def articles
    @articles = Article.where(:article_type_id => 1, :published => true).paginate(:page => params[:page]).where(group_id: current_user.groups + current_user.groups.map {|g| g.parent}.select {|g| !g.nil?}.uniq  + [nil]).order('updated_at DESC')
  end

  def news
    @articles = Article.where(:article_type_id => 2, :published => true).paginate(:page => params[:page]).where(group_id: current_user.groups + current_user.groups.map {|g| g.parent}.select {|g| !g.nil?}.uniq  + [nil]).order('updated_at DESC')
  end

  def anounces
    @articles = Article.where(:article_type_id => 3, :published => true).paginate(:page => params[:page]).where(group_id: current_user.groups + current_user.groups.map {|g| g.parent}.select {|g| !g.nil?}.uniq  + [nil]).order('updated_at DESC')
  end

  def all
    @articles = Article.where(:published => true).where(group_id: current_user.groups + current_user.groups.map {|g| g.parent}.select {|g| !g.nil?}.uniq  + [nil]).paginate(:page => params[:page]).order('updated_at DESC')
  end
end
