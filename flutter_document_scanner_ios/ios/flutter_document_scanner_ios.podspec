#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_document_scanner_ios'
  s.version          = '0.5.0'
  s.summary          = 'An iOS implementation of the flutter_document_scanner plugin.'
  s.description      = <<-DESC
  A Flutter plugin that allows the management of taking, cropping and applying filters to an image, using the camera plugin
                       DESC
  s.homepage         = 'https://github.com/criistian14/flutter_document_scanner'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Christian Betancourt' => 'criistian-14@hotmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*.{swift,h,m,mm,c,cpp}'
  s.dependency 'Flutter'
  s.static_framework = true

  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
  }
  s.swift_version = '5.0'
end
