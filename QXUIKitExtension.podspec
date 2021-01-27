Pod::Spec.new do |s|

s.swift_versions = "5.0"

s.name         = "QXUIKitExtension"
s.version      = "0.4.7"
s.summary      = "UIKit extensions in swift5."
s.description  = <<-DESC
UIKit extensions in swift. Just enjoy!
DESC
s.homepage     = "https://github.com/labi3285/QXUIKitExtension"
s.license      = "MIT"
s.author       = { "labi3285" => "766043285@qq.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/labi3285/QXUIKitExtension.git", :tag => "#{s.version}" }
s.source_files = "QXUIKitExtension/QXUIKitExtension/*"

s.resources = "QXUIKitExtension/QXUIKitExtension/QXUIKitExtensionResources.bundle"
s.requires_arc = true

s.frameworks   = "CoreServices", "ImageIO"
s.library = 'sqlite3'

s.dependency 'QXJSON', '~> 0.1.1'
s.dependency 'QXMessageView', '~> 0.0.6'
s.dependency 'QXConsMaker', '~> 0.0.8'

s.dependency 'Alamofire', '4.9.1'
s.dependency 'YYWebImage' , '~> 1.0.5'
s.dependency 'MJRefresh', '~> 3.1.15.7'
s.dependency 'JQCollectionViewAlignLayout' , '~> 0.1.5'
s.dependency 'SAMKeychain', '~> 1.5.3'
s.dependency 'HandyJSON' , '~> 5.0.3-beta'
s.dependency 'JSONKit-iOS6Later' , '~> 2.0.1'

# pod trunk push QXUIKitExtension.podspec --allow-warnings

end

