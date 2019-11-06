
import Foundation
import UIKit
import Photos

@objc public class RNTPhotoBrowserConfiguration: PhotoBrowserConfiguration {

    @objc public static var isImageLoaded: ((String) -> Bool)!
    
    @objc public static var loadImage: ((UIImageView, String, Int, Int, @escaping (Bool) -> Void, @escaping (Int, Int) -> Void, @escaping (UIImage?) -> Void) -> Void)!

    @objc public static var getImageCachePath: ((String) -> String)!

    @objc public static var albumName = ""
    
    override public func isLoaded(url: String) -> Bool {
        return RNTPhotoBrowserConfiguration.isImageLoaded(url)
    }
    
    override public func load(imageView: UIImageView, url: String, onLoadStart: @escaping (Bool) -> Void, onLoadProgress: @escaping (Int, Int) -> Void, onLoadEnd: @escaping (UIImage?) -> Void) {
        RNTPhotoBrowserConfiguration.loadImage(imageView, url, 0, 0, onLoadStart, onLoadProgress, onLoadEnd)
    }
    
    override public func save(url: String, image: UIImage, complete: @escaping (Bool) -> Void) {
        
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        var album: PHAssetCollection? = nil
        var albumIdentifier = ""
        var photoIdentifier: String? = nil
        
        let albumName = RNTPhotoBrowserConfiguration.albumName
        
        for i in 0..<fetchResult.count {
            if fetchResult[i].localizedTitle == albumName {
                album = fetchResult[i]
                break
            }
        }
        
        let addPhoto = {
            PHPhotoLibrary.shared().performChanges({
                
                let path = RNTPhotoBrowserConfiguration.getImageCachePath(url)
                
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
