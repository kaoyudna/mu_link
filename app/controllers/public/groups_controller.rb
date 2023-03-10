class Public::GroupsController < ApplicationController
  before_action :authenticate_user!

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @genre = params[:group][:genre_id]
    if @group.save
      @group.users << current_user
      @group.save_genre(@genre)
      redirect_to group_path(@group)
    else
      render 'new'
    end
  end

  def index
    @groups = Group.all.order(created_at: :desc)
    @genres = Genre.all
    if params[:genre_id]
      @genre = Genre.find(params[:genre_id])
      @groups = @genre.groups
    elsif params[:word]
      @groups = Group.search_for(params[:word])
    end
  end

  def show
    @group = Group.find(params[:id])
    @users = @group.users
    @posts = Post.where(user_id: @users)
  end

  def join
    @group = Group.find(params[:id])
    current_user.group_users.create(group_id: @group.id)
    redirect_back(fallback_location: root_path)
  end

  def leave
    @group = Group.find(params[:id])
    current_user.group_users.find_by(group_id: @group.id).destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def group_params
    params.require(:group).permit(:name,:introduction,:owner_id,:group_image)
  end
end
