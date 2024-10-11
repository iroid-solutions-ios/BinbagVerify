//
//  DesignClass.swift
//  cv-shots-recruitment
//
//  Created by iMac on 31/05/22.
//

import Foundation
import UIKit

@IBDesignable
open class dateSportButton: UIButton {
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.gradientLayer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor? {
        didSet {
            self.layer.borderColor = self.borderColor?.cgColor
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    private var gradientLayer: CAGradientLayer!

    @IBInspectable var startColor: UIColor = .clear {
        didSet {
            updateGradientColors()
        }
    }
    
    @IBInspectable var endColor: UIColor = .clear {
        didSet {
            updateGradientColors()
        }
    }
    
    @IBInspectable var horizontalGradient: Bool = true {
        didSet {
            setupGradientLayer()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }
    
    private func setupGradientLayer() {
        gradientLayer = CAGradientLayer()
        if (horizontalGradient) {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.cornerRadius = self.layer.cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
        

    }
    
    private func updateGradientColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}


@IBDesignable
open class dateSportImageView : UIImageView {
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable 
    public var borderColor : UIColor? {
        didSet {
            self.layer.borderColor = self.borderColor?.cgColor
        }
    }
    
    @IBInspectable
    public var borderWidth : CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var shadowColor: UIColor?{
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get{
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var shadowOpacity: Float{
        set {
            layer.shadowOpacity = newValue
        }
        get{
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize{
        set {
            layer.shadowOffset = newValue
        }
        get{
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat{
        set {
            layer.shadowRadius = newValue
        }
        get{
            return layer.shadowRadius
        }
    }
    
}

@IBDesignable
open class dateSportView : UIView {
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.clipsToBounds = cornerRadius == self.frame.size.width/2
        }
    }
    
    @IBInspectable
    public var borderColor : UIColor? {
        didSet {
            self.layer.borderColor = self.borderColor?.cgColor
        }
    }
    
    @IBInspectable
    public var borderWidth : CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var shadowColor: UIColor?{
         set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get{
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var shadowOpacity: Float{
        set {
            layer.shadowOpacity = newValue
        }
        get{
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize{
        set {
            layer.shadowOffset = newValue
        }
        get{
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat{
        set {
            layer.shadowRadius = newValue
        }
        get{
            return layer.shadowRadius
        }
    }
    
 
}

@IBDesignable
open class dateSportLabel : UILabel {
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.clipsToBounds = cornerRadius == self.frame.size.width/2
        }
    }
    
    @IBInspectable
    public var borderColor : UIColor? {
        didSet {
            self.layer.borderColor = self.borderColor?.cgColor
        }
    }
    
    @IBInspectable
    public var borderWidth : CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
}
}


@IBDesignable
open class dateSportTextField: UITextField {
    
    @IBInspectable
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable
    public var borderColor : UIColor? {
        didSet {
            self.layer.borderColor = self.borderColor?.cgColor
        }
    }
    
    @IBInspectable
    public var borderWidth : CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
  
       @IBInspectable var placeHolderColor: UIColor? {
            get {
                return self.placeHolderColor
            }
            set {
                self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
            }
        }
    
    var padding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

        @IBInspectable var left: CGFloat = 0 {
            didSet {
                adjustPadding()
            }
        }

        @IBInspectable var right: CGFloat = 0 {
            didSet {
                adjustPadding()
            }
        }

        @IBInspectable var top: CGFloat = 0 {
            didSet {
                adjustPadding()
            }
        }

        @IBInspectable var bottom: CGFloat = 0 {
            didSet {
                adjustPadding()
            }
        }

        func adjustPadding() {
             padding = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)

        }

    open override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
        }

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
        }

    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
        }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
             return bounds.inset(by: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
        }
}

@IBDesignable
open class CustomDashedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    
    var dashBorder: CAShapeLayer?
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}

@IBDesignable class GradientView: UIView {
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
}


@IBDesignable
class GradientView2: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map {$0.cgColor}
        if (isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
    
}

@IBDesignable
class DashedLineView : UIView {
    @IBInspectable var perDashLength: CGFloat = 2.0
    @IBInspectable var spaceBetweenDash: CGFloat = 2.0
    @IBInspectable var dashColor: UIColor = UIColor.lightGray
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let  path = UIBezierPath()
        if height > width {
            let  p0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
            path.move(to: p0)
            
            let  p1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
            path.addLine(to: p1)
            path.lineWidth = width
            
        } else {
            let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
            path.move(to: p0)
            
            let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
            path.addLine(to: p1)
            path.lineWidth = height
        }
        
        let  dashes: [ CGFloat ] = [ perDashLength, spaceBetweenDash ]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        
        path.lineCapStyle = .butt
        dashColor.set()
        path.stroke()
    }
    
    private var width : CGFloat {
        return self.bounds.width
    }
    
    private var height : CGFloat {
        return self.bounds.height
    }
}
@IBDesignable class ShadowView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 8.0
    @IBInspectable var shadowOpacity: Float = 0.2
    @IBInspectable var shadowRadius: CGFloat = 2.0
    @IBInspectable var shadowColor: UIColor = UIColor.lightGray

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // corner radius
        self.layer.cornerRadius = cornerRadius

        // border
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.lightGray.cgColor

        // shadow
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
    }
}
@IBDesignable class CustomTextField: UITextField {
    @IBInspectable var leftPadding: CGFloat = 8.0
    @IBInspectable var rightPadding: CGFloat = 8.0
    @IBInspectable var topPadding: CGFloat = 8.0
    @IBInspectable var bottomPadding: CGFloat = 8.0
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding))
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding))
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding))
    }
}

@IBDesignable class ViewBottomShadow: UIView {
    @IBInspectable var opacity :CGFloat = 0.5
    @IBInspectable var shadowColor :UIColor = #colorLiteral(red: 0.8, green: 0.9607843137, blue: 0.9568627451, alpha: 0.5)

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    backgroundColor = .white
    layer.masksToBounds = false
    layer.shadowRadius = 5
    layer.shadowOpacity = Float(opacity)
    layer.shadowColor = shadowColor.cgColor
    layer.shadowOffset = CGSize(width: 2 , height:5)
  }

}
@IBDesignable class CustomImageView:UIImageView {
    @IBInspectable var tintedColor: UIColor{
        get{
            return tintColor
        }
        set{
            image = image?.withRenderingMode(.alwaysTemplate)
            tintColor = newValue
        }
    }
}
class ShadowNewView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // corner radius
        self.layer.cornerRadius = 14

        // border
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.black.cgColor

        // shadow
        self.layer.shadowColor = #colorLiteral(red: 0.81765908, green: 0.8176783919, blue: 0.8176679015, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 4.0
    }

}
@IBDesignable class VerticalGradientView: UIView {
    @IBInspectable var firstColor: UIColor = #colorLiteral(red: 0, green: 0.8666666667, blue: 0.6, alpha: 1)
    @IBInspectable var secondColor: UIColor = #colorLiteral(red: 0.01176470588, green: 0.6705882353, blue: 0.9098039216, alpha: 1)

    @IBInspectable var vertical: Bool = false

    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer
    }()

    //MARK: -

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        applyGradient()
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)

        applyGradient()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }

    //MARK: -

    func applyGradient() {
        updateGradientDirection()
        layer.sublayers = [gradientLayer]
    }

    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }

    func updateGradientDirection() {
        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
}

@IBDesignable class ThreeColorsGradientView: UIView {
    @IBInspectable var firstColor: UIColor = UIColor.red
    @IBInspectable var secondColor: UIColor = UIColor.green
    @IBInspectable var thirdColor: UIColor = UIColor.blue

    @IBInspectable var vertical: Bool = true {
        didSet {
            updateGradientDirection()
        }
    }

    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
        layer.startPoint = CGPoint.zero
        return layer
    }()

    //MARK: -

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        applyGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        applyGradient()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }

    //MARK: -

    func applyGradient() {
        updateGradientDirection()
        layer.sublayers = [gradientLayer]
    }

    func updateGradientFrame() {
        gradientLayer.frame = bounds
    }

    func updateGradientDirection() {
        gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
    }
}

@IBDesignable class RadialGradientView: UIView {

    @IBInspectable var outsideColor: UIColor = UIColor.red
    @IBInspectable var insideColor: UIColor = UIColor.green

    override func awakeFromNib() {
        super.awakeFromNib()

        applyGradient()
    }

    func applyGradient() {
        let colors = [insideColor.cgColor, outsideColor.cgColor] as CFArray
        let endRadius = sqrt(pow(frame.width/2, 2) + pow(frame.height/2, 2))
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        let context = UIGraphicsGetCurrentContext()

        context?.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: endRadius, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        #if TARGET_INTERFACE_BUILDER
            applyGradient()
        #endif
    }
}
@IBDesignable class BottomShadowView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.layer.shadowColor = #colorLiteral(red: 0.9725490196, green: 0.9960784314, blue: 0.9882352941, alpha: 1)
//        self.layer.shadowOffset = CGSize(width: 5, height: 10)
//        self.layer.shadowRadius = 8
//        self.layer.shadowOpacity = 1.0
        
        self.layer.shadowColor = #colorLiteral(red: 0.2274509804, green: 0.2235294118, blue: 0.2274509804, alpha: 0.08)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false

    }
}

private var __maxLengths = [UITextField: Int]()

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // global default-limit or just, Int.max
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }

    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}
