# Mu-link
<img width="1158" alt="Mu_link" src="https://user-images.githubusercontent.com/121837465/228108762-770b45fe-f51a-4e7a-b6c3-ce2e9dd2fd44.png">

## サイト概要

### サイトテーマ
音楽を介してユーザー同士が交流できるSNSサイト

### テーマを選んだ理由
音楽には様々なアーティストやジャンルが存在し、メジャーなものからマイナーなものまで多岐に渡ります。
音楽が好きな人は多いですが、仲を深める前に相手の好きな音楽を把握することは難しく、好きな音楽について話し合いたくても相手が知らなかったらどうしようという懸念がまず生まれます。
そこで、各ユーザーの好きな音楽を知ることができれば、そのような懸念が払拭され、音楽という共通項を介しコミュニケーションを図ることが容易になるのではないかと私は考えました。
そのため、音楽を用いてコミュニケーションを図るきっかけを作ることが可能なアプリケーションを作り、人々の交友関係を広げたいという思いからこのテーマを選定しました。

### ターゲットユーザー
- 音楽が好きな方
- アーティストのライブやコンサートに同行してくれる人を探したい方
- 交友関係を広げたいと思っている方
- 話をする事は好きだが、相手のことを考えすぎて遠慮してしまう方

### 主な利用シーン
- 好きな音楽について語り合いたいとき
- ライブやコンサートに同行してくれる人を探したい時
- 交友関係を広げたい時

### 機能一覧

#### [管理者]

##### ログイン機能
- 管理者は設定されたメールアドレス、パスワードを使用してログインすることが可能です。
##### ユーザー管理機能
- 管理者は不適切なコメントや当サイトの利用目的から以外の投稿をするユーザーなどを退会させることが可能です。
- ユーザーのコメントが管理者によって一定数以上削除されていた場合、攻撃的なユーザーと判断されるため一覧では背景が赤く表示されます。
- 管理者はユーザーのメールアドレスなどの詳細情報を確認することが可能です。
- 管理者はユーザーを検索することが可能です。
##### 投稿管理機能
- 管理者は当サイトの利用目的以外の投稿を発見した時、その投稿を削除することが可能です。
- 管理者は投稿をおこなったユーザー、投稿に対するコメントを閲覧することが可能です。
- 管理者は投稿を検索することが可能です。
##### ジャンル管理機能
- 管理者は必要に応じてジャンルの追加、編集及び削除を行うことが可能です。
##### コメント管理機能
- 管理者は前投稿に対するコメントの一覧を確認することが可能です。
- 管理者は不適切なワードを設定することで攻撃的なコメントや不適切なコメントを容易に発見することができます。
- 管理者はユーザーのコメントを削除することが可能です。
- 管理者はコメントを検索することが可能です。

#### [ユーザー]
##### 新規登録機能
- ユーザーはヘッダーのSing upをクリックすることで新規登録画面へ遷移することが可能です。
- 氏名、メールアドレス、パスワードを入力することで新規会員登録することができます。
##### ログイン機能
- ユーザーはメールアドレスとパスワードを入力することでログインすることができます。
##### アーティスト機能
##### <span style="color: red">無料利用枠のインスタンスを使用しているため、アーティスト情報が多すぎると処理が間に合わずエラーが発生する場合がございます。エラーが発生した場合はページバックを行い再度お試しください</span>
- ユーザーはアーティスト一覧を見ることが可能です。
- ユーザーはアーティストを検索することが可能です。
- ユーザーはお気に入りのアーティストを見つけた場合、お気に入りに登録することができます。
- アーティスト詳細画面にはアーティストをお気に入りしている他のユーザーが表示されます。
- ユーザーはミュージックをお気に入りに追加することが可能です。
- ユーザーはミュージックを視聴することが可能です。(権利関係により視聴不可のミュージックもあります)
##### 投稿機能
- ユーザーはヘッダー左側のハンバーガーメニューを開きNew postをクリックすることで新規投稿画面へ遷移することができます。
- 投稿にはタイトル、本文、投稿画像、タグを設定することができます。
- ユーザーは全ユーザーの投稿一覧を閲覧すること可能です。
- 自身の投稿、フォローしているユーザーの投稿、いいねした投稿、ジャンルの４項目で一覧を絞り込むことが可能です。
- 投稿詳細画面では、投稿したユーザーの情報、投稿したユーザーがお気に入りしているアーティスト、投稿詳細、投稿にいいねしたユーザー、コメントを確認することができます。
##### グループ機能
- ユーザーはヘッダー左側のハンバーガーメニューを開きNew groupをクリックすることで新規投稿画面へ遷移することができます。
- グループ作成では、グループ名、紹介文、グループ画像、グループジャンルを設定することが可能です。
- ユーザーは全グループを閲覧することが可能です。
- ユーザーは自身が所属しているグループの一覧を閲覧することが可能です。
- ユーザーはグループに参加することでグループチャットを行えます。

##### ユーザー機能
- ユーザーは全ユーザーの一覧を閲覧することが可能です。
- ユーザー一覧画面のRecommendationをクリックすると同じアーティストをお気に入り登録しているユーザーが表示されます。
- ユーザー詳細画面ではユーザー情報、お気に入りしているアーティスト、お気に入りしているミュージック、ユーザーの投稿一覧を確認することが可能です。
- ユーザー編集画面ではユーザーネーム、紹介文、プロフィール画像、背景画像、ジャンルの変更が可能です。

##### 通知機能
- ユーザーはマイページで通知を確認することが可能です。
- 通知はいいね通知、フォロー通知、コメント通知、グループチャット通知の４種類です。
- 通知から投稿詳細画面へ遷移すると既読となります。
- 未読の通知がある場合にはヘッダーのプロフィール画像にオレンジのアイコンが表示されます。

## 設計書
- ER図<br>
  https://drive.google.com/file/d/1ZO-D1uXscU8SVnc8IirBdoKQATnCteYV/view?usp=sharing
- テーブル提議書<br>
  https://docs.google.com/spreadsheets/d/1tj6GZf20Qv59Sgr3ilPa2zaG3ApHAhrIkVlyhsmEtto/edit?usp=sharing
- アプリケーション詳細設計書<br>
  https://docs.google.com/spreadsheets/d/1_0p5CZdphSaQpKdwWMPyH8qYxkAdHP9E/edit?usp=sharing&ouid=117174015654615395157&rtpof=true&sd=true

## 開発環境
- OS：Linux(CentOS)
- 言語：HTML,CSS,JavaScript,Ruby,SQL
- フレームワーク：Ruby on Rails
- JSライブラリ：jQuery
- IDE：Cloud9

## 使用素材
- Spotifyの利用規約に基づき、Rspotify(Gem)を用いアーティスト画像やミュージックを使用
- url: https://developer.spotify.com/terms
