# 起動方法

## Laravelのインストール

```
docker compose up -d
chmod -R 777 storage bootstrap/cache #Laravelのファイル置き場とキャッシュに権限付与
composer install #composer.jsonは作っているのでインストールでOK
```

この段階ではエラーが出ます。laravelのログを必要ならチェックしてください。

```
cat storage/logs/laravel.log
```

## .envファイルの作成

```
cp .env.example .env # MySQLの接続部分を編集済みです。
```

この段階でもまだエラーが出ます。.envでAPP_DEBUG=trueが指定されているため、localhost:8080にアクセスするとエラーが表示されるようになります。

## アプリケーション暗号化キーの作成

```
php artisan key:generate
```

この段階でLaravelのWelcome画面が表示されるようになります。

## シンボリックリンクの作成

```
php artisan storage:link
```

Laravelではstorageにファイルを保管することが多いためです。こうすることで/public/storage → /storage/app/publicを参照できるようになります。

例：
```
<img src="{{ asset("storage/app/public/logo.png") }}" >
```
