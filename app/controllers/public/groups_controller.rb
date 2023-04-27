class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only:[:edit, :update]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    # 空の要素を除外し複数、または単数のgenre_idを受け取る
    @genre_ids = params[:group][:genre_ids].reject(&:blank?).map(&:to_i)
    if @group.save
      @group.users << current_user
      @group.save_genres(@genre_ids)
      redirect_to group_path(@group), notice: "グループを作成しました"
    else
      render 'new'
    end
  end

  def index
    @genres = Genre.all
    @groups = case
    when params[:genre_ids]
      genre_ids = params[:genre_ids].reject(&:blank?)
      # 受け取ったgenre_idsを順次配列から取り出し、genreに紐づくグループを取得(重複を禁止)
      Kaminari.paginate_array(genre_ids.map { |id| Genre.find(id).groups }.flatten.uniq(&:id))
    when params[:user_id]
      user = User.find(params[:user_id])
      user.groups
    when params[:word]
      Group.search_for(params[:word])
    else
      Group.all
    end
    @groups = @groups.page(params[:page]).per(10)
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
      @group.save_genres(@genre_ids)
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

  def ensure_correct_user
    group = Group.find(params[:id])
    unless group.owner_id == current_user.id
      redirect_to groups_path, alert: 'グループの編集はオーナユーザーのみ可能です'
    end
  end

end
