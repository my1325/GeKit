Pod::Spec.new do |s|

  s.name         = "GeKit"
  s.version      = "0.0.2.0"
  s.summary      = "Some Useful Tools For iOS"
  s.homepage     = "https://github.com/my1325/GeKit"
  s.license      = "MIT"
  s.platform     = :ios, "9.0"
  s.authors      = { "my1325" => "1173962595@qq.com" }
  s.source       = { :git => "https://github.com/my1325/GeKit.git", :tag => "#{s.version}" }
  s.source_files = "GXWToolKitDemo/GXWToolKitDemo/GeKit/GeKit.h"
  s.public_header_files = 'GXWToolKitDemo/GXWToolKitDemo/GeKit/GeKit.h'

    s.subspec 'GeKitCore' do |ss|
        ss.source_files = 'GXWToolKitDemo/GXWToolKitDemo/GeKit/Core/*.{h,m}'
    end
    s.subspec 'GeKitUI' do |ss|
        ss.source_files = 'GXWToolKitDemo/GXWToolKitDemo/GeKit/UI/*/*.{h,m}'
        ss.dependency 'GeKit/GeKitCore'
#ss.public_header_files = 'GeBase/GeBase/UI/G_BaseHud.h'
    end

    s.subspec 'GeKitFoundation' do |ss|
        ss.source_files = 'GXWToolKitDemo/GXWToolKitDemo/GeKit/Foudation/*/*.{h,m}'
    end

    s.subspec 'GeKitComponents' do |ss|
        ss.source_files = 'GXWToolKitDemo/GXWToolKitDemo/GeKit/Components/*/*.{h,m}'
        ss.dependency 'YYImage'
        ss.dependency 'YYImage/WebP'
        ss.dependency 'YYWebImage'
        ss.dependency 'GeKit/GeKitUI'
        ss.dependency 'GeKit/GeKitFoundation'
    end
end
