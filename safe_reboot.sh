#!/bin/bash
# 安全重启脚本
# Made By MainTest233

Error() {
  echo '================================================='
  printf '\033[1;31;40m%b\033[0m\n' "$@"
  echo '================================================='
  exit 1
}

if [ $(whoami) != "root" ]; then
  Error "[x] 请使用 \"sudo reboot\" 或者使用具有 root 权限的用户执行此命令!"
fi

read -r -p "[?] 确定已经关闭了所有东西,并且准备好了要重启吗? (输入yes继续): " yes;

if [ "$yes" != "yes" ];then
  	echo "[!] Abort Reboot"
  	exit;
fi

if [ "$yes" == "yes" ];then
  	echo "[√] 已计划在 5s 后进行重启"
    shutdown -r 5
  	exit;
fi