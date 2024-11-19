# Lesson Board
 
**Lesson Board**は、習い事の個人教室運営をサポートするWebアプリケーションです。
講師のレッスン管理や生徒とのコミュニケーションを効率化するための機能を提供します。

 ※ポートフォリオとして現在開発中です。 
 
---

## URL

[Lesson Board](http://54.92.39.204/)

現在httpのみですが、httpsも導入予定です。

---

## アプリケーション概要

**Lesson Board**は、以下のようなシーンで活用できます：

- 講師がレッスンスケジュールや生徒情報を簡単に管理  
- 生徒が自分のレッスン予定やノートを閲覧  

#### 主な機能

- 講師&生徒ユーザー登録・ログイン（Devise使用）
- レッスンスケジュール管理（FullCalendar使用）
- レッスンノートの共有

---

## 主な機能

### 講師ユーザー

#### 講師アカウント管理
- アカウント作成、編集、削除

#### 講師プロフィール管理
- プロフィールの表示、編集

#### 生徒アカウント管理
- 生徒の登録、表示、編集、削除

#### レッスンカレンダー
- カレンダー上でレッスンの作成・編集・削除が可能

#### レッスンノート管理
- レッスンに関する詳細なメモや画像資料、動画資料を管理

---

### 生徒ユーザー

#### プロフィール管理
- プロフィールの表示、編集

#### レッスン予定
- 今後のレッスン予定を一覧表示

#### レッスンノート
- レッスン内容や講師からのフィードバックを確認、メモの入力

---

## 使用技術

| 技術               | 詳細                                |
|--------------------|-------------------------------------|
| **Ruby on Rails 7** | アプリケーションのフレームワーク |
| **AWS EC2**         | デプロイ先     |
| **AWS RDS**         | 本番環境のデータベース              |
| **AWS S3**          | 画像や資料のアップロード先          |
| **GitHub Actions**  | CI/CDパイプライン                  |
| **Docker**          | 開発環境のコンテナ化                |
| **MySQL**           | 開発環境のデータベース              |
| **FullCalendar**    | レッスンスケジュールの視覚化         |
| **Bootstrap 5**     | スタイリングとレスポンシブデザイン   |

---

## 今後の課題

- RSpecテストコードの作成
- レッスンノートの検索機能追加  
- レッスンカレンダーのスタイリング

---

READ MEも随時更新予定です。
ご覧いただきありがとうございます。
