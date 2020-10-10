# Clone Swifter and Starscream and enable BUILD_LIBRARIES_FOR_DISTRIBUTION=YES
# TODO: Upstream these changes

# Create Swifter.xcframework
# iOS
xcodebuild archive -scheme 'SwifteriOS' -configuration Release -destination 'generic/platform=iOS' -archivePath 'SwifteriOS.framework-iphoneos.xcarchive' SKIP_INSTALL=NO
xcodebuild archive -scheme 'SwifteriOS' -configuration Release -destination 'generic/platform=iOS Simulator' -archivePath 'SwifteriOS.framework-iphonesimulator.xcarchive' SKIP_INSTALL=NO
#tvOS
xcodebuild archive -scheme 'SwiftertvOS' -configuration Release -destination 'generic/platform=appletvos' -archivePath 'SwiftertvOS.framework-appletvos.xcarchive' SKIP_INSTALL=NO
xcodebuild archive -scheme 'SwiftertvOS' -configuration Release -destination 'generic/platform=appletvsimulator' -archivePath 'SwiftertvOS.framework-appletvsimulator.xcarchive' SKIP_INSTALL=NO
#macOS
xcodebuild archive -scheme 'SwifterMac' -configuration Release -destination 'generic/platform=macosx' -archivePath 'SwifterMac.framework-macosx.xcarchive' SKIP_INSTALL=NO

xcodebuild -create-xcframework \
    -framework 'SwifteriOS.framework-iphoneos.xcarchive/Products/Library/Frameworks/Swifter.framework' \
    -framework 'SwifteriOS.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/Swifter.framework' \
    -framework 'SwiftertvOS.framework-appletvos.xcarchive/Products/Library/Frameworks/Swifter.framework' \
    -framework 'SwiftertvOS.framework-appletvsimulator.xcarchive/Products/Library/Frameworks/Swifter.framework' \
    -framework 'SwifterMac.framework-macosx.xcarchive/Products/Library/Frameworks/Swifter.framework' \
    -output 'Swifter.xcframework'

# Create Starscream.xcframework
# iOS
xcodebuild archive -scheme 'Starscream' -configuration Release -destination 'generic/platform=iOS' -archivePath 'Starscream.framework-iphoneos.xcarchive' SKIP_INSTALL=NO
xcodebuild archive -scheme 'Starscream' -configuration Release -destination 'generic/platform=iOS Simulator' -archivePath 'Starscream.framework-iphonesimulator.xcarchive' SKIP_INSTALL=NO
#tvOS
xcodebuild archive -scheme 'Starscream' -configuration Release -destination 'generic/platform=appletvos' -archivePath 'Starscream.framework-appletvos.xcarchive' SKIP_INSTALL=NO
xcodebuild archive -scheme 'Starscream' -configuration Release -destination 'generic/platform=appletvsimulator' -archivePath 'Starscream.framework-appletvsimulator.xcarchive' SKIP_INSTALL=NO
#macOS
xcodebuild archive -scheme 'Starscream' -configuration Release -destination 'generic/platform=macosx' -archivePath 'Starscream.framework-macosx.xcarchive' SKIP_INSTALL=NO

xcodebuild -create-xcframework \
    -framework 'Starscream.framework-iphoneos.xcarchive/Products/Library/Frameworks/Starscream.framework' \
    -framework 'Starscream.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/Starscream.framework' \
    -framework 'Starscream.framework-appletvos.xcarchive/Products/Library/Frameworks/Starscream.framework' \
    -framework 'Starscream.framework-appletvsimulator.xcarchive/Products/Library/Frameworks/Starscream.framework' \
    -framework 'Starscream.framework-macosx.xcarchive/Products/Library/Frameworks/Starscream.framework' \
    -output 'Starscream.xcframework'