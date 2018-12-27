
import UIKit

public class CircleSpinner: UIView {
    
    // 当前值
    // 可选值为 0 - 1
    public var value: CGFloat = 0 {
        didSet {
            if (value > 1) {
                value = 1
            }
            else if (value < 0) {
                value = 0
            }
        }
    }
    
    // 圆形的颜色
    public var color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
    
    // 圆形的半径
    public var radius: CGFloat = 24 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    // 圆环和扇形之间的距离
    public var strokeGap: CGFloat = 1
    
    // 圆环的粗细
    public var strokeWidth: CGFloat = 1
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 2 * radius, height: 2 * radius)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    public override func draw(_ rect: CGRect) {

        let centerX = bounds.midX
        let centerY = bounds.midY
        let centerPoint = CGPoint(x: centerX, y: centerY)
        let startAngle = -CGFloat.pi / 2
        
        color.setStroke()
        color.setFill()
        
        var path = UIBezierPath(arcCenter: centerPoint, radius: radius - strokeWidth / 2, startAngle: startAngle, endAngle: startAngle + CGFloat.pi * 2, clockwise: true)
        path.lineWidth = strokeWidth
        path.stroke()

        path = UIBezierPath(arcCenter: centerPoint, radius: radius - strokeWidth - strokeGap, startAngle: startAngle, endAngle: startAngle + CGFloat.pi * 2 * value, clockwise: true)
        path.addLine(to: centerPoint)
        path.close()
        path.fill()
        
    }
}
