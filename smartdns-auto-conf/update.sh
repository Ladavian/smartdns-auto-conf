#!/bin/bash
set -e

# 创建临时目录
mkdir -p rules

# 下载国内域名列表（SmartDNS格式）
curl -sSL https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf   | sed 's/^server=\/\(.*\)\/.*/nameserver \1/' > rules/china.conf

# 下载国外域名列表（GFWList 提取，转 SmartDNS 格式）
curl -sSL https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt   | grep -v '^#' | grep -v '^$' | sed 's/^/nameserver /' > rules/foreign.conf

# 添加时间戳
date +"# Updated at: %Y-%m-%d %H:%M:%S" | tee -a rules/china.conf rules/foreign.conf

# 移动到仓库根目录
mv rules/china.conf china.conf
mv rules/foreign.conf foreign.conf
rm -rf rules
