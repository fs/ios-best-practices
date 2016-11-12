# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

abstract_target 'Abstract' do

    pod 'ObjectMapper'

	target 'MessagesExtension' do

	end

	target 'VoteApp' do

	end
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
