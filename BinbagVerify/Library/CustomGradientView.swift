//
//  CustomGradientView.swift
//  Wenue
//
//  Created by iroid on 02/02/22.
//

import Foundation
import UIKit


@IBDesignable
class CustomGradientView: UIView {

    @IBInspectable var firstColor:UIColor = UIColor(red: 0.678, green: 0.325, blue: 0.537, alpha: 1)
    @IBInspectable var secondColor:UIColor = UIColor(red: 0.235, green: 0.063, blue: 0.325, alpha: 1)
    @IBInspectable var startPoint:CGPoint = CGPoint(x: 0, y: 0) //CGPoint(x: 0.25, y: 0.5)
    @IBInspectable var endPoint:CGPoint = CGPoint(x: 0, y: 1) //CGPoint(x: 0.75, y: 0.5)
    
    override func layoutSubviews() {
        /*
        let layer = CAGradientLayer()
        layer.colors = [ firstColor.cgColor, secondColor.cgColor ]
        layer.locations  = [0, 1]
        layer.startPoint = startPoint
        layer.endPoint   = endPoint
        layer.bounds = self.bounds
        layer.position = self.center
        //layer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.layer.insertSublayer(layer, at: 0)
        */
    }

}

@IBDesignable class CustomGradientView1: UIView {

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        self.gradientLayer(gradientView: self)
    }
    
    func gradientLayer(gradientView:UIView) {

        let layer0 = CAGradientLayer()
        layer0.colors = [
                            UIColor(red: 0.678, green: 0.325, blue: 0.537, alpha: 1).cgColor,
                            UIColor(red: 0.235, green: 0.063, blue: 0.325, alpha: 1).cgColor
                        ]

        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1.29, b: 1.16, c: -1.16, d: 0.27, tx: 0.42, ty: -0.22))
        layer0.bounds = gradientView.bounds.insetBy(dx: -0.5*gradientView.bounds.size.width, dy: -0.5*gradientView.bounds.size.height)
        layer0.position = gradientView.center
        //layer0.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        gradientView.layer.addSublayer(layer0)
    }
}
