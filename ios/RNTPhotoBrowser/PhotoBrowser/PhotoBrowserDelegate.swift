
import Foundation

public protocol PhotoBrowserDelegate {
    
    // 保存图片完成
    func photoBrowserDidSave(photo: Photo, success: Bool)
    
    // 点击图片
    func photoBrowserDidTap(photo: Photo)
    
    // 长按图片
    func photoBrowserDidLongPress(photo: Photo)
    
}

public extension PhotoBrowserDelegate {

    func photoBrowserDidSave(photo: Photo, success: Bool) { }

    func photoBrowserDidTap(photo: Photo) { }
    
    func photoBrowserDidLongPress(photo: Photo) { }
    
}

