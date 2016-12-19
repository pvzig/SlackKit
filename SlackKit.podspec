Pod::Spec.new do |s|
  s.name             = "SlackKit"
  s.version          = "3.2.0"
  s.summary          = "a Slack client library for OS X, iOS, and tvOS written in Swift"
  s.homepage         = "https://github.com/pvzig/SlackKit"
  s.license          = 'MIT'
  s.author           = { "Peter Zignego" => "peter@launchsoft.co" }
  s.source           = { :git => "https://github.com/pvzig/SlackKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pvzig'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true
  s.source_files = 'SlackKit/Sources/*.swift'  
  s.frameworks = 'Foundation'
  s.dependency 'Starscream'
  s.dependency 'Swifter'
end
