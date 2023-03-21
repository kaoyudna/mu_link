# 管理者ログイン用の記述
Admin.create!(
  name: 'admin',
  email: 'mu_link@example.com',
  password: 'mu_link'
)

# ユーザー
[
  ['misaki@example.com', 'Misaki', 'mu_link'],
  ['akihiro@example.com', 'Akihiro', 'mu_link'],
  ['haruki@example.com', 'Haruki', 'mu_link'],
  ['ryusei@example.com', 'Ryusei', 'mu_link'],
  ['saori@example.com', 'Saori', 'mu_link'],
  ['daigo@example.com', 'Daigo', 'mu_link'],
  ['yua@example.com', 'Yua', 'mu_link'],
  ['souta@example.com', 'Souta', 'mu_link'],
  ['kaede@example.com', 'Kaede', 'mu_link'],
  ['rion@example.com', 'Rion', 'mu_link'],
  ['minato@example.com', 'Minato', 'mu_link'],
  ['saki@example.com', 'Saki', 'mu_link'],
  ['aoi@example.com', 'Aoi', 'mu_link'],
  ['eito@example.com', 'Eito', 'mu_link'],
].each do |mail, name, password|
  User.create!(
    { email: mail, name: name, password: password}
  )
  end

#ジャンル
genres = %w(邦楽 ポップス(邦楽) ヒップホップ(邦楽) ロック(邦楽) ダンス(邦楽) 洋楽 ポップス(洋楽) ヒップホップ(洋楽) ロック(洋楽) ダンス(洋楽))
genres.each do |genre|
  Genre.find_or_create_by(name: genre)
end