# manage-household-publish

## 前提
本プロジェクトは私の身内のみで使用しているIOSアプリのビジネスロジック部分をサンプルとして抽出したものです。<br>
似たような構成のアプリを作成したいといった方のお役に立てられればと思い作成致しました。

## デモ
https://github.com/tcydig/manage-household_publish/assets/53115840/512438fc-ff8b-491d-a3ef-84663aeea4f4

## アプリ概要
2人暮らし専用の家計簿管理アプリ。<br>
アプリの責務としては以下の通り
- 公共料金やネット、食費、その他等をアプリで一元管理し情報の保存/共有を行う
- 2人暮らしのためどちらがどれだけ払うのかを明確化
- 支出のグラフや履歴を残す事で家計改善にもつなげる

## アーキテクチャ
### フロントトエンド
言語：Swift <br>
GUIフレームワーク：SwiftUi<br>
非同期フレームワーク：Combine<br>

### バックエンド
言語：Python<br>
サーバ：Google Cloud Functions for firebase<br>

### データベース
DB：FireStore
