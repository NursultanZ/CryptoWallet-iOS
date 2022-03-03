# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FYP' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FYP
  pod 'CryptoSwift', '~> 1.0.0'
  pod 'Base58Swift'
  pod 'secp256k1.swift'
  pod 'ripemd160'
  pod 'BigInt'

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    if config.name == 'Release'
      config.build_settings['SWIFT_COMPILATION_MODE'] = 'wholemodule'
    end
  end
end
