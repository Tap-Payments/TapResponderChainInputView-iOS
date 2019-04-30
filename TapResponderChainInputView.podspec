TapAdditionsKitDependencyVersion    = '>= 1.3.3'	unless defined? TapAdditionsKitDependencyVersion
TapNibViewDependencyVersion         = '>= 1.0.4'	unless defined? TapNibViewDependencyVersion

Pod::Spec.new do |tapResponderChainInputView|
    
    tapResponderChainInputView.platform                 = :ios
    tapResponderChainInputView.ios.deployment_target    = '8.0'
    tapResponderChainInputView.swift_versions			= ['4.0', '4.2', '5.0']
    tapResponderChainInputView.name                     = 'TapResponderChainInputView'
    tapResponderChainInputView.summary                  = 'Responder Chain Input View (with arrows to show above the keyboard).'
    tapResponderChainInputView.requires_arc             = true
    tapResponderChainInputView.version                  = '1.1.4'
    tapResponderChainInputView.license                  = { :type => 'MIT', :file => 'LICENSE' }
    tapResponderChainInputView.author                   = { 'Tap Payments' => 'hello@tap.company' }
    tapResponderChainInputView.homepage                 = 'https://github.com/Tap-Payments/TapResponderChainInputView-iOS'
    tapResponderChainInputView.source                   = { :git => 'https://github.com/Tap-Payments/TapResponderChainInputView-iOS.git', :tag => tapResponderChainInputView.version.to_s }
    tapResponderChainInputView.source_files             = 'TapResponderChainInputView/Source/*.swift'
    tapResponderChainInputView.ios.resource_bundle      = { 'TapResponderChainInputViewResources' => 'TapResponderChainInputView/Resources/*.{xcassets,xib}' }
    
    tapResponderChainInputView.dependency 'TapAdditionsKit/Foundation/Bundle',  TapAdditionsKitDependencyVersion
    tapResponderChainInputView.dependency 'TapAdditionsKit/Tap/ClassProtocol',  TapAdditionsKitDependencyVersion
    tapResponderChainInputView.dependency 'TapNibView',                         TapNibViewDependencyVersion

end
