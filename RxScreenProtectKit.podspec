Pod::Spec.new do |s|
    s.name             = 'RxScreenProtectKit'
    s.version          = '0.2.6'
    s.summary          = 'Protect the screen from recording'

    s.homepage         = 'https://github.com/AkkeyLab/RxScreenProtectKit'
    s.license          = 'MIT'
    s.author           = 'AkkeyLab'
    s.source           = { :git => 'https://github.com/AkkeyLab/RxScreenProtectKit.git', :tag => "#{s.version}" }
    s.social_media_url = 'https://twitter.com/AkkeyLab'

    s.platform         = :ios, "11.0"
    s.swift_version    = "5.0"

    s.module_name      = "RxScreenProtectKit"

    s.dependency 'RxSwift', '~> 5.0'
    s.dependency 'RxCocoa', '~> 5.0'

    s.source_files     = 'Source/**/*'
end
