#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_union_apple_pay.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_union_apple_pay'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter project for Union Apple Pay.'
  s.description      = <<-DESC
A Flutter project for Union Apple Pay.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'luoshimei' => '0x005168@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.frameworks = 'CFNetwork', 'SystemConfiguration', 'PassKit'
  s.libraries = 'z','c++'
  s.vendored_libraries = 'Classes/SDK/libUPAPayPlugin.a'
  s.static_framework = true
end
