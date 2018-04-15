#!/bin/bash

### fir.im 上传失败后 执行

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

## 进入当前.sh所在目录
cd `dirname $0`

# 导入.env文件
source ./common.env
source ./dev.env

echo "+---------------------+------------------+"
echo "  重新上传测试包到 fir.im"
echo "+---------------------+------------------+"
echo "  ipa file            | ${app_ipa_file}"
echo "+---------------------+------------------+"

fir login $firim_token
fir publish $app_ipa_file  --short=${firim_short} --qrcode
