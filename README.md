# Nuxt.js + AWS ECS Fargate + CodePipeline を使ったサーバーレスのCI/CD環境

## 構成

img

1. Nuxt.js（SSR）のコードを GitHub にプッシュするとCodePipelineが走る。
2. CodeBuild でイメージをビルド。ECRへイメージを登録
3. CodeBuild の成功を受けてタスク・サービスの更新。
4. ECS（Fargate）が ECR からイメージ取得。
5. CodeDeploy が ECS（Fargate）へデプロイ。

img

VPC内はコンテナタスクを各サブネットに配置しALBで分散する。



## コマンド

### Nuxt.js

```bash
# install dependencies
$ npm install

# serve with hot reload at localhost:3000
$ npm run dev

# build for production and launch server
$ npm run build
$ npm run start

# generate static project
$ npm run generate
```

### Docker

```bash
# ユーザー切り替え
$ export AWS_DEFAULT_PROFILE=nuxt-fargate_app

# 認証トークンを取得し、レジストリに対して Docker クライアントを認証します。
$ aws ecr get-login-password | docker login --username AWS --password-stdin https://123456789012.dkr.ecr.ap-northeast-1.amazonaws.com

# Docker イメージを構築します。
$ docker build -t nuxt-fargate_app:latest .

# 構築が完了したら、このリポジトリにイメージをプッシュできるように、イメージにタグを付けます。
$ docker tag nuxt-fargate_app:latest 123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/nuxt-fargate_app:latest

# 新しく作成した AWS リポジトリにこのイメージをプッシュします。
$ docker push 123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/nuxt-fargate_app:latest
```



## 実際の案件で考慮すべき点

- サービスのスケール面
  - ALBのターゲットグループ設定
  - DockerのCPU、メモリ設定
- アプリケーション設定
  - DNS設定
  - nuxt.config.js
- ビルド・デプロイ設定
  - テスト
  - ステージングや本番環境などステージごとのデプロイ
- セキュリティ
  - VPC、タスク定義ロールなど



## ブログ記事

- [Nuxt.jsアプリ作成〜ECRリポジトリへのプッシュ](https://jtk.hatenablog.com/entry/2021/03/21/165736)
- [ALBとECS Fargate展開](https://jtk.hatenablog.com/entry/2021/03/22/131359)
- [CI/CD環境作成](https://jtk.hatenablog.com/entry/2021/03/24/181513)
- [まとめ](https://jtk.hatenablog.com/entry/2021/03/25/162223)
