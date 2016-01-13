#
# Be sure to run `pod lib lint RADInfoBannerView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RADInfoBannerView"
  s.version          = "1.0.2"
  s.summary          = "Simple and Customizable Dropdown banner below Navigation Bar"
  s.homepage         = "https://github.com/rad182/RADInfoBannerView"
  s.license          = 'MIT'
  s.author           = { "Royce Albert Dy" => "rady182@me.com" }
  s.source           = { :git => "https://github.com/rad182/RADInfoBannerView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/rad182'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/*.swift'
  s.frameworks = 'UIKit'
end
