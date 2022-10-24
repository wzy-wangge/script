#!/usr/bin/env bash

export PATH=/usr/local/sbin/:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

cd /home || exit

wget https://ipes-tus.iqiyi.com/update/ipes-linux-amd64-llc-latest.tar.gz
if [[ $? -eq 0 ]]; then
  echo  "tar安装包下载完毕"
fi

tar -zxvf ipes-linux-amd64-llc-latest.tar.gz

mv ipes /data/ipes

#启用两个进程,加载配置
mkdir /data2
rm -rf /data/ipes/var/db/ipes/happ-conf/custom.yml
wget -N --no-check-certificate https://raw.fastgit.org/wzy-wangge/script/main/mht/custom.yml
mv custom.yml /data/ipes/var/db/ipes/happ-conf/custom.yml

/data/ipes/bin/ipes start
if [[ $? -eq 0 ]]; then
  echo  "安装成功"
fi



client_id=`find /data/ipes/var/db/ipes/ -name happ | xargs ls -lta | awk '{print $9}' | head -1 | awk '{print $0" -d"}' | sh | grep '^[0-9a-zA-Z]\{32\}'`
echo "客户端ID=$client_id";
