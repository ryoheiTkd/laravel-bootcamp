FROM ubuntu:22.04

RUN apt update && apt upgrade

# 日本語を有効に
RUN apt -y install locales locales-all fonts-migmix

# sudoを入れておく
RUN apt -y install sudo

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

# リポジトリを追加
RUN sudo apt -y install -y curl gnupg2 lsb-release && \
    sudo curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/nginx_signing.gpg - && \
    echo "deb http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list && \
    echo "deb-src http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" | sudo tee -a /etc/apt/sources.list.d/nginx.list

# Nginxの最新安定版をインストール
# この際、nginxユーザーも自動的に作られる。
# FW設定もDockerのポートのマップがされるので不要。
RUN sudo apt update && \
    sudo apt -y install nginx
# アプリケーションごとに設定するためdefaultは削除
RUN sudo rm /etc/nginx/conf.d/default.conf

WORKDIR /var/www/chirper

CMD ["sudo", "nginx", "-g", "daemon off;"]