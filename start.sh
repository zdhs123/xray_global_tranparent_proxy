ip rule add fwmark 1 table 100
ip route add local 0.0.0.0/0 dev lo table 100
iptables -t mangle -N XRAY
iptables -t mangle -A XRAY -d 192.168.10.0/24 -j RETURN
#iptables -t mangle -A XRAY -d 10.1.1.0/24 -j RETURN
iptables -t mangle -A XRAY -d 224.0.0.0/3 -j RETURN
iptables -t mangle -A XRAY -p tcp -j TPROXY --on-port 12345 --tproxy-mark 1
iptables -t mangle -A XRAY -p udp -j TPROXY --on-port 12345 --tproxy-mark 1
iptables -t mangle -A PREROUTING -j XRAY

iptables -t mangle -N XRAY_MASK
iptables -t mangle -A XRAY_MASK -d 192.168.10.0/24 -j RETURN
#iptables -t mangle -A XRAY -d 10.1.1.0/24 -j RETURN
iptables -t mangle -A XRAY_MASK -d 224.0.0.0/3 -j RETURN
iptables -t mangle -A XRAY_MASK -d xxx.xxx.xxx.xxx/32 -j RETURN 
iptables -t mangle -A XRAY_MASK -d 8.8.8.8/32 -j RETURN
iptables -t mangle -A XRAY_MASK -d 8.8.4.4/32 -j RETURN
iptables -t mangle -A XRAY_MASK -d 1.1.1.1/32 -j RETURN
iptables -t mangle -A XRAY_MASK -d 1.0.0.1/32 -j RETURN
iptables -t mangle -A XRAY_MASK -j MARK --set-mark 1
iptables -t mangle -A OUTPUT -p tcp -j XRAY_MASK
iptables -t mangle -A OUTPUT -p udp -j XRAY_MASK

nohup ./xray -c config.json >/dev/null 2>&1 &

ps -ef|grep xray
