FROM ubuntu:22.04

RUN apt update && apt upgrade

# 日本語を有効に
RUN apt -y install locales locales-all fonts-migmix

# sudoとadd-apt-repositoryを入れておく
RUN apt -y install sudo software-properties-common

# ユーザーを作成し、パスワードなしでsudo可能にする(ローカルのみ)
ARG USERNAME=chirper
RUN useradd -m -s /bin/bash $USERNAME
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME

# 日本語の有効化
RUN export LC_ALL=ja_JP.UTF-8 \
  && export LANG=ja_JP.UTF-8  \
  && export LANGUAGE=ja_JP.UTF-8

# 開発に必要なパッケージをインストール
RUN sudo apt -y install --no-install-recommends curl git unzip libzip-dev libicu-dev libonig-dev && \
  sudo apt clean && \
  sudo rm -rf /var/lib/apt/lists/*

# 最新版PHP-FPM(8.2)を入れるためにリポジトリを登録し、非対話的インストール
RUN sudo add-apt-repository ppa:ondrej/php \
  && sudo apt update \
  && sudo DEBIAN_FRONTEND=noninteractive TZ=Asia/Tokyo apt -y install php8.2-fpm php8.2-xml php8.2-curl php8.2-intl php8.2-mysql php8.2-zip php8.2-bcmath php8.2-imagick

# composerを入れておく。COPYコマンドは--fromで別のイメージをビルドして結果だけとってこれる
# composerのインストールはファイルを引っ張ってきて…という手順があるので開発機ではこれが楽(CPUアーキテクチャが同じであることを確認)
ENV COMPOSER_NO_INTERACTION=1
ENV COMPOSER_HOME=/usr/local/share/composer
ENV PATH $PATH:$COMPOSER_HOME/vendor/bin
RUN sudo mkdir -p /usr/local/share/composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# 設定ファイルをコピー
# バージョンを指定してインストールした場合、下記のような場所になる
COPY ./c-php.ini /etc/php/8.2/cli/php.ini
COPY ./f-php.ini /etc/php/8.2/fpm/php.ini
COPY ./www.conf /etc/php/8.2/fpm/pool.d/www.conf

# 9000ポートをオープン
EXPOSE 9000

# 実行中のプロセスIDを保存する場所を作成する
RUN sudo mkdir -p /run/php/

# php-fpm8.2を起動
CMD ["sudo", "php-fpm8.2"]

WORKDIR /var/www/chirper

# laravel10のインストールはコンテナ内で実施
# カレントディレクトリにプロジェクトを作成する場合、カレントディレクトリは空である必要がある
# sudo mkdir /usr/local/share/composer/cache
# sudo chown -R chirper /usr/local/share/composer
# rm -rf *
# composer create-project --prefer-dist "laravel/laravel=10.*" .
# chmod -R 777 storage bootstrap/cache
