# platform :ios, '8.0'
use_frameworks!

target 'Journey' do
    pod 'R.swift'
    pod 'LTSwiftDate'
    pod 'LTInfiniteScrollViewSwift'
    pod 'RealmSwift', '0.98.1'
    pod 'AsyncSwift'
    pod 'GLPubSub'
    pod 'Fabric'
    pod 'Crashlytics'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        end
    end
end

