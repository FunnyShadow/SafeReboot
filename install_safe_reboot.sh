#!/bin/bash
### 一键安装安全重启脚本
### Made By MainTest233

## 红色报错函数
Error() {
  echo '================================================='
  printf '\033[1;31;40m%b\033[0m\n' "$@"
  echo '================================================='
  exit 1
}

echo_red() {
  printf '\033[1;31m%b\033[0m\n' "$@"
}

echo_green() {
  printf '\033[1;32m%b\033[0m\n' "$@"
}

echo_yellow() {
  printf '\033[1;33m%b\033[0m\n' "$@"
}

## 权限检查
if [ $(whoami) != "root" ]; then
  Error "[x] 请使用 root 权限执行 SafeReboot 安装命令！"
fi

## 设定基础变量
install_path=/usr/share/

## 中国镜像
if [[ -z "${CN}" ]]; then
    if [[ $(curl -m 10 -s https://ipapi.co/json | grep 'China') != "" ]]; then
        echo_yellow "[!] 根据ipapi.co提供的信息, 当前服务器IP可能在中国"
        read -e -r -p "[?] 是否选用中国镜像完成安装? [y/n] " input
        case $input in
        [yY][eE][sS] | [yY])
            echo "[-] 使用中国镜像"
            echo_yellow "[!] 中国镜像由 TRCloud 提供"
            CN=true
            ;;
        [nN][oO] | [nN])
            echo "[-] 不使用中国镜像"
            ;;
        *)
            echo "[-] 使用中国镜像"
            echo_yellow "[!] 中国镜像由 TRCloud 提供"
            CN=true
            ;;
        esac
    fi
fi
if [[ -z "${CN}" ]];
    then download_uri=https://raw.githubusercontent.com/MainTest233/SafeReboot/main/safe_reboot.sh
    else download_uri=https://xiaomcloud.top/api/v3/file/source/791/safe_reboot.sh?sign=d97PC_Cq1wx0z01oDEBjGHoaIUgTf1X7Wk33KZRuQ2k%3D%3A0
fi

## 初始化函数
Init() {
    echo "[↓] 正在更新 apt 源中"
    apt update
    echo "[↓] 正在下载必备组件中"
    apt install -y wget
    echo "[↓] 正在下载核心脚本中....."
    mkdir temp
    cd temp
    wget -O reboot.sh $download_uri
    if [[ $? == 0 ]];
        then echo_green "[√] 成功安装基础文件,进入下一阶段"
    else
        Clean
        Error "[x] 未检测到核心文件,无法继续执行脚本,错误信息应该已经显示!"
    fi
}

## 安装函数
Install() {
    echo "[-] 安装中....."
    chmod 777 reboot.sh
    if [ -d "$install_path" ];
        then mv reboot.sh $install_path
    else
        mkdir $install_path
        mv reboot.sh $install_path
    fi
    echo "[-] 设定环境变量中....."
    if [ -d "/root" ];then
        sed -i '$a alias sudo=\"sudo \"' /root/.bashrc
        sed -i '$a alias reboot=\"bash /usr/share/reboot.sh\"' /root/.bashrc
    else
        Clean
        rm -rf /usr/share/reboot.sh
        Error "[x] 未检测到 /root 目录,无法继续运行安装"
    fi
    if [ -d "/home/" ];then
        sed -i '$a alias sudo=\"sudo \"' /home/*/.bashrc
        sed -i '$a alias reboot=\"bash /usr/share/reboot.sh\"' /home/*/.bashrc
    else
        echo_yellow "[!] 未检测到 /home 目录,跳过设置普通用户的环境变量"
    fi
    echo "[-] 清理残余文件中....."
    Clean
    echo_green "[√] 安装成功"
    echo_yellow "[!] 请使用以下方式让环境变量生效(三选一)"
    echo_yellow "[!] 1.手动重启服务器"
    echo_yellow "[!] 2.重新连接SSH(每个当前活跃的会话都需要重新连接)"
    echo_yellow "[!] 3.手动使用\"source ~/.bashrc\"命令(每个当前在线的账户都需要使用)"
}

## 清理函数
Clean() {
    cd ..
    rm -rf temp
    rm -rf "$0"
}

## 开始
Init
Install
