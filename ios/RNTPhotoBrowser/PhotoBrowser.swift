
import Foundation

class PhotoLoader: JXPhotoLoader {
    
    public init() { }
    
    public func imageCached(on imageView: UIImageView, url: URL?) -> UIImage? {
        return nil
    }
    
    public func setImage(on imageView: UIImageView, url: URL?, placeholder: UIImage?, progressBlock: @escaping (Int64, Int64) -> Void, completionHandler: @escaping () -> Void) {
        guard let url = url?.absoluteString else {
            return
        }
        PhotoBrowser.loadImage(imageView, url, progressBlock, completionHandler)
    }
}

@objc class CompressResult: NSObject {
    
    @objc public var path: String
    
    @objc public var width: Int
    
    @objc public var height: Int
    
    @objc public init(path: String, width: Int, height: Int) {
        self.path = path
        self.width = width
        self.height = height
    }
    
}

class Compressor {
    
    private var maxWidth: CGFloat = 2000
    private var maxHeight: CGFloat = 2000
    private var quality: CGFloat = 0.5
    
    public init() { }
    
    func setMaxWidth(_ width: CGFloat) -> Compressor {
        maxWidth = width
        return self
    }
    
    func setMaxHeight(_ height: CGFloat) -> Compressor {
        maxHeight = height
        return self
    }
    
    func setQuality(_ quality: CGFloat) -> Compressor {
        self.quality = quality
        return self
    }
    
    func compress(src: String, dest: String) -> CompressResult? {
        
        guard var image = UIImage(contentsOfFile: src) else {
            return nil
        }
        
        var width = image.size.width
        var height = image.size.height
        var ratio: CGFloat = 1
        
        if height > 0 {
            ratio = width / height
        }
        
        var scaled = false
        
        if width > maxWidth && height > maxHeight {
            scaled = true
            // 看短边
            if width / maxWidth > height / maxHeight {
                height = maxHeight
                width = height * ratio
            }
            else {
                width = maxWidth
                height = width / ratio
            }
        }
        else if width > maxWidth && height <= maxHeight {
            scaled = true
            width = maxWidth
            height = width / ratio
        }
        else if width <= maxWidth && height > maxHeight {
            scaled = true
            height = maxHeight
            width = height * ratio
        }
        
        if scaled {
            let rect = CGRect(x: 0, y: 0, width: width, height: height)
            
            UIGraphicsBeginImageContext(rect.size)
            
            let temp = UIImage(cgImage: image.cgImage!, scale: 1, orientation: image.imageOrientation)
            temp.draw(in: rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let newImage = newImage {
                image = newImage
            }
            else {
                return nil
            }
        }
        
        if let data = UIImageJPEGRepresentation(image, quality) as NSData? {
            if data.write(toFile: dest, atomically: true) {
                return CompressResult(path: dest, width: Int(width), height: Int(height))
            }
        }
        
        return nil
        
    }
    
}

@objc class PhotoBrowser: NSObject {
    
    @objc public static var loadImage: ((UIImageView, String, (Int64, Int64) -> Void, () -> Void) -> Void)!
    
    @objc public static var open: (Int, [String]) -> Void = { index, list in
        
        let loader = PhotoLoader()
        
        let dataSource = JXNetworkingDataSource(
            photoLoader: loader,
            numberOfItems: {
                return list.count
            },
            placeholder: { index -> UIImage? in
                return nil
            },
            autoloadURLString: { index -> String? in
                return list[index]
            }
        )
        
        DispatchQueue.main.async {
            JXPhotoBrowser(dataSource: dataSource).show(pageIndex: index)
        }
        
    }
    
    @objc public static var compress: (String, String) -> CompressResult? = { src, dest in
        let compressor = Compressor()
        return compressor.compress(src: src, dest: dest)
    }
}
