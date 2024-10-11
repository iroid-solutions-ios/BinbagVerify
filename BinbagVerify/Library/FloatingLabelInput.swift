//
//  FloatingLabelInput.swift
//  Medics2you
//
//  Created by Techwin iMac-2 on 04/05/20.
//  Copyright © 2020 Techwin iMac-2. All rights reserved.
//

import UIKit

class FloatingLabelInput: UITextField {
    var floatingLabel: UILabel!
    var floatingLabelHeight: CGFloat = 11
    var button = UIButton(type: .custom)
    var imageView = UIImageView(frame: CGRect.zero)
    
    @IBInspectable
    var _placeholder: String?
    
    @IBInspectable
    var floatingLabelColor: UIColor = UIColor.black {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var activeBorderColor: UIColor = UIColor.blue
    
    @IBInspectable
    var floatingLabelBackground: UIColor = UIColor.white.withAlphaComponent(1) {
        didSet {
            self.floatingLabel.backgroundColor = #colorLiteral(red: 0.992049396, green: 0.9922187924, blue: 0.9920386672, alpha: 1)
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var floatingLabelFont: UIFont = UIFont(name: "Poppins-Medium", size: 12)!{
        didSet {
            self.floatingLabel.font = self.floatingLabelFont
            self.font = self.floatingLabelFont
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var _backgroundColor: UIColor = UIColor.white {
        didSet {
            self.layer.backgroundColor = self._backgroundColor.cgColor
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder
        placeholder = " " + (self._placeholder ?? "") + " "
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
    }
    
    // Add a floating label to the view on becoming first responder
    @objc func addFloatingLabel() {
        self.floatingLabel.textColor = floatingLabelColor
//        if(IS_IPAD){
//            self.floatingLabel.font = UIFont(name: "MarkPro", size: 14.0)!
//        }
//        else{
            self.floatingLabel.font = floatingLabelFont
        //}
        self.floatingLabel.text = " " + (self._placeholder ?? "") + " "//self._placeholder
        self.floatingLabel.layer.backgroundColor = floatingLabelBackground.cgColor
        self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.floatingLabel.clipsToBounds = true
        self.floatingLabel.frame = CGRect(x: 0, y: 0, width: floatingLabel.frame.width+4, height: floatingLabel.frame.height+2)
        self.floatingLabel.textAlignment = .center
        self.addSubview(self.floatingLabel)
        
        
        self.layer.borderColor = self.activeBorderColor.cgColor
        
        self.floatingLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        self.placeholder = ""
        floatingLabel.superview?.bringSubviewToFront(floatingLabel)
        floatingLabel.superview?.bringSubviewToFront(floatingLabel)
        //        self.bringSubviewToFront(subviews.last!)
        self.setNeedsDisplay()
    }
    
    @objc func removeFloatingLabel() {
        if self.text == "" {
            UIView.animate(withDuration: 0.13) {
                self.subviews.forEach{ $0.removeFromSuperview() }
                self.setNeedsDisplay()
            }
            self.placeholder = "  " + (self._placeholder ?? "") + "  "//self._placeholder
        }
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func addViewPasswordButton() {
        self.button.setImage(UIImage(named: "ic_reveal"), for: .normal)
        self.button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.button.frame = CGRect(x: 0, y: 16, width: 22, height: 16)
        self.button.clipsToBounds = true
        self.rightView = self.button
        self.rightViewMode = .always
        self.button.addTarget(self, action: #selector(self.enablePasswordVisibilityToggle), for: .touchUpInside)
    }
    
    func addImage(image: UIImage){
        self.imageView.image = image
        self.imageView.frame = CGRect(x: 20, y: 0, width: 20, height: 20)
        self.imageView.translatesAutoresizingMaskIntoConstraints = true
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        DispatchQueue.main.async {
            self.leftView = self.imageView
            self.leftViewMode = .always
        }
        
    }
    
    @objc func enablePasswordVisibilityToggle() {
        isSecureTextEntry.toggle()
        if isSecureTextEntry {
            self.button.setImage(UIImage(named: "ic_show"), for: .normal)
        }else{
            self.button.setImage(UIImage(named: "ic_hide"), for: .normal)
        }
    }

}
