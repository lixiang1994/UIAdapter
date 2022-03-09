Pod::Spec.new do |s|

s.name         = "UIAdapter"
s.version      = "1.1.0"
s.summary      = "iOS屏幕适配工具"

s.homepage     = "https://github.com/lixiang1994/UIAdapter"

s.license      = { :type => "MIT", :file => "LICENSE" }

s.author       = { "LEE" => "18611401994@163.com" }

s.platform     = :ios, "9.0"

s.source       = { :git => "https://github.com/lixiang1994/UIAdapter.git", :tag => s.version }

s.source_files  = "Sources/**/*.swift"

s.requires_arc = true

s.swift_version = '5.3'

s.cocoapods_version = '>= 1.4.0'

end
