# 管理者ログイン用の記述
Admin.create!(
  name: 'admin',
  email: 'mu_link@example.com',
  password: 'mu_link'
)

# ユーザー
[
  ['1','misaki@example.com', 'Misaki', 'mu_link'],
  ['2','akihiro@example.com', 'Akihiro', 'mu_link'],
  ['3','haruki@example.com', 'Haruki', 'mu_link'],
  ['4','ryusei@example.com', 'Ryusei', 'mu_link'],
  ['5','saori@example.com', 'Saori', 'mu_link'],
  ['6','daigo@example.com', 'Daigo', 'mu_link'],
  ['7','yua@example.com', 'Yua', 'mu_link'],
  ['8','souta@example.com', 'Souta', 'mu_link'],
  ['9','kaede@example.com', 'Kaede', 'mu_link'],
  ['10','rion@example.com', 'Rion', 'mu_link'],
  ['11','minato@example.com', 'Minato', 'mu_link'],
  ['12','saki@example.com', 'Saki', 'mu_link'],
  ['13','aoi@example.com', 'Aoi', 'mu_link'],
  ['14','eito@example.com', 'Eito', 'mu_link'],
].each do |id, mail, name, password|
    User.create!(
      { id: id, email: mail, name: name, password: password}
    )
  end


#ジャンル
genres = %w(ポップス(邦楽) ヒップホップ(邦楽) ロック(邦楽) ダンス(邦楽) ポップス(洋楽) ヒップホップ(洋楽) ロック(洋楽) ダンス(洋楽))
genres.each do |genre|
  Genre.find_or_create_by(name: genre)
end

#ユーザージャンル
[
  ['1','1'],
  ['2','1'],
  ['3','1'],
  ['4','1'],
  ['5','8'],
  ['6','8'],
  ['7','8'],
  ['9','8'],
  ['1','2'],
  ['5','2'],
  ['10','2'],
  ['11','2'],
  ['12','2'],
  ['13','2'],
].each do |user_id, genre_id|
    UserGenre.create!(
      { user_id: user_id, genre_id: genre_id}
      )
  end

#アーティストのいいね
[
  ['1','5kVZa4lFUmAQlBogl1fkd6'],
  ['2','5kVZa4lFUmAQlBogl1fkd6'],
  ['3','1snhtMLeb2DYoMOcVbb8iB'],
].each do |user_id, artist|
    ArtistFavorite.create!(
      { user_id: user_id, artist_id: artist }
      )
  end