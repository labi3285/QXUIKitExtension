Pod::Spec.new do |s|

s.name         = "QXUIKitExtension"
s.version      = "0.0.8"
s.summary      = "UIKit extensions in swift5."
s.description  = <<-DESC
UIKit extensions in swift. Just enjoy!
DESC
s.homepage     = "https://github.com/labi3285/QXUIKitExtension"
s.license      = "MIT"
s.author       = { "labi3285" => "766043285@qq.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/labi3285/QXUIKitExtension.git", :tag => "#{s.version}" }
s.source_files  = "QXUIKitExtension/QXUIKitExtension/*"
s.requires_arc = true

end
