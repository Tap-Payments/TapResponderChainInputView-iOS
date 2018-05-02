//
//  UIResponder+Additions.swift
//  TapResponderChainInputView
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGGeometry.CGPoint
import struct CoreGraphics.CGGeometry.CGRect
import struct CoreGraphics.CGGeometry.CGSize
import class UIKit.UIResponder.UIResponder
import class UIKit.UIScreen.UIScreen
import class UIKit.UITextField.UITextField

private var previousFieldHandle: UInt8 = 0
private var nextFieldHandle: UInt8 = 0

public extension UIResponder {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Previous field in navigation chain.
    @IBOutlet public weak var previousField: UIResponder? {
        
        get {
            
            return objc_getAssociatedObject(self, &previousFieldHandle) as? UIResponder
        }
        set {
            
            let changed = (newValue != nil) || ((self.previousField != nil) && (newValue == nil))
            
            objc_setAssociatedObject(self, &previousFieldHandle, newValue, .OBJC_ASSOCIATION_ASSIGN)
            
            if changed {
                
                self.initToolbar()
            }
        }
    }
    
    /// Next field in navigation chain.
    @IBOutlet public weak var nextField: UIResponder? {
        
        get {
            
            return objc_getAssociatedObject(self, &nextFieldHandle) as? UIResponder
        }
        set {
            
            let changed = (newValue != nil) || ((self.nextField != nil) && (newValue == nil))
            
            objc_setAssociatedObject(self, &nextFieldHandle, newValue, .OBJC_ASSOCIATION_ASSIGN)
            
            if changed {
                
                self.initToolbar()
            }
        }
    }
    
    // MARK: Methods
    
    public func updateToolbarButtonsState() {
        
        guard let toolbar = self.inputAccessoryView as? TapResponderChainInputView else { return }
        
        toolbar.isPreviousButtonEnabled = self.previousField?.canBecomeFirstResponder ?? false
        toolbar.isNextButtonEnabled = self.nextField?.canBecomeFirstResponder ?? false
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func initToolbar() {
        
        guard self.inputAccessoryView == nil && self.responds(to: #selector(setter: UITextField.inputAccessoryView)) else {
            
            self.updateToolbarButtonsState()
            return
        }
        
        let toolbarFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.width, height: TapResponderChainInputView.defaultHeight))
        
        let toolbar = TapResponderChainInputView(frame: toolbarFrame)
        
        toolbar.delegate = self
        toolbar.isPreviousButtonEnabled = self.previousField?.canBecomeFirstResponder ?? false
        toolbar.isNextButtonEnabled = self.nextField?.canBecomeFirstResponder ?? false
        
        self.perform(#selector(setter: UITextField.inputAccessoryView), with: toolbar)
    }
}

// MARK: - TapResponderChainInputViewDelegate
extension UIResponder: TapResponderChainInputViewDelegate {
    
    internal func responderChainInputViewPreviousButtonClicked(_ responderChainInputView: TapResponderChainInputView) {
        
        DispatchQueue.main.async {
            
            self.previousField?.becomeFirstResponder()
        }
    }
    
    internal func responderChainInputViewNextButtonClicked(_ responderChainInputView: TapResponderChainInputView) {
        
        DispatchQueue.main.async {
            
            self.nextField?.becomeFirstResponder()
        }
    }
}
