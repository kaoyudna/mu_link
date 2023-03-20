class Public::GroupsController < ApplicationController
  before_action :authenticate_user!

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @genre_ids = params[:group][:genre_ids].reject(&:blank?).map(&:to_i)
    if @group.save
      @group.users << current_user
      @group.save_genre(@genre_ids)
      redirect_to group_path(@group), notice: "グループを作成しました"
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
    elsif params[:user_id]
      user = User.find(params[:user_id])
      @groups = user.groups
    elsif params[:word]
      @groups = Group.search_for(params[:word])
    end
  end

  def show
    @group = Group.find(params[:id])
    @users = @group.users.where(is_deleted: false)
    @posts = Post.where(user_id: @users)
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    @genre_ids = params[:group][:genre_ids].reject(&:blank?).map(&:to_i)
    if @group.update(group_params)
      @group.save_genre(@genre_ids)
      redirect_to group_path(@group), notice: "グループ情報を変更しました"
    else
      render 'edit'
    end
  end

  def destroy
    group = Group.find(params[:id])
    group.destroy
    redirect_to groups_path, notice: 'グループを削除しました'
  end

  def join
    @group = Group.find(params[:id])
    current_user.group_users.create(group_id: @group.id)
    redirect_to group_path(@group), notice: 'グループへ参加しました'
  end

  def leave
    @group = Group.find(params[:id])
    current_user.group_users.find_by(group_id: @group.id).destroy
    redirect_to groups_path, notice: 'グループを退会しました'
  end

  private

  def group_params
    params.require(:group).permit(:name,:introduction,:owner_id,:group_image)
  end
end
