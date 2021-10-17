# Uncomment the next line to define a global platform for your project
platform :ios, '14.5'
use_frameworks!
project 'perdux_sample.xcodeproj'

def pods
  pod 'Swinject', '2.7.1'
end

target 'perdux_sample' do
  pods
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

