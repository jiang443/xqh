#
# Be sure to run `pod lib lint BSPush.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'BSPush'
    s.version          = '0.1.0'
    s.summary          = 'A short description of BSPush.'
    
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

    s.swift_version = '5'
    
    s.static_framework = true
        
    s.source_files = '**/*.{h,m,swift}'

     # s.resource_bundles = {
     #   'main' => ['resource/*']
     # }

    s.public_header_files = 'Pod/Classes/**/*.h'

     s.dependency 'BSCommon'
     s.dependency 'JPush'
     s.dependency 'KeychainManager'
     s.dependency 'SwiftEventBus'

    #  s.subspec 'BSJPush' do |sss|
    #     sss.source_files = '**/*.{h,m,swift}'
    #     sss.ios.vendored_frameworks = 'CFNetwork', 'CoreFoundation','CoreTelephony','SystemConfiguration','CoreGraphics','Foundation','UIKit','Security','UserNotifications'
    #     sss.ios.vendored_library    = '*.a'
    #     sss.ios.library  = 'resolv','z'
    # end
     
end

