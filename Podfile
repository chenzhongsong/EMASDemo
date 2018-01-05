source "http://10.125.60.155/asdf17128/siyuan-spec.git"
source "http://47.96.131.244:5000/root/emas-specs.git"

source 'git@github.com:CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'

source "git@gitlab.alibaba-inc.com:alipods/specs.git"
source "git@gitlab.alibaba-inc.com:alipods/specs-mirror.git"

platform :ios

target 'EMASDemo' do

#use_frameworks!

platform:ios, '8.0'

#private dependency
#public dependency
#--auto--#







  pod 'EMASFirstBundle', '1.2.8'


# --热修复
	pod 'AlicloudLua', '5.1.4.2'
	pod 'AlicloudUtils', '1.2.1'
	pod 'ZipArchive', '~> 1.4.0'
	pod 'AlicloudHotFixDebugEmas', '~> 1.0.3'
    
    
# --weex
    pod 'WeexSDK', '0.17.0.1-EMAS'
    pod 'ZCache', '0.0.0.3'
    
# --高可用
    pod  'AliHATBAdapter', '1.0.4.13.poc' # 接入层
    pod  'AliHAProtocol',     '1.0.5.1' # 协议层
    pod  'AliHACore',   '1.0.4.10.poc'
    pod  'BizErrorReporter4iOS', '1.0.1.poc-SNAPSHOT' # 如果使用了TBCrashReporterAdapter，请移除相关依赖
    pod  'TBRest', '1.0.0.21-adashx'
    pod  'UserTrack', '6.3.5.43-realtime-poc-SNAPSHOT'
    pod  'FMDB', '~> 2.5' # UT相关
    pod  'Reachability', '3.1.1' # UT相关

    pod  'TBCrashReporter',   '3.0.2.1.poc'
    pod  'CrashReporter',     '1.3.6.17'
    pod  'JDYThreadTrace',     '1.0.0.12'

    pod  'AliHAPerformanceMonitor',     '1.0.4.7'

    pod  'AliHAMethodTrace', '1.0.1.2'
    pod  'TBJSONModel',  '0.1.15'

    pod  'RemoteDebugChannel',  '1.0.1.poc-SNAPSHOT'
    pod  'TRemoteDebugger',  '2.0.1.poc-SNAPSHOT'
    pod  'AliHALogEngine',  '1.0.1.poc-SNAPSHOT'
    pod  'AliyunOSSiOS', '~> 2.6.3'
    pod  'AliHASecurity',  '1.0.1.poc-SNAPSHOT'

# --网关
    pod 'MtopSDK', '1.9.3.48'
    pod 'mtopext/MtopCore', '1.8.0.92'
    
    pod 'NetworkSDK', '6.2.1.32-EMAS'
    pod 'TBAccsSDK', '2.3.1.12-EMAS'
    pod 'tnet', '3.1.10.2-beta'


    pod 'SDWebImage', '3.7.5'

#pod 'swiftProject', :git => 'git@10.125.60.155:zhishui.lcq/swiftProject.git'

end
