
import UIKit

class PhotoPage: UICollectionViewCell {
    
    var configuration: PhotoBrowserConfiguration!
    
    var onTap: ((Photo) -> Void)?
    
    var onLongPress: ((Photo) -> Void)?
    
    var onScaleChange: ((Photo) -> Void)?
    
    var onLoadStart: ((Photo) -> Void)?
    
    var onLoadEnd: ((Photo) -> Void)?
    
    var onDragStart: ((Photo) -> Void)?
    
    var onDragEnd: ((Photo) -> Void)?
    
    lazy var photoView: PhotoView = {
        let view = PhotoView()
        view.onReset = {
            self.updateBounce()
        }
        view.onTap = {
            self.onTap?(self.photo)
        }
        view.onLongPress = {
            self.onLongPress?(self.photo)
        }
        view.onScaleChange = {
            self.photo.scale = view.scale
            self.updateBounce()
            self.onScaleChange?(self.photo)
        }
        view.onDragStart = {
            self.photo.isDragging = true
            self.onDragStart?(self.photo)
        }
        view.onDragEnd = {
            self.photo.isDragging = false
            self.onDragEnd?(self.photo)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        contentView.addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
        ])
        return view
    }()
    
    private lazy var circleSpinner: CircleSpinner = {
        let view = CircleSpinner()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        contentView.addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        return view
    }()
    
    private lazy var normalSpinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        contentView.addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        return view
    }()
    
    var photo: Photo!
    
    private var hasRawUrl: Bool {
        get {
            return photo.rawUrl != "" && photo.rawUrl != photo.highQualityUrl
        }
    }

    func update(photo: Photo) {
        
        self.photo = photo
        
        if photo.thumbnailUrl != ""
            && photo.thumbnailUrl != photo.highQualityUrl
            && !photo.isHighQualityPhotoLoaded
        {
            loadThumbnail()
        }
        else {
            loadHighQuality()
        }
        
    }
    
    // 识别二维码
    func detectQRCode(callback: @escaping (String) -> Void) {
        
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil), let image = photoView.imageView.image?.cgImage else {
            return callback("")
        }

        DispatchQueue.global(qos: .default).async {
            
            var text = ""
            
            let infos = detector.features(in: CIImage(cgImage: image))
            if infos.count > 0 {
                if let info = infos[0] as? CIQRCodeFeature {
                    text = info.messageString ?? ""
                }
            }
            
            DispatchQueue.main.async {
                callback(text)
            }
        }
        
    }

    func loadRawPhoto() {
        loadPhoto(url: photo.rawUrl)
    }
    
    private func updateBounce() {
        photoView.bounceHorizontal = photoView.scale > photoView.minScale
    }
    
    private func loadThumbnail() {
        loadPhoto(url: photo.thumbnailUrl)
    }
    
    private func loadHighQuality() {
        
        var url = photo.highQualityUrl
        
        if hasRawUrl && (configuration.isLoaded(url: photo.rawUrl) || photo.isRawPhotoLoaded) {
            url = photo.rawUrl
        }
        
        loadPhoto(url: url)
        
    }
    
    private func loadPhoto(url: String) {
        
        configuration.load(
            imageView: photoView.imageView,
            url: url,
            onLoadStart: { hasProgress in
                DispatchQueue.main.async {
                    self.onLoadStart(url: url, hasProgress: hasProgress)
                }
            }, onLoadProgress: { loaded, total in
                DispatchQueue.main.async {
                    self.onLoadProgress(loaded: loaded, total: total)
                }
            }, onLoadEnd: { image in
                DispatchQueue.main.async {
                    self.onLoadEnd(url: url, image: image)
                }
            }
        )
        
    }
    
    private func onLoadStart(url: String, hasProgress: Bool) {
        
        if hasProgress {
            circleSpinner.isHidden = false
        }
        else {
            normalSpinner.isHidden = false
            normalSpinner.startAnimating()
        }
        
        if url == photo.rawUrl {
            photo.isRawButtonVisible = false
        }
        photo.isSaveButtonVisible = false
        
        onLoadStart?(photo)
        
    }
    
    private func onLoadProgress(loaded: Int, total: Int) {
        
        guard normalSpinner.isHidden else {
            return
        }
        circleSpinner.value = CGFloat(loaded) / CGFloat(total)
        circleSpinner.setNeedsDisplay()
        
    }
    
    private func onLoadEnd(url: String, image: UIImage?) {

        if circleSpinner.isHidden {
            normalSpinner.stopAnimating()
            normalSpinner.isHidden = true
        }
        else {
            circleSpinner.isHidden = true
        }
        
        photo.currentUrl = url
        photoView.imageView.image = image
        
        if image != nil {
            if photo.thumbnailUrl != photo.highQualityUrl && url == photo.thumbnailUrl {
                DispatchQueue.main.async {
                    self.loadHighQuality()
                }
            }
            else {
                if url == photo.highQualityUrl {
                    photo.isHighQualityPhotoLoaded = true
                }
                else if url == photo.rawUrl {
                    photo.isRawPhotoLoaded = true
                }
                if hasRawUrl {
                    photo.isRawButtonVisible = url == photo.highQualityUrl
                }
                photo.isSaveButtonVisible = photo.canSave
            }
        }
        else if hasRawUrl && url == photo.rawUrl {
            photo.isRawButtonVisible = true
        }
        
        onLoadEnd?(photo)
        
    }

}
