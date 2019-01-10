
import Foundation
import UIKit
import Photos

class Configuration: PhotoBrowserConfiguration {
    
    override func isLoaded(url: String) -> Bool {
        return RNTPhotoBrowser.isPhotoLoaded(url)
    }
    
    override func load(imageView: UIImageView, url: String, onLoadStart: @escaping (Bool) -> Void, onLoadProgress: @escaping (Int, Int) -> Void, onLoadEnd: @escaping (UIImage?) -> Void) {
        RNTPhotoBrowser.loadPhoto(imageView, url, 0, 0, onLoadStart, onLoadProgress, onLoadEnd)
    }
    
    override func save(url: String, image: UIImage, complete: @escaping (Bool) -> Void) {
        
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        var album: PHAssetCollection? = nil
        var albumIdentifier = ""
        var photoIdentifier: String? = nil
        
        let albumName = RNTPhotoBrowser.getAlbumName()
        
        for i in 0..<fetchResult.count {
            if fetchResult[i].localizedTitle == albumName {
                album = fetchResult[i]
                break
            }
        }
        
        let addPhoto = {
            PHPhotoLibrary.shared().performChanges({
                
                let path = RNTPhotoBrowser.getPhotoCachePath(url)
                
                photoIdentifier = PHAssetCreationRequest.creationRequestForAssetFromImage(atFileURL: URL(fileURLWithPath: path))?.placeholderForCreatedAsset?.localIdentifier
                
            }, completionHandler: { success, error in
                
                guard error == nil, let localIdentifier = photoIdentifier else {
                    complete(false)
                    return
                }
                
                PHPhotoLibrary.shared().performChanges({
                    
                    let request = PHAssetCollectionChangeRequest(for: album!)
                    let asset = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil).firstObject
                    
                    request?.addAssets([asset] as NSFastEnumeration)
                    
                }, completionHandler: { success, error in
                    complete(error == nil)
                })
                
            })
        }
        
        if album == nil {
            PHPhotoLibrary.shared().performChanges({
                albumIdentifier = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName).placeholderForCreatedAssetCollection.localIdentifier
            }, completionHandler: { success, error in
                guard error == nil, let target = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumIdentifier], options: nil).firstObject else {
                    complete(false)
                    return
                }
                album = target
                addPhoto()
            })
        }
        else {
            addPhoto()
        }

    }
    
}

@objc public class CompressResult: NSObject {
    
    @objc public var path: String
    
    @objc public var width: Int
    
    @objc public var height: Int
    
    @objc public init(path: String, width: Int, height: Int) {
        self.path = path
        self.width = width
        self.height = height
    }
    
}

@objc public class Compressor: NSObject {
    
    private var maxWidth: CGFloat = 2000
    private var maxHeight: CGFloat = 2000
    private var quality: CGFloat = 0.5
    
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
        
        if let data = image.jpegData(compressionQuality: quality) as NSData? {
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
    
    @objc public static var isPhotoLoaded: ((String) -> Bool)!
    
    @objc public static var loadPhoto: ((UIImageView, String, Int, Int, @escaping (Bool) -> Void, @escaping (Int, Int) -> Void, @escaping (UIImage?) -> Void) -> Void)!
    
    @objc public static var getPhotoCachePath: ((String) -> String)!
    
    @objc public static var getAlbumName: (() -> String)!

    @objc public static var open: ([[String: String]], Int, String, Int) -> Void = { list, index, indicator, pageMargin in
        
        DispatchQueue.main.async {
            
            var indicatorType = PhotoBrowser.IndicatorType.none
            if indicator == "dot" {
                indicatorType = .dot
            }
            else if indicator == "number" {
                indicatorType = .number
            }
            
            PhotoBrowserController(configuration: Configuration(), indicator: indicatorType, pageMargin: CGFloat(pageMargin)).show(photos: list.map {
                return formatPhoto(data: $0)
            }, index: index)
            
        }
        
    }
    
    @objc public static var compress: (String, String) -> CompressResult? = { src, dest in
        let compressor = Compressor()
        return compressor.compress(src: src, dest: dest)
    }
    
}
