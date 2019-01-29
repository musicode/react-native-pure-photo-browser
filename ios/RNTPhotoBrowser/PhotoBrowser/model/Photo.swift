
import UIKit

@objc public class Photo: NSObject {
    
    // 缩略图
    // 当用户点击一张缩略图打开 photo browser 时，默认显示的站位图
    // 因为一般会共用图片缓存，所以可认为此图无需加载
    @objc public var thumbnailUrl = ""
    
    // 高清图
    // 打开 photo browser 后自动加载的第一张图片
    @objc public var highQualityUrl = ""
    
    // 原图
    // 当高清图加载完成后，如果原图，会显示【查看原图】按钮
    @objc public var rawUrl = ""
    
    // 当前显示的 url
    @objc public var currentUrl = ""
    
    // 记录当前是否需要显示查看原图按钮
    var isRawButtonVisible = false
    
    // 记录当前是否需要显示保存按钮
    var isSaveButtonVisible = false
    
    // 记录是否加载过高清图
    var isHighQualityPhotoLoaded = false
    
    // 记录是否加载过原图
    var isRawPhotoLoaded = false
    
    // 记录当前是否正在拖拽
    var isDragging = false
    
    // 记录当前的缩放值
    var scale: CGFloat = 1

    @objc public init(thumbnailUrl: String, highQualityUrl: String, rawUrl: String) {
        self.thumbnailUrl = thumbnailUrl
        self.highQualityUrl = highQualityUrl
        self.rawUrl = rawUrl
    }

}
