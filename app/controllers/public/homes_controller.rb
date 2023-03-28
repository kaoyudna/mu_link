class Public::HomesController < ApplicationController

  def top
    @posts = Post.get_active_posts.page(params[:page]).per(12)
  end

end
