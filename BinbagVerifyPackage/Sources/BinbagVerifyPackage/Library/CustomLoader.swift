//
//  CustomLoader.swift
//  SchoolApp
//
//  Created by iroid on 17/08/21.
//

import Foundation
import UIKit
import CoreGraphics
import QuartzCore

class CustomLoader: UIView
{
    //MARK:- NOT ACCESSABLE OUT SIDE

    fileprivate var duration : CFTimeInterval! = 1
    fileprivate var isAnimating :Bool = false
    fileprivate var backgroundView : UIView!

    //MARK:- ACCESS INSTANCE ONLY AND CHANGE ACCORDING TO YOUR NEEDS   *******
    let colors : [UIColor] = [.red,  .blue,  .orange, .purple]
    var defaultColor : UIColor = UIColor.red
    var isUsrInteractionEnable : Bool = false
    var defaultbgColor: UIColor = UIColor.white
    var loaderSize : CGFloat = 40.0
    /// **************** ******************  ////////// **************

    //MARK:- MAKE SHARED INSTANCE
    private static var Instance : CustomLoader!
    static let sharedInstance : CustomLoader = {

        if Instance == nil
        {
            Instance = CustomLoader()
        }

        return Instance
    }()

    //MARK:- DESTROY TO SHARED INSTANCE
    @objc fileprivate func destroyShardInstance()
    {
        CustomLoader.Instance = nil
    }

    //MARK:- SET YOUR LOADER INITIALIZER FRAME ELSE DEFAULT IS CENTER
    func startAnimation()
    {
        let win = UIApplication.shared.keyWindow

        backgroundView = UIView()
        backgroundView.frame = (UIApplication.shared.keyWindow?.frame)!
        backgroundView.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        win?.addSubview(backgroundView)

        self.frame = CGRect.init(x: ((UIScreen.main.bounds.width) - 170)/2, y: ((UIScreen.main.bounds.height) - 230)/2 , width: 170, height: 230)
        
        self.addCenterImage()
        self.isHidden = false
        self.backgroundView.addSubview(self)

        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        backgroundView.accessibilityIdentifier = "CustomLoader"

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSExtensionHostDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CustomLoader.ResumeLoader), name: NSNotification.Name.NSExtensionHostDidBecomeActive, object: nil)

        self.layoutSubviews()
    }

    //MARK:- AVOID STUCKING LOADER WHEN CAME BACK FROM BACKGROUND
    @objc fileprivate func ResumeLoader()
    {
        if isAnimating
        {
            self.stopAnimation()
            self.AnimationStart()
        }
    }

    override func layoutSubviews()
    {
        super.layoutSubviews()

        self.backgroundColor = defaultbgColor
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = isUsrInteractionEnable
        self.AnimationStart()
    }

    @objc fileprivate func addCenterImage()
    {
        /// add image in center
        
        let centerImageView = UIImageView()
        centerImageView.frame = CGRect(x: (self.bounds.width - 80) / 2 , y: 20, width: 80, height: 120)
        centerImageView.image = UIImage(named: "logo")
        centerImageView.contentMode = .scaleAspectFit
        centerImageView.layer.cornerRadius = 10
        centerImageView.clipsToBounds = true
        self.addSubview(centerImageView)
        
        let label = UILabel()
        label.frame = CGRect(x: (self.bounds.width - 130) / 2 , y: 140, width: 130, height: 30)
        label.text = "Please Wait..."
        label.font = UIFont(name: "SFProText-Regular", size: 12)
        label.textAlignment = .center
        self.addSubview(label)
        
//        let centerImage = UIImage(named: "logo")
//        let imageSize = loaderSize/1.5
//
//        let centerImgView = UIImageView(image: centerImage)
//        centerImgView.frame = CGRect(
//            x: (self.bounds.width - imageSize) / 2 ,
//            y: (self.bounds.height - imageSize) / 2,
//            width: imageSize,
//            height: imageSize
//        )
//
//        centerImgView.contentMode = .scaleAspectFit
//        centerImgView.layer.cornerRadius = imageSize/2
//        centerImgView.clipsToBounds = true
//        self.addSubview(centerImgView)

    }


    //MARK:- CALL IT TO START THE LOADER , AFTER INITIALIZE THE LOADER
    @objc fileprivate func AnimationStart()
    {
        if isAnimating
        {
            return
        }

        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect(x: (self.bounds.width - 80) / 2 , y: 150, width: 80, height: 80)
        
        let size = CGSize.init(width: loaderSize , height: loaderSize)

        let dotNum: CGFloat = 10
        let diameter: CGFloat = size.width / 5.5   //10

        let dot = CALayer()
        let frame = CGRect(
                    x: (replicatorLayer.bounds.width - diameter) / 2 + diameter * 2,
                    y: (replicatorLayer.bounds.height - diameter) / 2,
                    width: diameter/1.3,
                    height: diameter/1.3
                )

        dot.backgroundColor = colors[0].cgColor
        dot.cornerRadius = frame.width / 2
        dot.frame = frame

        replicatorLayer.instanceCount = Int(dotNum)
        replicatorLayer.instanceDelay = 0.1

        let angle = (2.0 * M_PI) / Double(replicatorLayer.instanceCount)

        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)

        layer.addSublayer(replicatorLayer)
        replicatorLayer.addSublayer(dot)

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 0.4
        scaleAnimation.duration = 0.5
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        dot.add(scaleAnimation, forKey: "scaleAnimation")

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = -2.0 * Double.pi
        rotationAnimation.duration = 6.0
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        replicatorLayer.add(rotationAnimation, forKey: "rotationAnimation")

        if colors.count > 1 {

            var cgColors : [CGColor] = []
            for color in colors {
                cgColors.append(color.cgColor)
            }

            let colorAnimation = CAKeyframeAnimation(keyPath: "backgroundColor")
            colorAnimation.values = cgColors
            colorAnimation.duration = 2
            colorAnimation.repeatCount = .infinity
            colorAnimation.autoreverses = true
            dot.add(colorAnimation, forKey: "colorAnimation")

        }

        self.isAnimating = true
        self.isHidden = false

    }


    //MARK:- CALL IT TO STOP THE LOADER
    func stopAnimation()
    {
        if !isAnimating
        {
            return
        }
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
        let winSubviews = UIApplication.shared.keyWindow?.subviews
        if (winSubviews?.count)! > 0
        {
            for viw in winSubviews!
            {
                if viw.accessibilityIdentifier == "CustomLoader"
                {
                    viw.removeFromSuperview()
                    //  break
                }
            }
        }

        layer.sublayers = nil

        isAnimating = false
        self.isHidden = true

        self.destroyShardInstance()
    }
    //MARK:- GETTING RANDOM COLOR , AND MANAGE YOUR OWN COLORS
    @objc fileprivate func randomColor()->UIColor
    {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    override func draw(_ rect: CGRect)
    {
    }
}
