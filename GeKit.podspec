Pod::Spec.new do |s|

  s.name         = "GeKit"
  s.version      = "0.0.0.2"
  s.summary      = "GeKit."
  s.description  = <<-DESC 
                          Common Tools
                   DESC
  s.homepage     = "https://github.com/my1325/GeKit.git"
  s.license      = "MIT"
  s.platform    = :ios, "9.0"
  s.author             = { "my1325" => "1173962595@qq.com" }
  s.source       = { :git => "https://github.com/my1325/GeKit.git", :tag => "#{s.version}" }
  s.source_files  = "GXWToolKitDemo", "GXWToolKitDemo/GXWToolKitDemo/GeKit/Core/*.{h,m}"

    s.subspec 'GeKitUI' do |ss|
        ss.source_files = 'GXWToolKitDemo/GXWToolKitDemo/GeKit/UI/*/*.{h,m}'
#ss.public_header_files = 'GeBase/GeBase/UI/G_BaseHud.h'
    end

    s.subspec 'GeKitFoundation' do |ss|
        ss.source_files = 'GXWToolKitDemo/GXWToolKitDemo/GeKit/Foudation/*/*.{h,m}'
    end

    s.subpec 'GeKitComponents' do |ss|
        ss.source_files = GXWToolKitDemo/GXWToolKitDemo/GeKit/Components/*/*.{h,m}'
        ss.dependency 'YYImage'
        ss.dependency 'YYImage/WebP'
        ss.dependency 'YYWebImage'
    end
end
