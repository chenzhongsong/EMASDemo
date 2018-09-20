#!/bin/bash

#Weex脚手架生成脚本
#脚本依赖：
#1. mac系统必须使用GUN的sed，使用命令安装gnu-sed到/usr/local/bin/sed，替换系统FreeBSD的sed. brew install gnu-sed --with-default-names
#   安装完成后执行sed应该看到“GNU sed home page”几个关键字，如果不是说明还是使用的macos系统/usr/bin/sed，需要将/usr/local/bin加入$PATH且在/usr/bin之前
#2. 帮助文档 ./gen_weex_scaffold.sh -h
#3. 命令示例：./gen_weex_scaffold.sh -SDK_CONFIG_APP_KEY appkey -SDK_CONFIG_APP_SECRET appsecret -SDK_CONFIG_CHANNEL_ID 1001@POC_iOS_1.0.0 -SDK_CONFIG_USE_HTTP false -SDK_CONFIG_ACCS_DOMAIN accs.com -SDK_CONFIG_MTOP_DOMAIN mtop.com -SDK_CONFIG_ZCACHE_PREFIX http://zcache.com/prefex -SDK_CONFIG_HOTFIX_URL http://hotfix.com -SDK_CONFIG_HA_OSS_BUCKET ha-oss-bucket -SDK_CONFIG_HA_ADASH_DOMAIN adash.com -APP_NAME myapp -MAVEN_BASE_GROUP com.my -WEEX_UI_SDK 1 -WEEX_BUSINESS_COMPONENTS 1 -WEEX_BUSINESS_CHARTS 1 -WEEX_PAGE_TAB_SIZE 5

set -e

#SDK_CONFIG系统配置
SDK_CONFIG_APP_KEY=""
SDK_CONFIG_APP_SECRET=""
SDK_CONFIG_CHANNEL_ID=""
SDK_CONFIG_USE_HTTP=""
SDK_CONFIG_ACCS_DOMAIN=""
SDK_CONFIG_MTOP_DOMAIN=""
SDK_CONFIG_ZCACHE_PREFIX=""  # ZCache.URL
SDK_CONFIG_HOTFIX_URL=""  # Hotfix.URL
SDK_CONFIG_ORANGE_DOMAIN=""  # RemoteConfig.Domain
SDK_CONFIG_HA_OSS_BUCKET=""  #HA.OSSBucketName
SDK_CONFIG_HA_ADASH_DOMAIN=""  # HA.UniversalHost
SDK_CONFIG_HA_PUBLIC_KEY=""    # HA.RSAPublicKey

#Weex外围SDK配置，传入非""表示启用
WEEX_UI_SDK=""
WEEX_BUSINESS_COMPONENTS=""
WEEX_BUSINESS_CHARTS=""

#WEEX商业组件仓库(仅勾选了商业组件或商业图表选项的WEEX脚手架需要添加)
WEEX_PUBLIC_REPOSITORY_URL=""
WEEX_REPOSITORY_USERNAME=""
WEEX_REPOSITORY_PASSWORD=""

#Weex Native页面配置
WEEX_PAGE_TAB_SIZE=""

#打印帮助文档
printHelp() {
    echo "Weex scaffold generate script."
    echo
    echo "options:"
    echo "   -h help."

    echo "   -SDK_CONFIG_APP_KEY                AppKey，从控制台读取。必填"
    echo "   -SDK_CONFIG_APP_SECRET             AppSecret，从控制台读取。必填"
    echo "   -SDK_CONFIG_CHANNEL_ID             ChannelID。必填"
    echo "   -SDK_CONFIG_USE_HTTP               UseHTTP，从控制台读取。可选"
    echo "   -SDK_CONFIG_ACCS_DOMAIN            ACCS Domain, 从控制台读取。可选"
    echo "   -SDK_CONFIG_MTOP_DOMAIN            MTOP Domain，从控制台读取。可选"
    echo "   -SDK_CONFIG_ZCACHE_PREFIX          ZCache URL，从控制台读取。可选"
    echo "   -SDK_CONFIG_ORANGE_DOMAIN          RemoteConfig Domain，从控制台读取。可选"
    echo "   -SDK_CONFIG_HOTFIX_URL             Hotfix URL，从控制台读取。可选"
    echo "   -SDK_CONFIG_HA_OSS_BUCKET          HA.OSSBucketName，从控制台读取。可选"
    echo "   -SDK_CONFIG_HA_ADASH_DOMAIN        HA.UniversalHost，从控制台读取。可选"
    echo "   -SDK_CONFIG_HA_PUBLIC_KEY          HA.RSAPublicKey，从控制台读取。可选"

    echo "   -WEEX_UI_SDK                       启用weex-ui SDK时设置为1。可选"

    echo "   -WEEX_BUSINESS_COMPONENTS          启用商业组件SDK时设置为1。可选"
    echo "   -WEEX_PUBLIC_REPOSITORY_URL        gradle.properties WEEX商业组件仓库URL，选中商业组件时必选"
    echo "   -WEEX_REPOSITORY_USERNAME          gradle.properties WEEX商业组件仓库用户名，选中商业组件时必选"
    echo "   -WEEX_REPOSITORY_PASSWORD          gradle.properties WEEX商业组件仓库密码，选中商业组件时必选"

    echo "   -WEEX_BUSINESS_CHARTS              启用商业图表SDK时设置为1。可选"
    echo "   -WEEX_PAGE_TAB_SIZE                Weex首页Tab数量，0表示首页非weex，1表示为单页结构，2-5为tab页结构。可选"

    echo
}

checkParameters() {
    echo "开始参数检查..."
    REQUIRED_CONFIGS=(SDK_CONFIG_APP_KEY SDK_CONFIG_APP_SECRET SDK_CONFIG_CHANNEL_ID)
    for config in ${REQUIRED_CONFIGS[@]}
    do
        if [ "${!config}" == "" ]; then
            echo "$config is required."
            exit 1
        fi
    done
    echo "参数检查完成."
}

modifyNativeSDk() {
    echo "开始修改Native SDK配置..."
    SDK_PATH="AliyunEmasServices-Info.plist"
    #替换匹配的下一行
    if [ "$SDK_CONFIG_APP_KEY" != "" ]; then
        #如果">AppKey<"被匹配，则n命令移动到匹配行的下一行，替换这一行的参数
        sed -i "/>AppKey</{n; s/<string>.*/<string>$SDK_CONFIG_APP_KEY<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_APP_SECRET" != "" ]; then
        sed -i "/>AppSecret</{n; s/<string>.*/<string>$SDK_CONFIG_APP_SECRET<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_CHANNEL_ID" != "" ]; then
        sed -i "/>ChannelID</{n; s/<string>.*/<string>$SDK_CONFIG_CHANNEL_ID<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_ACCS_DOMAIN" != "" ]; then
        #如果">ACCS<"被匹配，则n命令移动到匹配行的下3行，替换这一行的Domain信息
        sed -i "/>ACCS</{n;n;n; s/<string>.*/<string>$SDK_CONFIG_ACCS_DOMAIN<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_MTOP_DOMAIN" != "" ]; then
        sed -i "/>MTOP</{n;n;n; s/<string>.*/<string>$SDK_CONFIG_MTOP_DOMAIN<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_ZCACHE_PREFIX" != "" ]; then
        #参数中可能包含/，所以使用@代替/当分隔符
        sed -i "/>ZCache</{n;n;n; s@<string>.*@<string>$SDK_CONFIG_ZCACHE_PREFIX<\/string>@g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_HA_OSS_BUCKET" != "" ]; then
        sed -i "/>OSSBucketName</{n; s/<string>.*/<string>$SDK_CONFIG_HA_OSS_BUCKET<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_HA_ADASH_DOMAIN" != "" ]; then
        #参数中可能包含/，所以使用@当分隔符
        sed -i "/>UniversalHost</{n; s/<string>.*/<string>$SDK_CONFIG_HA_ADASH_DOMAIN<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_HA_PUBLIC_KEY" != "" ]; then
        sed -i "/>RSAPublicKey</{n; s/<string>.*/<string>$SDK_CONFIG_HA_PUBLIC_KEY<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_HOTFIX_URL" != "" ]; then
        #参数中可能包含/，所以使用@代替/当分隔符
        sed -i "/>Hotfix</{n;n;n; s@<string>.*@<string>$SDK_CONFIG_HOTFIX_URL<\/string>@g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_ORANGE_DOMAIN" != "" ]; then
        sed -i "/>RemoteConfig</{n;n;n; s/<string>.*/<string>$SDK_CONFIG_ORANGE_DOMAIN<\/string>/g; }" $SDK_PATH
    fi

    if [ "$SDK_CONFIG_USE_HTTP" != "" ]; then
        sed -i "/>UseHTTP</{n; s/<.*\/>/<$SDK_CONFIG_USE_HTTP\/>/g; }" $SDK_PATH
    fi

    echo "修改Native SDK配置完成."
}


modifyWeexSDK() {
    echo "开始修改weex外围SDK相关配置..."

    GRADLE_PATH="app/build.gradle"

    #weex-ui sdk（bindingx)
    if [ "$WEEX_UI_SDK" == "" ]; then
        #注释：将complie替换成 //complie
        sed -i "/com.alibaba.android:bindingx-core/{ s/compile/\/\/compile/g }" $GRADLE_PATH
        sed -i "/com.alibaba.android:bindingx_weex_plugin/{ s/compile/\/\/compile/g }" $GRADLE_PATH
    else
        #取消注释：将//替换掉成""
        sed -i "/com.alibaba.android:bindingx-core/{ s/\///g }" $GRADLE_PATH
        sed -i "/com.alibaba.android:bindingx_weex_plugin/{ s/\///g }" $GRADLE_PATH
        mv app/src/BindingXInit.java.out app/src/main/java/com/taobao/demo/BindingXInit.java
    fi

    #商业组件SDK
    if [ "$WEEX_BUSINESS_COMPONENTS" == "" ]; then
        #注释：将complie替换成 //complie
        sed -i "/com.alibaba.emas.xcomponent:xbase/{ s/compile/\/\/compile/g }" $GRADLE_PATH
        sed -i "/com.emas.weex:weex-libs/{ s/compile/\/\/compile/g }" $GRADLE_PATH
        sed -i "/com.emas.weex:weex-base/{ s/compile/\/\/compile/g }" $GRADLE_PATH
        sed -i "/com.emas.weex:fingerprint/{ s/compile/\/\/compile/g }" $GRADLE_PATH
        sed -i "/com.emas.weex:patternlock/{ s/compile/\/\/compile/g }" $GRADLE_PATH
        sed -i "/com.alibaba.emas.xcomponent:umeng-social/{ s/compile/\/\/compile/g }" $GRADLE_PATH
        sed -i "/com.amap.api:location/{ s/compile/\/\/compile/g }" $GRADLE_PATH
    else
        #取消注释：将/替换掉成""
        sed -i "/com.alibaba.emas.xcomponent:xbase/{ s/\///g }" $GRADLE_PATH
        sed -i "/com.emas.weex:weex-libs/{ s/\///g }" $GRADLE_PATH
        sed -i "/com.emas.weex:weex-base/{ s/\///g }" $GRADLE_PATH
        sed -i "/com.emas.weex:fingerprint/{ s/\///g }" $GRADLE_PATH
        sed -i "/com.emas.weex:patternlock/{ s/\///g }" $GRADLE_PATH
        sed -i "/com.alibaba.emas.xcomponent:umeng-social/{ s/\///g }" $GRADLE_PATH
        sed -i "/com.amap.api:location/{ s/\///g }" $GRADLE_PATH
    fi
    #选中商业组件需要同时修改gradle.properties信息
    if [ "$WEEX_PUBLIC_REPOSITORY_URL" != "" ]; then
        #参数中可能包含/，所以使用@代替/当分隔符
        sed -i "s@WEEX_PUBLIC_REPOSITORY_URL =.*@WEEX_PUBLIC_REPOSITORY_URL = $WEEX_PUBLIC_REPOSITORY_URL@g" gradle.properties
    fi

    if [ "$WEEX_REPOSITORY_USERNAME" != "" ]; then
        sed -i "s/WEEX_REPOSITORY_USERNAME =.*/WEEX_REPOSITORY_USERNAME = $WEEX_REPOSITORY_USERNAME/g" gradle.properties
    fi

    if [ "$WEEX_REPOSITORY_PASSWORD" != "" ]; then
        sed -i "s/WEEX_REPOSITORY_PASSWORD =.*/WEEX_REPOSITORY_PASSWORD = $WEEX_REPOSITORY_PASSWORD/g" gradle.properties
    fi

    #商业图标SDK
    if [ "$WEEX_BUSINESS_CHARTS" == "" ]; then
        #注释：将complie替换成 //complie
        sed -i "/org.weex.plugin.weexacechart/{ s/compile/\/\/compile/g }" $GRADLE_PATH
        sed -i "/com.alibaba.dt:acechart/{ s/compile/\/\/compile/g }" $GRADLE_PATH
        sed -i "/com.android.support:support-annotations/{ s/compile/\/\/compile/g }" $GRADLE_PATH
        sed -i "/compile .*org.weex.plugin:processor/{ s/compile/\/\/compile/g }" $GRADLE_PATH
        sed -i "/annotationProcessor .*org.weex.plugin:processor/{ s/annotationProcessor/\/\/annotationProcessor/g }" $GRADLE_PATH
    else
        #取消注释：将/替换掉成""
        sed -i "/org.weex.plugin.weexacechart/{ s/\///g }" $GRADLE_PATH
        sed -i "/com.alibaba.dt:acechart/{ s/\///g }" $GRADLE_PATH
        sed -i "/com.android.support:support-annotations/{ s/\///g }" $GRADLE_PATH
        sed -i "/compile .*org.weex.plugin:processor/{ s/\///g }" $GRADLE_PATH
        sed -i "/annotationProcessor .*org.weex.plugin:processor/{ s/\///g }" $GRADLE_PATH
        mv app/src/WeexChartInit.java.out app/src/main/java/com/taobao/demo/WeexChart.java
    fi
    echo "修改weex外围SDK相关配置完成."
}

modifyWeexNativePage() {
    echo "开始修改Weex启动页配置..."
    if [ "$WEEX_PAGE_TAB_SIZE" != "" ]; then
        sed -i "s/\"TabSize\".*/\"TabSize\": \"$WEEX_PAGE_TAB_SIZE\",/g" app/src/main/assets/weex-container.json
    fi
    echo "修改Weex启动页配置完成."
}

while [ $# -gt 0 ];do
    case $1 in
        -h)
            printHelp
            exit 0
            ;;
        -*)
            param_name=${1##-}
            shift
            eval $param_name=$1
            shift
            ;;
    esac
done

#测试代码
echo "参数 WEEX_REPOSITORY_USERNAME 的值为 $WEEX_REPOSITORY_USERNAME"

#0. 参数检查
checkParameters

#1. native sdk配置修改
modifyNativeSDk

#2. 发布包名修改(IOS暂不支持)

#3. weex外围sdk相关配置
#modifyWeexSDK

#4. Weex Native页面配置
#modifyWeexNativePage
