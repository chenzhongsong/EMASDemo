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
    pod  'UserTrack',        '6.3.5.44-poc'  # 去除UIWebView
    pod  'Reachability',     '3.2'
    pod  'FMDB',             '2.7.2'
    pod  'NetworkSDK',       '10.0.4.6'
    pod  'tnet',             '10.3.0'
    pod  'AliEMASConfigure',  '0.0.1.19'
    
    # --ACCS(通用库 -> ACCS)
    pod  'TBAccsSDK',         '10.0.11'
    
    # --PUSH(通用库 -> PUSH)
    pod  'PushCenterSDK',     '10.0.9'
    
    # --网关(通用库-> 网关)
    pod  'MtopSDK',          '10.1.6'
    pod  'mtopext/MtopCore', '10.1.4' # 去除UIWebView
    
    # --远程配置
    pod 'orange','10.0.0'
    
    # --高可用(通用库-> ACCS -> 高可用)
    pod  'AliHAAdapter4poc',   '10.0.5.6'  # 去除 UIWebView
    #pod  'ZipArchive', '~> 1.4.0'
    
    # --Weex(通用库-> 高可用 -> 网关 -> Weex)
    pod 'WeexSDK', '0.28.0.2-EMAS'  # 去除 UIWebView
    pod 'ZCache', '10.0.9'
    #pod 'ZipArchive', '~> 1.4.0'
    pod 'SDWebImage', '3.7.5'
    pod 'DynamicConfiguration', '10.0.4'
    pod 'DynamicConfigurationAdaptor', '10.0.4'

    #weex开源组件
    pod 'BindingX', '1.0.3-EMAS'
    
    #weex商业图表
    #pod 'WeexAceChart'
    
    #weex商业组件
    #pod 'EmasWeexComponents', '0.0.4'
    
    # EMASWeex
    pod 'EMASWeex', '1.3.1'   # 去除 UIWebView
    pod 'WXDevtool', '0.20.0-EMAS' ,:configurations => ['Debug']
    pod 'CYLTabBarController', '1.17.22-EMAS'
    pod 'SocketRocket', '0.5.1'
    pod 'WeexPluginLoader', '0.0.1.9.1'
    
    # WindVane
    pod 'WindVane', '1.1.0'
    
    # --热修复
    pod 'AlicloudLua', '5.1.4.2'
    pod 'AlicloudUtils', '1.3.4'
    pod 'ZipArchive', '~> 1.4.0'
    pod 'AlicloudHotFixDebugEmas', '~> 1.0.5'
    
    # 数据分析
    pod 'EMASMAN', '10.0.0'
    
    # 更新推送
    pod 'AlicloudUpdate', '1.0.0'
    
    
   # pod 'EMASFirstBundle', '3.1.1'
   # pod 'IOSFirstBundle', '1.0.0'
    
end
