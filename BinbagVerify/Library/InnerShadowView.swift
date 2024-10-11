//
//  InnerShadowView.swift
//  SBM_App
//
//  Created by iRoid Dev on 17/01/24.
//

import Foundation
import UIKit


@IBDesignable
class InnerShadowView: UIView {
    
    // MARK: - Border
    
//    @IBInspectable public var borderColor: UIColor = UIColor.clear {
//        didSet {
//            layer.borderColor = borderColor.cgColor
//        }
//    }
//    
//    @IBInspectable public var borderWidth: CGFloat = 0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
//    
//    @IBInspectable public var cornerRadius: CGFloat = 0 {
//        didSet {
//            layer.cornerRadius = cornerRadius
//            updateInnerShadow()
//        }
//    }
//    
//    //MARK: Inner shadow
//    @IBInspectable var innerShadowColor: UIColor = UIColor.black {
//        didSet {
//            updateInnerShadow()
//        }
//    }
//    
//    @IBInspectable var innerShadowOpacity: Float = 0.16 {
//        didSet {
//            updateInnerShadow()
//        }
//    }
//    
//    @IBInspectable var innerShadowRadius: CGFloat = 6 {
//        didSet {
//            updateInnerShadow()
//        }
//    }
//    
//    private func updateInnerShadow() {
//        // Remove existing innerShadowLayer
//        layer.sublayers?.filter { $0.name == "innerShadowLayer" }.forEach { $0.removeFromSuperlayer() }
//        
//        // Add new innerShadowLayer
//        let innerShadowLayer = CALayer()
//        innerShadowLayer.name = "innerShadowLayer"
//        innerShadowLayer.backgroundColor = innerShadowColor.cgColor
//        
//        let size = bounds.size
//        clipsToBounds = true
//        innerShadowLayer.bounds = CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width * 2, height: size.height)
//        
//        innerShadowLayer.position = CGPoint(x: size.width / 2, y: -size.height / 2)
//        
//        innerShadowLayer.shadowColor = innerShadowColor.cgColor
//        innerShadowLayer.shadowOffset = CGSize(width: 0, height: 3)
//        innerShadowLayer.shadowOpacity = innerShadowOpacity
//        innerShadowLayer.shadowRadius = innerShadowRadius
//        
//        layer.addSublayer(innerShadowLayer)
//    }
}
