class Public::HomesController < ApplicationController

  def top
    @posts = Post.get_active_posts
  end

end
