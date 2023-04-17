class Public::ArtistsController < ApplicationController
  before_action :authenticate_user!

  # Spotify Web API へアクセス
  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  # 注意: 無料利用枠のEC2インスタンスを使用しているため検索時に 429 Too Many Requests エラーが発生する可能性があります。
  def index
    if params[:word].present?
      # @aritsts = 入力されたwordに関連するアーティスト一覧(日本国内の人気順に表示)
      @artists = Kaminari.paginate_array(RSpotify::Artist.search(params[:word], market: 'JP')).page(params[:page]).per(4)
    else
      # wordが入力されていない場合は'a'の文字に関連するアーティストを取得(日本国内の人気順に表示)
      @artists = Kaminari.paginate_array(RSpotify::Artist.search('a', market: 'JP')).page(params[:page]).per(4)
    end
  end

  def show
    @artist = RSpotify::Artist.find(params[:id])
    #@users = @artistをいいねしているユーザー一覧
    @users = User.where(id: ArtistFavorite.where(artist_id: @artist.id).pluck(:user_id)).where(is_deleted: false)
  end

end
