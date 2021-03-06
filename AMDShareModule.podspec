#
#  Be sure to run `pod spec lint AMDShareModule.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "AMDShareModule"
  s.version      = "1.0.5.33"
  s.summary      = "the module of share"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = "the module of share in the app"

  s.homepage     = "https://github.com/xie244135119/AMDShareModule/blob/master/README.md"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #
  s.author             = { "xieqiang" => "xie244135119@163.com" }
  # Or just: s.author    = "xieqiang"
  # s.authors            = { "xieqiang" => "xieqiang@wdwd.com" }
  # s.social_media_url   = "http://twitter.com/xieqiang"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
   s.platform     = :ios, "8.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://git.wdwd.com/appmodules/amdsharemodule.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

 # s.source_files  = "AMDShareModule/AMDShareModule.h"
  s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  non-essential files like tests, examples and documentation.
  #

   s.resource  = "AMDShareModule/AMDShareModule.bundle"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

#   s.framework  = "UMSocialCore"
#   s.frameworks = "UMSocialCore" , "UMSocialNetwork"

   #s.library   = "UMSocialCore"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

   s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.xcconfig = { "FRAMEWORK_SEARCH_PATHS" => "$(SDKROOT)/UMSocialCore"}
    s.default_subspec = 'Plugin'
    s.dependency "SSBaseKit"
    s.dependency "SSBaseLib"

	#plugin share
	s.subspec "Plugin" do |st|

		st.subspec "Core" do |stt|
	 	stt.source_files="AMDShareModule/AMDShare/PluginShare/*.{h,m}"
		stt.dependency 'AMDShareModule/Plugin/Private'
		end
		
		st.subspec "Private" do |stt|
	 	stt.source_files="AMDShareModule/AMDShare/PluginShare/*/*.{h,m}"
		#stt.dependency "SDWebImage"
		stt.dependency "AMDShareModule/Private"
		end
		
	end


	#platform share
	s.subspec "Platform" do |st|

		st.subspec "Core" do |stt|
	 	stt.source_files="AMDShareModule/AMDShare/PlatformShare/*.{h,m}","AMDShareModule/AMDShare/PlatformShare/*/*.{h,m}"
		
		stt.dependency "AMDShareModule/Private"
		stt.dependency "AMDShareModule/Platform/Protrol"
		stt.dependency "ShareSDK3", '~>3.6.3'
        	# 微信(可选)
		stt.dependency 'WechatOpenSDK','~>1.7.9'        	
		# 腾讯QQ(可选)
        	stt.dependency "ShareSDK3/ShareSDKPlatforms/QQ"
        	#新浪微博
        	stt.dependency "ShareSDK3/ShareSDKPlatforms/SinaWeibo"
        	stt.dependency 'SDWebImage'
        	stt.dependency 'UMengUShare/Core', '~>6.4.5'
        	stt.dependency 'UMengUShare/Social/ReducedWeChat'

		end
		
		st.subspec "Protrol" do |stt|
                stt.source_files="AMDShareModule/AMDShare/PlatformShare/protrol/*.{h,m}"
                end		

	end

	#private
	s.subspec "Private" do |st|
	    st.source_files="AMDShareModule/AMDShare/Service/*.{h,m}"
	    st.dependency "SDWebImage"
	end

end
