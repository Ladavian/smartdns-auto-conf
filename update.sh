#!/bin/bash
set -e

mkdir -p rules

# 下载国内规则源
curl -sSL https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf > rules/accelerated-domains.china.conf
curl -sSL https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/direct-list.txt > rules/direct-list.txt
curl -sSL https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/apple-cn.txt > rules/apple-cn.txt

# 合并国内规则，去重，转纯域名格式
cat rules/accelerated-domains.china.conf rules/direct-list.txt rules/apple-cn.txt \
  | grep -v '^#' | grep -v '^$' \
  | sed 's/^server=\/\([^/]*\)\/.*$/\1/' \
  | sort | uniq > rules/china.conf

# 下载国外规则源
curl -sSL https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/proxy-list.txt > rules/proxy-list.txt
curl -sSL https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt > rules/gfw.txt

# 合并国外规则，去重，转纯域名格式
cat rules/proxy-list.txt rules/gfw.txt \
  | grep -v '^#' | grep -v '^$' \
  | sort | uniq > rules/foreign.conf

# 添加更新时间戳
date +"# Updated at: %Y-%m-%d %H:%M:%S" | tee -a rules/china.conf rules/foreign.conf

# 移动生成文件到仓库根目录
mv rules/china.conf china.conf
mv rules/foreign.conf foreign.conf
rm -rf rules
