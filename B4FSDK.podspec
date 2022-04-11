Pod::Spec.new do |spec|
  spec.name = 'B4FSDK'
  spec.version      = '1.0.0'
  spec.summary      = "SDK to interect with B4F' smart tags."
  spec.homepage     = 'https://www.brand4fans.com/'
  spec.license      = 'MIT'
  spec.author       = { 'Brand4Fans' => 'hello@brand4fans.com' }
  spec.source       = { :git => 'https://github.com/Brand4Fans/B4FSDK-iOS.git', :tag => "#{spec.version}" }

  spec.ios.deployment_target = '11.0'

  spec.swift_versions = ['5.1', '5.2', '5.3']

  spec.source_files = 'Sources', 'B4FSDK/Sources/**/*.{h,m,swift}'

  spec.dependency 'AlamofireObjectMapper'

end
