# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Bakery' do
  # Comment the next line if you don't want to use dynamic frameworks
  #use_frameworks!

  # Pods for Bakery
  
  # General
  pod 'KeychainAccess'
  pod 'Kingfisher', '~> 5.0'
  pod 'R.swift'
  pod 'RxSwift'
  
  # UI
  pod 'FTIndicator', :modular_headers => true
  
  # Network
  pod 'Moya'
  pod 'Moya/RxSwift'

  # DI
  pod 'Swinject'
  
  post_install do |pi|
      pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
        end
      end
  end
  
end
