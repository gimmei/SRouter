#
#  Be sure to run `pod spec lint SRouter.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "SRouter"
  s.version      = "0.0.4"
  s.summary      = "another simple router for ios."
  s.homepage     = "https://github.com/angelcs1990/SRouter"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "cs" => "angelcs1990@sohu.com" }
  s.platform     = :ios, "6.0"
  s.ios.deployment_target = "6.0"

  s.source       = { :git => "https://github.com/angelcs1990/SRouter.git", :tag => s.version.to_s }


  s.source_files  = "SRouter/*.{h,m}"

  #s.public_header_files = "SRouter/SRouter.h"


  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true


end
