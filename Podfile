
platform :ios, '8.0'
use_frameworks!

target_arry = ['AMDShareModule','ios']
target_arry.each do |t|
    target t do
        pod 'SSBaseKit'
        pod 'SSBaseLib'
        pod 'ShareSDK3', '~>3.6.3'
        # 微信(可选)
        pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
        # 腾讯QQ(可选)
        pod 'ShareSDK3/ShareSDKPlatforms/QQ'
        #新浪微博
        pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
        end
end
