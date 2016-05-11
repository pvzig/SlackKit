Pod::Spec.new do |s|
  s.name             = "SlackKit"
  s.version          = "1.0.2"
  s.summary          = "a Slack client library for iOS and OS X written in Swift"
  s.homepage         = "https://github.com/pvzig/SlackKit"
  s.license          = 'MIT'
  s.author           = { "Peter Zignego" => "peter@launchsoft.co" }
  s.source           = { :git => "https://github.com/pvzig/SlackKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pvzig'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true
  s.source_files = 'SlackKit/Sources/*.swift'  
  s.frameworks = 'Foundation'
  s.dependency 'Starscream', '~> 1.1.2'
end

