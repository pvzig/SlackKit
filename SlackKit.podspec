Pod::Spec.new do |s|
  s.name                    = "SlackKit"
  s.version                 = "4.5.1"
  s.summary                 = "Write Slack apps in Swift"
  s.homepage                = "https://github.com/pvzig/SlackKit"
  s.license                 = "MIT"
  s.author                  = { "Peter Zignego" => "peter@launchsoft.co" }
  s.source                  = { :git => "https://github.com/pvzig/SlackKit.git", :tag => s.version.to_s }
  s.social_media_url        = "https://twitter.com/pvzig"
  s.platforms               = { :ios => '10.0', :osx => '10.11', :tvos => '10.0' }
  s.swift_version           = '5.1.3'
  s.cocoapods_version       = '>= 1.4.0'
  s.default_subspec         = "SlackKit"

  s.subspec "SlackKit" do |ss|
    ss.source_files = "SlackKit/Sources/"
    ss.dependency "SlackKit/SKCore"
    ss.dependency "SlackKit/SKClient"
    ss.dependency "SlackKit/SKWebAPI"
    ss.dependency "SlackKit/SKRTMAPI"
    ss.dependency "SlackKit/SKServer"
  end

  s.subspec "SKClient" do |ss|
    ss.source_files = "SKClient/Sources/"
    ss.dependency "SlackKit/SKCore"
  end

  s.subspec "SKCore" do |ss|
    ss.source_files = "SKCore/Sources/"
    ss.framework = "Foundation"
  end

  s.subspec "SKRTMAPI" do |ss|
    ss.source_files = "SKRTMAPI/Sources/**/*.swift"
    ss.exclude_files = "SKRTMAPI/Sources/Conformers/VaporEngineRTM.swift"
    ss.dependency "SlackKit/SKCore"
    ss.dependency "SlackKit/SKWebAPI"
    ss.dependency "Starscream", "3.1.0"
  end

  s.subspec "SKServer" do |ss|
    ss.source_files = "SKServer/Sources/**/*.swift"
    ss.dependency "SlackKit/SKCore"
    ss.dependency "SlackKit/SKWebAPI"
    ss.dependency "Swifter", "1.5.0"
  end

  s.subspec "SKWebAPI" do |ss|
    ss.source_files = "SKWebAPI/Sources/"
    ss.dependency "SlackKit/SKCore"
  end
end