#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint gallery_saver.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'gallery_saver'
  s.version          = '2.4.1'
  s.summary          = 'Saves images and videos to gallery and photos.'
  s.description      = <<-DESC
Saves images and videos to gallery and photos.
                       DESC
  s.homepage         = 'https://github.com/CarnegieTechnologies/gallery_saver'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Carnegie Technologies d.o.o' => 'devoffice@carnegietechnologies.com' }
  s.source           = { :path => '.' }
  s.source_files = 'gallery_saver/Sources/gallery_saver/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  s.resource_bundles = {'gallery_saver_privacy' => ['gallery_saver/Sources/gallery_saver/PrivacyInfo.xcprivacy']}
end
