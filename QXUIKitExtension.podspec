Pod::Spec.new do |s|

s.name         = "QXUIKitExtension"
s.version      = "0.0.2"
s.summary      = "UKit extensions in swift."
s.description  = <<-DESC
UKit extensions in swift. Just enjoy!
DESC
s.homepage     = "https://github.com/labi3285/QXUIKitExtension"
s.license      = "MIT"
s.author       = { "labi3285" => "766043285@qq.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/labi3285/QXUIKitExtension.git", :tag => "#{s.version}" }
s.source_files  = "QXUIKitExtension/QXUIKitExtension/*.swift"
s.requires_arc = true

end
