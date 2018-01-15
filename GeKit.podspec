Pod::Spec.new do |s|

  s.name         = "GeKit"
  s.version      = "0.0.0.1"
  s.summary      = "GeKit."
  s.description  = <<-DESC 
                          Common Tools
                   DESC
  s.homepage     = "https://github.com/my1325/GeKit.git"
  s.license      = "MIT"
  s.platform    = :ios, "9.0"
  s.author             = { "my1325" => "1173962595@qq.com" }
  s.source       = { :git => "https://github.com/my1325/GeKit.git", :tag => "#{s.version}" }
  s.source_files  = "GXWToolKitDemo", "GXWToolKitDemo/GXWToolKitDemo/GeKit/**/*.{h,m}"

end
