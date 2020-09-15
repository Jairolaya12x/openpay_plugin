#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint openpay_plugin.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'openpay_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '10.3'
  s.frameworks = 'Openpay'
  s.ios.deployment_target = '10.3'

  s.swift_version = '5.0'

  s.ios.preserve_path = 'IMPORTANT.txt'

  s.preserve_paths = 'Openpay.framework'
  s.ios.preserve_paths = 
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework Openpay' }
  s.ios.vendored_frameworks = 'Frameworks/Openpay.framework'
end
