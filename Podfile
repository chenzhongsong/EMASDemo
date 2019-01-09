source 'git@github.com:CocoaPods/Specs.git'
source 'git@gitlab-ce.emas-poc.com:EMAS-iOS/emas-specs-thirdpart.git'
source 'git@gitlab-ce.emas-poc.com:EMAS-iOS/emas-specs.git'
#source 'git@gitlab.emas-ha.cn:root/emas-specs.git'
#source 'git@gitlab.alibaba-inc.com:alipods/specs.git'

# WeexAceChart
source 'git@gitlab-ce.emas-poc.com:EMAS-Weex-iOS/weex-chart.git'
source 'git@gitlab-ce.emas-poc.com:EMAS-Weex-iOS/native-chart.git'

# WeexComponents
source 'git@gitlab-ce.emas-poc.com:EMAS-Weex-iOS/weex-common.git'
source 'git@gitlab-ce.emas-poc.com:EMAS-Weex-iOS/native-common.git'

#project 'EMASDemo.xcodeproj'

platform :ios

target 'EMASDemo' do

platform:ios, '8.0'


    # --???
    pod  'UserTrack',        '6.3.5.100005-poc'
    pod  'Reachability',     '3.2'
    pod  'FMDB',             '2.7.2'
    pod  'NetworkSDK',       '10.0.4.2'
    pod  'tnet',             '10.2.0'
    pod  'AliEMASConfigure',  '0.0.1.13'

    # --ACCS(??? -> ACCS)
    pod  'TBAccsSDK',         '10.0.7'
    #pod  'TBAccsSDK',  :path=>  '/Users/wuchen.xj/gitemas/tbaccssdk/'
    
    # --PUSH(??? -> PUSH)
    pod  'PushCenterSDK',     '10.0.1'
    #pod  'PushCenterSDK',  :path=>  '/Users/wuchen.xj/gitemas/pushcentersdk/'
    
    # --??(???-> ??)
    pod  'MtopSDK',          '10.0.6'
    pod  'mtopext/MtopCore', '10.0.6'
    
    # --????
    pod 'orange','10.0.0'
    
    # --???(???-> ACCS -> ???)
    pod  'AliHAAdapter4poc',   '10.0.5.2'    
    #pod  'ZipArchive', '~> 1.4.0'
    
    # --Weex(???-> ??? -> ?? -> Weex)
    pod 'WeexSDK', '0.20.0.3-EMAS'
    pod 'ZCache', '10.0.3'
    #pod 'ZipArchive', '~> 1.4.0'
    pod 'SDWebImage', '3.7.5'
    pod 'DynamicConfiguration', '10.0.4'
    pod 'DynamicConfigurationAdaptor', '10.0.4'

    #weex????
    pod 'BindingX', '~> 1.0.2'
    
    #weex????
    pod 'WeexAceChart'
    
    #weex????
    pod 'EmasWeexComponents', '0.0.4'
    pod 'EmasXBase', '0.0.2'
    pod 'EmasSocial', '0.0.1'
    pod 'WeexPluginLoader'
    
    # EMASWeex
    pod 'EMASWeex', '1.3.0'
    pod 'WXDevtool', '~> 0.20.0' ,:configurations => ['Debug']
    pod 'CYLTabBarController', '~> 1.17.14'
    pod 'SocketRocket'
    
    # WindVane
    pod 'WindVane', '1.1.0'
    
    # --???
    pod 'AlicloudLua', '5.1.4.2'
    pod 'AlicloudUtils', '1.3.4'
    pod 'ZipArchive', '~> 1.4.0'
    pod 'AlicloudHotFixDebugEmas', '~> 1.0.5'
    
    # ????
    pod 'EMASMAN', '10.0.0'    
    
   # pod 'EMASFirstBundle', '3.1.1'
    
    
end

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-EMASDemo/Pods-EMASDemo-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
end