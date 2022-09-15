#!/usr/bin/env bash


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