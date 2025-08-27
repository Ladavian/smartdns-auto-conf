#!/bin/bash
set -e

mkdir -p rules

# =============================
# 国内规则
# =============================
curl -sSL https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/china-list.txt > rules/china-list.txt
curl -sSL https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/direct-list.txt > rules/direct-list.txt

# 合并国内规则，去重，转纯域名格式
cat rules/china-list.txt rules/direct-list.txt \
  | grep -v '^#' | grep -v '^$' \
  | sed 's/^server=\/\([^/]*\)\/.*$/\1/' \
  | sort | uniq > rules/china.conf

curl -sSL https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/apple-cn.txt > rules/apple-cn.txt

# 合并国内规则，去重，转纯域名格式
# 修改这里：添加 sed 命令来移除 "full:" 前缀
cat rules/apple-cn.txt \
  | grep -v '^#' | grep -v '^$' \
  | sed 's/^full://' \
  | sed 's/^server=\/\([^/]*\)\/.*$/\1/' \
  | sort | uniq > rules/apple-cn.conf

# =============================
# 国外规则
# =============================
curl -sSL https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/proxy-list.txt > rules/proxy-list.txt
curl -sSL https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt > rules/gfw.txt

# 合并国外规则，去重，转纯域名格式
cat rules/proxy-list.txt rules/gfw.txt \
  | grep -v '^#' | grep -v '^$' \
  | sort | uniq > rules/foreign.conf


# =============================
# 广告拦截规则（AdGuard DNS Filter 转换）
# =============================
curl -sSL https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt > rules/adg-filter.txt

# 提取域名，去掉规则符号，只保留纯域名
grep -E '^\|\|[a-zA-Z0-9.-]+\^' rules/adg-filter.txt | \
grep -v '^@@' | \
sed 's#^\|\|##' | \
sed 's/\^$//' | \
sort | uniq > rules/adblock.conf


# =============================
# 添加更新时间戳
# =============================
date +"# Updated at: %Y-%m-%d %H:%M:%S" | tee -a rules/china.conf rules/foreign.conf rules/adblock.conf rules/apple-cn.conf


# =============================
# 移动生成文件到仓库根目录
# =============================
mv rules/china.conf china.conf
mv rules/foreign.conf foreign.conf
mv rules/adblock.conf adblock.conf
mv rules/apple-cn.conf apple-cn.conf
rm -rf rules
