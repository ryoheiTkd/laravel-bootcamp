FROM ubuntu:22.04

RUN apt update && apt upgrade

# 日本語を有効に
RUN apt -y install locales locales-all fonts-migmix

# sudoとexpectを入れておく
RUN apt -y install sudo expect

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

# MySQLのルートの設定
ENV MYSQL_DATABASE=chirper_db \
  MYSQL_USER=chirper \
  MYSQL_CLIENT_HOST=% \
  MYSQL_PASSWORD=secret \
  MYSQL_ROOT_PASSWORD=secret \
  TZ=Asia/Tokyo

# MySQLのインストール
RUN sudo apt -y install mysql-server-8.0 mysql-client-8.0

# 設定ファイル　/etc/my.cnfより/etc/mysql/my.cnfの方が優先(詳細度が高い)だったので注意
# COPY ./my.cnf /etc/my.cnf
# RUN sudo chown mysql /etc/my.cnf \
#   && sudo chmod 644 /etc/my.cnf
COPY ./my.cnf /etc/mysql/my.cnf
RUN sudo chown mysql /etc/mysql/my.cnf \
  && sudo chmod 644 /etc/mysql/my.cnf

# ポートのオープン
EXPOSE 3306 33060 33061

# MySQLの初期設定と起動
USER root
COPY mysql_init.sh /tmp
ENTRYPOINT [ "/tmp/mysql_init.sh" ]