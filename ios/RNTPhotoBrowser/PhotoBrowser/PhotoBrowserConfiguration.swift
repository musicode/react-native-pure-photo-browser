
import UIKit

// 配置
@objc open class PhotoBrowserConfiguration: NSObject {
    
    // 背景色
    @objc public var backgroundColor = UIColor.black
    
    // 斑点指示器到底部的距离
    @objc public var dotIndicatorMarginBottom: CGFloat = 20

    // 斑点指示器非当前位置的颜色
    @objc public var dotIndicatorColorNormal = UIColor(red: 210 / 255, green: 210 / 255, blue: 210 / 255, alpha: 0.8)
    
    // 斑点指示器当前位置的颜色
    @objc public var dotIndicatorColorActive = UIColor(red: 255, green: 255, blue: 255, alpha: 0.8)
    
    // 斑点指示器两点之间的距离
    @objc public var dotIndicatorGap = 4.0
    
    // 斑点指示器非当前位置的半径
    @objc public var dotIndicatorRadiusNormal = 2.7
    
    // 斑点指示器当前位置的半径
    @objc public var dotIndicatorRadiusActive = 3.0
    
    // 数字指示器到底部的距离
    @objc public var numberIndicatorMarginBottom: CGFloat = 15
    
    // 数字指示器分隔符
    @objc public var numberIndicatorSeparator = "/"
    
    // 数字指示器分隔符与数字的距离
    @objc public var numberIndicatorGap: CGFloat = 4.0
    
    // 数字指示器文本颜色
    @objc public var numberIndicatorTextColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.8)
    
    // 数字指示器文本大小
    @objc public var numberIndicatorTextSize: CGFloat = 14
    
    // 查看原图按钮的标题
    @objc public var rawButtonImage = UIImage(named: "photo_browser_raw")
    
    // 查看原图按钮到底部的距离
    @objc public var rawButtonMarginBottom: CGFloat = 40
    
    // 保存按钮的图标
    @objc public var saveButtonImage = UIImage(named: "photo_browser_save")
    
    // 保存按钮到底部的距离
    @objc public var saveButtonMarginBottom: CGFloat = 40
    
    // 保存按钮到右边的距离
    @objc public var saveButtonMarginRight: CGFloat = 20

    
    
    public override init() { }
    
    open func load(imageView: UIImageView, url: String, onLoadStart: @escaping (Bool) -> Void, onLoadProgress: @escaping (Int, Int) -> Void, onLoadEnd: @escaping (UIImage?) -> Void) {
        
    }
    
    open func isLoaded(url: String) -> Bool {
        return false
    }
    
    open func save(url: String, image: UIImage, complete: @escaping (Bool) -> Void) -> Void {
        
    }

}
