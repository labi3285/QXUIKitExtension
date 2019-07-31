Pod::Spec.new do |s|

s.name         = "QXUIKitExtension"
s.version      = "0.1.2"
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

s.dependency 'Alamofire', '4.8.2'
s.dependency 'Kingfisher', '~> 4.10.1'
s.dependency 'MJRefresh', '~> 3.1.15.7'
s.dependency 'QXConsMaker', '~> 0.0.3'
s.dependency 'QXJSON', '~> 0.1.1'
s.dependency 'QXMessageView', '~> 0.0.3'
s.dependency 'SAMKeychain', '~> 1.5.3'

end
