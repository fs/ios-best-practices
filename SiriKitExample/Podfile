# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

abstract_target 'Abstract' do
    pod 'RealmSwift', '=1.1.0'

	target 'SiriKitExample' do
	  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
	  use_frameworks!

	  # Pods for SiriKitExample

	end

	target 'SiriKitExampleSiriIntent' do
	  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
	  use_frameworks!

	  # Pods for SiriKitExampleSiriIntent

	end

	target 'SiriKitExampleSiriIntentUI' do
	  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
	  use_frameworks!

	  # Pods for SiriKitExampleSiriIntentUI

	end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
