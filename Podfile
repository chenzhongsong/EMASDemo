# mPaaS Pods Begin
plugin "cocoapods-mPaaS"
source "https://code.aliyun.com/mpaas-public/podspecs.git"
mPaaS_baseline '10.1.68'  # 请将 x.x.x 替换成真实基线版本
mPaaS_version_code 16   # This line is maintained by MPaaS plugin automatically. Please don't modify.
# mPaaS Pods End
# ---------------------------------------------------------------------
 


source 'git@gitlab-ce.emas-poc.com:EMAS-iOS/emas-specs-thirdpart.git'
source 'git@gitlab-ce.emas-poc.com:EMAS-iOS/emas-specs.git'
source 'git@gitlab.emas-poc.com:root/emas-specs.git'
#source 'git@gitlab.alibaba-inc.com:alipods/specs.git'

# WeexAceChart
#source 'git@gitlab-ce.emas-poc.com:EMAS-Weex-iOS/weex-chart.git'
#source 'git@gitlab-ce.emas-poc.com:EMAS-Weex-iOS/native-chart.git'

# WeexComponents
#source 'git@gitlab-ce.emas-poc.com:EMAS-Weex-iOS/weex-common.git'
#source 'git@gitlab-ce.emas-poc.com:EMAS-Weex-iOS/native-common.git'

#project 'EMASDemo.xcodeproj'

platform :ios

target 'EMASDemo' do

platform:ios, '9.0'


    # --通用库
    # pod  'UserTrack',        '6.3.5.46-poc'  # 和 小程序 SDK 冲突 使用下面的SDK
    pod  'UserTrack',        '6.3.5.100005-noUTDID'
    pod  'Reachability',     '3.2'
    pod  'FMDB',             '2.7.2'
    pod  'NetworkSDK',       '10.0.4.6'
    pod  'tnet',             '10.3.0'
    pod  'AliEMASConfigure', '0.0.1.19'
    
    # --ACCS(通用库 -> ACCS)
    pod  'TBAccsSDK',         '10.0.11'
    
    # --PUSH(通用库 -> PUSH)
    pod  'PushCenterSDK',     '10.0.11'
    
    # --网关(通用库-> 网关)
    pod  'MtopSDK',          '10.1.6'
    pod  'mtopext/MtopCore', '10.1.4'
    
    # --远程配置/var/folders/fr/g4_wck5d5_b98qt47q5y4m0c0000gp/T/TemporaryItems/（screencaptureui正在存储文稿，已完成4）/截屏2020-09-01 下午4.48.24.png
    pod 'orange','10.0.0'
    
    # --高可用(通用库-> ACCS -> 高可用)
    pod  'AliHAAdapter4poc',   '10.0.5.7'
    #pod  'ZipArchive', '~> 1.4.0'
    
    # --Weex(通用库-> 高可用 -> 网关 -> Weex)
    # pod 'WeexSDK', '0.28.0-EMAS'
    
    pod 'WeexSDK', '0.28.0.2-EMAS'
    pod 'ZCache', '10.0.9'
    #pod 'ZipArchive', '~> 1.4.0'
    
    remove_pod "mPaaS_SDWebImage"
    
    pod 'SDWebImage', '3.7.5'  # 和 小程序 SDK 冲突 
    # pod 'SDWebImage' , '5.8.4' # 最新版本
    # pod 'SDWebImage', '1.0.0.200404155527'
    
    pod 'DynamicConfiguration', '10.0.4'
    pod 'DynamicConfigurationAdaptor', '10.0.6'

    #weex开源组件
    pod 'BindingX', '1.0.3-EMAS'
    
    #weex商业图表
    #pod 'WeexAceChart'
    
    #weex商业组件
    #pod 'EmasWeexComponents', '0.0.6'
    
    # EMASWeex
    pod 'EMASWeex', '1.3.1'
    pod 'WXDevtool', '0.20.0-EMAS' ,:configurations => ['Debug']
    pod 'CYLTabBarController', '1.17.22-EMAS'
    # pod 'SocketRocket', '0.5.1'  # 和 小程序 SDK 冲突 暂且删除
    pod 'WeexPluginLoader', '0.0.1.9.1'
    
    # WindVane
    pod 'WindVane', '1.1.0'
    
    # --热修复
    pod 'AlicloudLua', '5.1.4.2'
    # pod 'AlicloudUtils', '1.3.4' # 和 小程序 SDK 冲突 使用下面的SDK
    pod 'AlicloudUtils', '1.3.4-noUTDID'
    pod 'ZipArchive', '~> 1.4.0'
    pod 'AlicloudHotFixDebugEmas', '~> 1.0.5'
    
    # 数据分析
    pod 'EMASMAN', '10.0.0'
    
    # 更新推送
    # pod 'AlicloudUpdate', '1.0.0' # 和 小程序 SDK 冲突 使用下面的SDK
    pod 'AlicloudUpdate', '1.0.0-noUTDID'
    
    
   # pod 'EMASFirstBundle', '3.1.1'
   # pod 'IOSFirstBundle', '1.0.0'
   
   # 小程序
      mPaaS_pod "mPaaS_TinyApp"
      mPaaS_pod "mPaaS_Share"
     # mPaaS_pod "mPaaS_AliAccount"
    
end

