//
//  UIResponder+Additions.swift
//  TapResponderChainInputView
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGGeometry.CGPoint
import struct   CoreGraphics.CGGeometry.CGRect
import struct   CoreGraphics.CGGeometry.CGSize
import struct   TapAdditionsKit.TypeAlias
import class    UIKit.UIResponder.UIResponder
import class    UIKit.UIScreen.UIScreen
import class    UIKit.UITextField.UITextField

private var previousFieldHandle:        UInt8 = 0
private var nextFieldHandle:            UInt8 = 0

private var manualPreviousButtonHandle: UInt8 = 0
private var manualNextButtonHandle:     UInt8 = 0

public extension UIResponder {
    
    // MARK: - Public -
    
    public typealias PreparationsClosure = (@escaping TypeAlias.ArgumentlessClosure) -> Void
    
    // MARK: Properties
    
    /// Previous field in navigation chain.
    @IBOutlet public weak var previousField: UIResponder? {
        
        get {
            
            return objc_getAssociatedObject(self, &previousFieldHandle) as? UIResponder
            
        } set {
            
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
    
    public var manualToolbarPreviousButtonHandler: TypeAlias.ArgumentlessClosure? {
        
        get {
            
            return objc_getAssociatedObject(self, &manualPreviousButtonHandle) as? TypeAlias.ArgumentlessClosure
        }
        set {
            
            objc_setAssociatedObject(self, &manualPreviousButtonHandle, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var manualToolbarNextButtonHandler: TypeAlias.ArgumentlessClosure? {
        
        get {
            
            return objc_getAssociatedObject(self, &manualNextButtonHandle) as? TypeAlias.ArgumentlessClosure
        }
        set {
            
            objc_setAssociatedObject(self, &manualNextButtonHandle, newValue, .OBJC_ASSOCIATION_RETAIN)
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
        
        if let nonnullPreviousClickHandler = self.manualToolbarPreviousButtonHandler {
            
            nonnullPreviousClickHandler()
        }
        else {
            
            self.previousField?.becomeFirstResponder()
        }
    }
    
    internal func responderChainInputViewNextButtonClicked(_ responderChainInputView: TapResponderChainInputView) {
        
        if let nonnullNextClickHandler = self.manualToolbarNextButtonHandler {
            
            nonnullNextClickHandler()
        }
        else {
            
            self.nextField?.becomeFirstResponder()
        }
    }
}
