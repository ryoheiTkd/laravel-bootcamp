#!/bin/bash
# rootユーザーで実行してください。

# mysqlの起動
# my.cnfで指定しているのでMySQLユーザーとして起動される
service mysql start

# SQL文を一時ファイルに書き込む
cat > /tmp/initialize_mysql.sql <<EOF
-- ルートパスワードのセット
ALTER USER 'root'@'localhost' IDENTIFIED WITH 'caching_sha2_password' BY '${MYSQL_ROOT_PASSWORD}';

-- 匿名ユーザーの削除
DELETE FROM mysql.user WHERE User='';

-- リモートルートログインの無効化
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- テストデータベースの削除
DROP DATABASE IF EXISTS test;

-- ユーザーの作成
CREATE USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
CREATE USER '${MYSQL_USER}'@'${MYSQL_CLIENT_HOST}' IDENTIFIED BY '${MYSQL_PASSWORD}';

-- データベースの作成
CREATE DATABASE ${MYSQL_DATABASE};
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'${MYSQL_CLIENT_HOST}';

-- privilege tablesのリロード
FLUSH PRIVILEGES;
EOF

# SQLファイルを使用してMySQLコマンドを実行
mysql -u root < /tmp/initialize_mysql.sql

# 一時ファイルの削除
rm -f /tmp/initialize_mysql.sql

# 以下はDocker用の設定
# バックグラウンドのMySQLプロセスを終了
service mysql stop
# MySQLをフォアグラウンドで起動
exec mysqld