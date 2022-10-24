#!/usr/bin/env bash


export PATH=/usr/local/sbin/:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

CONF="/etc/ssh/sshd_config"
NEW_PORT=7912

SSH_init_1="/etc/init.d/ssh"
SSH_init_2="/etc/init.d/sshd"
if [[ -e ${SSH_init_1} ]]; then
	SSH_init=${SSH_init_1}
elif [[ -e ${SSH_init_2} ]]; then
	SSH_init=${SSH_init_2}
else
	echo -e "找不到 SSH 的服务脚本文件！" && exit 1
fi


echo "开始执行一键安装脚本"


echo "开始修改默认ssh端口"

port_all=$(cat ${CONF}|grep -v '#'|grep "Port "|awk '{print $2}')
if [[ -z ${port_all} ]]; then
  port=22
else
  port=${port_all}
fi

echo -e "旧SSH端口：[${port}]"

if [[ ${port} != ${NEW_PORT} ]]; then
    echo "开始修改端口为：[${NEW_PORT}]"


    cp -f "${CONF}" "/etc/ssh/sshd_config.bak"

    echo -e "删除旧端口配置..."
	  sed -i "/Port ${port}/d" "${CONF}"
	  echo -e "添加新端口配置..."
	  echo -e "\nPort ${NEW_PORT}" >> "${CONF}"
    ${SSH_init} restart
    sleep 2s
fi

echo  "端口修改执行完毕"

echo net.ipv6.conf.all.disable_ipv6=1 > /etc/sysctl.d/disable-ipv6.conf && sysctl -p -f /etc/sysctl.d/disable-ipv6.conf
if [[ $? -eq 0 ]]; then
  echo  "关闭IPv6成功"
fi

sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list && sed -i "s/security.debian.org\/debian-security/mirrors.aliyun.com\/debian-security/g" /etc/apt/sources.list
sed -i s@/mirrors.ecloud.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && sed -i "s/mirrors.ecloud.com\/debian-security/mirrors.aliyun.com\/debian-security/g" /etc/apt/sources.list
if [[ $? -eq 0 ]]; then
  echo  "apt-get源替换为 阿里云成功"
fi

apt-get update && apt-get install -y apt-transport-https  ca-certificates curl  gnupg  lsb-release
if [[ $? -eq 0 ]]; then
  echo  "基础完成"
fi


echo  "开始挂载硬盘"

Disk=/dev/sdb
Mount=/data
mkdir -p $Mount > /dev/null 2>&1
mkfs.ext4 $Disk
mount $Disk $Mount
uuid=$(lsblk -f $Disk|awk 'NR==2 {print $3}')
echo UUID=$uuid $Mount 'ext4 defaults 0 0' >> /etc/fstab


echo "开始安装猕猴桃";

wget -N --no-check-certificate https://raw.fastgit.org/wzy-wangge/script/main/mht/installMHT.sh && chmod +x installMHT.sh && bash installMHT.sh
