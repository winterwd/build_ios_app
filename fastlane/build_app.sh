#!/bin/bash

### 参数传递
## $1 : beta=开发测试包, release=App Store 发版
## 如果未指定参数，缺省为开发测试包

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

## 环境初始化
if [ -z $1 ]; then
	AppENV="beta"
else
	AppENV=$1
fi

## 进入当前.sh所在目录
cd `dirname $0`

# 导入.env文件
if [ $AppENV == "beta" ]; then
	source ./common.env
	# source ./dev.env
else
	source ./common.env
	# source ./appstore.env
fi

# 删除之前的IPA
rm -r ${app_ipa_file}

# 打包APP
build_app() { 
	echo "+-------------------+-------------------+"
	echo "	building... <${AppENV}> ipa"
	echo "+-------------------+-------------------+"
	echo "  build number      | ${build_number}"
	echo "  ipa file          | ${app_ipa_file}"
	echo "+-------------------+-------------------+"

	fastlane ${AppENV}
}

# 上传到fir.im
publish_to_firim(){ 
	echo "+---------------------+------------------+"
	echo "  上传测试包到 fir.im"
	echo "+---------------------+------------------+"
	echo "  ipa file            | ${app_ipa_file}"
	echo "+---------------------+------------------+"

	fir login $firim_token
	# fir publish $app_ipa_file --changelog=${git_changelog_file} --short=${firim_short} --qrcode
	fir publish $app_ipa_file  --short=${firim_short} --qrcode
}

if [ $AppENV == "beta" ]; then
	build_app
	publish_to_firim
	open $app_ipa_qrfile
else
	build_app
fi