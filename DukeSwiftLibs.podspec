#
# Be sure to run `pod lib lint DukeSwiftLibs.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DukeSwiftLibs'
  s.version          = '0.1.0'
  s.summary          = '10Duke iOS client libraries written in Swift 3.0 to enable SSO and REST API functionality.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
The DukeSwiftLibs is a library of tools that provide SSO login and logout functionality
as well as connectivity to the 10Duke IdP REST API interface.
                       DESC

  s.homepage         = 'https://github.com/10Duke/DukeSwiftLibs'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Antti Tohmo' => 'antti.tohmo@10duke.com' }
  s.source           = { :git => 'https://github.com/10Duke/DukeSwiftLibs.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/10duke'

  s.ios.deployment_target = '10.0'

  s.source_files = 'DukeSwiftLibs/Classes/**/*'
  
  s.resource_bundles = {
    'DukeSwiftLibs' => [
      'DukeSwiftLibs/Assets/ui/10DukeWeb.storyboard'
    ]
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Alamofire', '~> 4.0'
  s.dependency 'EVReflection'
  s.dependency 'JWTDecode'
  s.dependency 'Locksmith'
  s.dependency 'SwiftyJSON'
end
