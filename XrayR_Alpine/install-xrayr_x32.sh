#!/bin/sh
# 更新软件源
apk update
# 安装依赖项
apk add wget unzip openrc
# 下载 XrayR
wget https://raw.githubusercontent.com/XrayR-project/XrayR/releases/download/v0.9.4/XrayR-linux-32.zip
# 解压缩
unzip XrayR-linux-32.zip -d /etc/XrayR
# 添加执行权限
chmod +x /etc/XrayR/XrayR
# 创建软链接
ln -s /etc/XrayR/XrayR /usr/bin/XrayR
# 创建 XrayR 服务文件
cat > /etc/init.d/XrayR <<EOF
#!/sbin/openrc-run

depend() {
    need net
}

start() {
    ebegin "Starting XrayR"
    start-stop-daemon --start --exec /usr/bin/XrayR -- -config /etc/XrayR/config.yml
    eend $?
}

stop() {
    ebegin "Stopping XrayR"
    start-stop-daemon --stop --exec /usr/bin/XrayR
    eend $?
}

restart() {
    ebegin "Restarting XrayR"
    start-stop-daemon --stop --exec /usr/bin/XrayR
    sleep 1
    start-stop-daemon --start --exec /usr/bin/XrayR -- -config /etc/XrayR/config.yml
    eend $?
}
EOF

# 添加执行权限
chmod +x /etc/init.d/XrayR

mkdir /etc/runlevels/xrayr

# 添加到开机启动项中
rc-update add XrayR xrayr

echo "安装完成！"
