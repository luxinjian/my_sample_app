class MicropostsController < ApplicationController
  before_filter :signed_in_user

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Post success!"
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    Micropost.find(params[:id]).destroy
    flash[:success] = "Destroyed!"
    redirect_to root_path
  end
end
