#!/usr/bin/env bash

export PATH=/usr/local/sbin/:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

cd /home || exit

wget https://ipes-tus.iqiyi.com/update/ipes-linux-amd64-llc-latest.tar.gz
if [[ $? -eq 0 ]]; then
  echo  "tar安装包下载完毕"
fi

tar -zxvf ipes-linux-amd64-llc-latest.tar.gz

mv ipes /data/ipes

/data/ipes/bin/ipes start
if [[ $? -eq 0 ]]; then
  echo  "安装成功"
fi
