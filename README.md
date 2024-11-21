# Lesson Board
 
**Lesson Board**は、習い事の個人教室運営をサポートするWebアプリケーションです。
レッスン管理や生徒とのコミュニケーションを効率化するための機能を提供します。

 ※ポートフォリオとして現在開発中です。 
 
---

## URL

[Lesson Board](http://54.92.39.204/)

現在httpのみですが、httpsも導入予定です。

---

## アプリケーション概要

**Lesson Board**は、以下のように活用できます：

- 講師の方　レッスンスケジュールやレッスンノートの管理・共有、生徒管理  
- 生徒の方　自分のレッスン予定やレッスンノートの確認

#### 主な機能

- 講師&生徒ユーザー登録・ログイン（Devise使用）
- レッスンスケジュール管理（FullCalendar使用）
- レッスンノートの共有

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

## 機能詳細

### 講師ユーザー

#### 講師アカウント管理
- アカウント作成、編集、削除

#### 講師プロフィール管理
- プロフィールの表示、編集

#### 生徒アカウント管理
- 生徒の登録、表示、編集、削除

#### レッスンカレンダー
- カレンダー上でレッスンの作成・編集・削除が可能

#### レッスンノート
- レッスンの記録。メモや画像資料、動画資料を生徒と共有

---

### 生徒ユーザー

#### プロフィール管理
- プロフィールの表示、編集

#### レッスン予定
- 今後のレッスン予定を一覧表示

#### レッスンノート
- レッスン内容や画像資料・動画資料を閲覧、メモの共有

---

## 今後の課題

- RSpecテストコードの作成
- レッスンカレンダーのスタイリング
- データベースのカラム設計見直し

---

## さらに先の課題

- レッスンノートの検索機能追加
- 一覧表示のページネーション追加
- レッスン調整機能の追加（日程調整API等の導入の検討）
- 月謝支払い状況の記録・支払い機能

---

READ MEも随時更新予定です。
ご覧いただきありがとうございます。
