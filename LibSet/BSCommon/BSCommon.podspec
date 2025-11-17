#
# Be sure to run `pod lib lint BSCommon.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'BSCommon'
    s.version          = '0.1.0'
    s.summary          = 'A short description of BSCommon.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC
    
    s.homepage         = 'https://github.com/'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'jiang' => 'mn998mn@sina.com' }
    s.source           = { :git => 'https://github.com/', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '9.0'
    
    s.source_files = '**/*.{h,m,swift,storyboard,xib}'
    
    s.swift_version = '5'
    
    
     s.resource_bundles = {
       'main' => ['resource/*']
     }
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
     # s.dependency 'BSBase'
     s.dependency 'MGJRouter'
     s.dependency 'Kingfisher'
     s.dependency 'SwiftyUserDefaults'
     s.dependency 'SwiftyJSON'
     s.dependency 'SnapKit'
     s.dependency 'KMPlaceholderTextView'
     s.dependency 'HandyJSON'
     s.dependency 'KSPhotoBrowser'
     s.dependency 'Toast'
     s.dependency 'SVProgressHUD'
     s.dependency 'MJRefresh'
     s.dependency 'JSBadgeView' , '1.4.1'
     s.dependency 'WebViewJavascriptBridge'
     s.dependency 'SwiftEventBus'
     s.dependency 'Moya'
     s.dependency 'YYReach'
     s.dependency 'Bugly'
     s.dependency 'AliyunOSSiOS'

end

