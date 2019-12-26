#
# Be sure to run `pod lib lint CHWImageEditorView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CHWImageEditorView'
  s.version          = '0.2.0'
  s.summary          = 'A short description of CHWImageEditorView.'



# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Image Cropping Library for ios
CHWImageEditorView - Image Cropping and Rotate Library for ios

                       DESC

  s.homepage         = 'https://github.com/JackyHe2882/CHWImageEditorView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'JackyHeWei' => 'Cherish_wei_he@163.com' }
  s.source           = { :git => 'https://github.com/JackyHe2882/CHWImageEditorView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CHWImageEditorView/Classes/**/*'

  s.resource_bundles = {
      'CHWImageEditorView' => ['CHWImageEditorView/Assets/*']
  }
  
  # s.resource_bundles = {
  #   'CHWImageEditorView' => ['CHWImageEditorView/Assets/*.{png,storyboard,xib}']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
