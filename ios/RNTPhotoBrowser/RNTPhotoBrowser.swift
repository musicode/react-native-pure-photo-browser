
import Foundation

class Configuration: PhotoBrowserConfiguration {
    
    override func isLoaded(url: String) -> Bool {
        return false
    }
    
    override func load(imageView: UIImageView, url: String, onLoadStart: @escaping (Bool) -> Void, onLoadProgress: @escaping (Int64, Int64) -> Void, onLoadEnd: @escaping (Bool) -> Void) {
        onLoadStart(true)
        RNTPhotoBrowser.loadImage(imageView, url, onLoadProgress, onLoadEnd)
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

func formatPhoto(data: [String: String]) -> Photo {
    
    let thumbnailUrl = data["thumbnailUrl"]!
    let highQualityUrl = data["highQualityUrl"]!
    let rawUrl = data["rawUrl"]!
    
    return Photo(thumbnailUrl: thumbnailUrl, highQualityUrl: highQualityUrl, rawUrl: rawUrl)
    
}

@objc class RNTPhotoBrowser: NSObject {
    
    @objc public static var loadImage: ((UIImageView, String, (Int64, Int64) -> Void, (Bool) -> Void) -> Void)!
    
    @objc public static var open: (Int, [[String: String]]) -> Void = { index, list in
        
        DispatchQueue.main.async {
            PhotoBrowserController(configuration: Configuration(), indicator: .none, pageMargin: 30).show(photos: list.map {
                return formatPhoto(data: $0)
            }, index: index)
        }
        
    }
    
    @objc public static var compress: (String, String) -> CompressResult? = { src, dest in
        let compressor = Compressor()
        return compressor.compress(src: src, dest: dest)
    }
    
}
