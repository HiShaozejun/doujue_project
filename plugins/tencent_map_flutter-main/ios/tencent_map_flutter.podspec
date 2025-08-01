#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tencent_map_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tencent_map_flutter'
  s.version          = '0.0.1'
  s.summary          = 'This is tencent map plugin'
  s.description      = <<-DESC
This is tencent map plugin
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.ios.vendored_frameworks = 'Frameworks/TencentLBS.framework'
  s.vendored_frameworks = 'TencentLBS.framework'
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.dependency 'Tencent-MapSDK', '~> 5.1.0'
  s.static_framework = true
end
