
platform :ios, '8.0'
use_frameworks!

target_arry = ['AMDShareModule','ios']
target_arry.each do |t|
    target t do
        pod 'SSBaseKit'
        pod 'SSBaseLib'
        pod 'ShareSDK3', '~>3.6.3'
        # 微信(可选)
#        pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
       pod 'WechatOpenSDK','~>1.7.9'
        # 腾讯QQ(可选)
        pod 'ShareSDK3/ShareSDKPlatforms/QQ'
        #新浪微博
        pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
        #图片缓存类
        pod 'SDWebImage'
        
        # 友盟分享和
        pod 'UMengUShare/Core', '~>6.4.5'
        pod 'UMengUShare/Social/ReducedWeChat'
#        pod 'UMengSocialCOM'
        end
end
