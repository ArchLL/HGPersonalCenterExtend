#
# Be sure to run `pod lib lint HGPersonalCenterExtend.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HGPersonalCenterExtend'
  s.version          = '1.2.7'
  s.license          = 'MIT'
  s.summary          = 'Resolve scrollView nested sliding conflicts.'
  s.description      = %{
    Resolve scrollView nested sliding conflicts.
    HGPersonalCenterExtend supports iOS.
  }                       
  s.homepage         = 'https://github.com/ArchLL/HGPersonalCenterExtend'
  s.author           = { 'Arch' => 'mint_bin@163.com' }
  s.source           = { :git => 'https://github.com/ArchLL/HGPersonalCenterExtend.git', :tag => s.version.to_s }
  s.source_files = 'HGPersonalCenterExtend/*.{h,m}'
  s.ios.frameworks = 'Foundation', 'UIKit'
  s.ios.deployment_target = '8.0'
  s.dependency 'Masonry', '~> 1.1.0'
  s.dependency 'HGCategoryView', '~> 1.1.2'
  s.requires_arc = true
end
