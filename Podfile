platform :ios, '16.0'

target 'Stamps' do
    use_frameworks!
    pod 'Alamofire'
end

# make sure pods are at the same deployment target
post_install do |pi|
  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end
