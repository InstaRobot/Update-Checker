Pod::Spec.new do |s|
  s.name                  = 'UpdateChecker'
  s.version               = '1.0'
  s.swift_version         = '5.1', '5.2', '5.3', '5.4', '5.5'
  s.summary               = 'Simple app version checker from AppStore'
  s.homepage              = 'https://github.com/InstaRobot/Update-Checker'
  s.license               = 'MIT'
  s.author                = { 'Vitaliy Podolskiy' => 'instarobot.net@gmail.com' }
  s.description           = <<-DESC
                            Simple app version checker from AppStore.
                            DESC
  s.source                = { :git => 'https://github.com/InstaRobot/Update-Checker.git', :tag => s.version.to_s }
  s.platform              = :ios
  s.ios.deployment_target = '12.0'
  s.requires_arc          = true
  s.source_files          = 'UpdateChecker/Source/**/*'
  s.frameworks            = 'Foundation'#, 'CommonCrypto'
  s.module_name           = 'UpdateChecker'
  s.documentation_url     = 'https://github.com/InstaRobot/Update-Checker'
  #s.dependency 'CryptoSwift', '1.3.8'

  s.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER': 'studio.devlab.UpdateChecker' }
end