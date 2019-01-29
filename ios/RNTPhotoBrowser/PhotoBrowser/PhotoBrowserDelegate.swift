
import Foundation

@objc public protocol PhotoBrowserDelegate {
    
    // 切换图片
    func photoBrowserDidChange(photo: Photo, index: Int)
    
    // 保存图片完成
    func photoBrowserDidSave(photo: Photo, index: Int, success: Bool)
    
    // 点击图片
    func photoBrowserDidTap(photo: Photo, index: Int)
    
    // 长按图片
    func photoBrowserDidLongPress(photo: Photo, index: Int)
    
}

public extension PhotoBrowserDelegate {

    func photoBrowserDidChange(photo: Photo, index: Int) { }
    
    func photoBrowserDidSave(photo: Photo, index: Int, success: Bool) { }

    func photoBrowserDidTap(photo: Photo, index: Int) { }
    
    func photoBrowserDidLongPress(photo: Photo, index: Int) { }
    
}

