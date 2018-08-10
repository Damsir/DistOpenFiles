Pod::Spec.new do |s|

  s.name         = "DistOpenFiles"
  s.version      = "1.0.1"
  s.summary      = "打开，预览 -> 本地，网络文件"
  s.author       = { "Damrin" => "75081647@qq.com" }
  s.homepage    = 'https://github.com/Damsir/DistOpenFiles'
  s.source      = { :git => 'https://github.com/Damsir/DistOpenFiles.git', :tag => s.version }
  s.license = "MIT"
  s.platform = :ios, "8.0"
  s.requires_arc = true
  s.source_files = "DistOpenFiles", "DistOpenFiles/**/*.{h,m}"
  # s.public_header_files = "DistPopView/*.h"
  #s.resources = 'DistDownload/Resource/*.{bundle}'
  s.framework = 'UIKit'
  s.ios.deployment_target = "8.0"
  s.dependency "AFNetworking" , '~> 3.1.0'

end

