
Pod::Spec.new do |s|
  s.name         = "RNNaverLogin"
  s.version      = "1.0.0"
  s.summary      = "RNNaverLogin"
  s.description  = <<-DESC
                  RNNaverLogin
                   DESC
  s.homepage     = "-"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/pedaling/react-native-naver-login.git", :tag => "master" }
  s.source_files  = "{ios/,ios/NaverAuth/thirdPartyModule/}*.{h,m}"
  s.requires_arc = true

  s.vendored_library = "ios/NaverAuth/thirdPartyModule/libNaverLogin.a"
  s.resources = 'ios/NaverAuth/Resource/NaverAuth.bundle'
  s.dependency "React"
  #s.dependency "others"

end
