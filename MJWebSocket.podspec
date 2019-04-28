#
# Be sure to run `pod lib lint MJWebSocket.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MJWebSocket'
  s.version          = '0.1.1'
  s.summary          = 'A short description of MJWebSocket.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yangyu2010/MJWebSocket'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangyu' => 'yangyu2010@aliyun.com' }
  s.source           = { :git => 'https://github.com/yangyu2010/MJWebSocket.git', :tag => "v-#{s.version}" }

  s.ios.deployment_target = '9.0'

  s.source_files = 'MJWebSocket/Classes/**/*'

  s.dependency 'AFNetworking/Reachability', '~> 3.2.1'
  s.dependency 'SocketRocket', '~> 0.5.1'
end
