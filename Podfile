source 'git@gitlab-ce.emas-poc.com:EMAS-iOS/emas-specs-thirdpart.git'     
source 'git@gitlab-ce.emas-poc.com:EMAS-iOS/emas-specs.git'
source 'git@gitlab.emas-ha.cn:root/emas-specs.git'

platform :ios

target 'EMASDemo' do

platform:ios, '8.0'


    # --通用库
    pod  'UserTrack',        '6.3.5.100005-poc'
    pod  'Reachability',     '3.2'
    pod  'FMDB',             '2.7.2'
    pod  'NetworkSDK',       '10.0.3.2'
    pod  'tnet',             '10.0.3.1'

    # --ACCS(通用库 -> ACCS)
    pod  'TBAccsSDK',        '10.0.3'
    
    # --网关(通用库-> 网关)
    pod  'MtopSDK',          '10.0.4'
    pod  'mtopext/MtopCore', '10.0.4'
    
    # --高可用(通用库-> ACCS -> 高可用)
    pod  'AliHAAdapter4poc',   '10.0.5.1'
    #pod  'ZipArchive', '~> 1.4.0'
    
    # --Weex(通用库-> 高可用 -> 网关 -> Weex)
    pod 'WeexSDK', '0.17.0.1-EMAS'
    pod 'ZCache', '10.0.3'
    #pod 'ZipArchive', '~> 1.4.0'
    pod 'SDWebImage', '3.7.5'
    pod 'DynamicConfiguration', '10.0.3'
    pod 'DynamicConfigurationAdaptor', '10.0.3'

    # --热修复
    pod 'AlicloudLua', '5.1.4.2'
    pod 'AlicloudUtils', '1.2.1'
    pod 'ZipArchive', '~> 1.4.0'
    pod 'AlicloudHotFixDebugEmas', '~> 1.0.3'
    
    
    
    pod 'EMASFirstBundle', '3.0.1'
    
end
