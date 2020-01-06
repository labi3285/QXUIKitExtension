Pod::Spec.new do |s|

s.name         = "QXUIKitExtension"
s.version      = "0.3.6"
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

s.frameworks   = "MobileCoreServices", "ImageIO"
s.library = 'sqlite3'

s.dependency 'Alamofire', '4.8.2'
s.dependency 'MJRefresh', '~> 3.1.15.7'
s.dependency 'QXJSON', '~> 0.1.1'
s.dependency 'QXMessageView', '~> 0.0.4'
s.dependency 'SAMKeychain', '~> 1.5.3'
s.dependency 'QXConsMaker', '~> 0.0.8'
s.dependency 'TZImagePickerController', '~> 3.2.6'
s.dependency 'IQKeyboardManagerSwift', '~> 6.5.4'
s.dependency 'DSImageBrowse' , '~> 1.0.2'
s.dependency 'YYWebImage' , '~> 1.0.5'
s.dependency 'HandyJSON' , '~> 5.0.1'

# pod trunk push QXUIKitExtension.podspec --allow-warnings

end

