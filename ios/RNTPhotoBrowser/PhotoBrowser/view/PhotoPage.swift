
import UIKit

class PhotoPage: UICollectionViewCell {
    
    var onTap: ((Photo) -> Void)?
    
    var onLongPress: ((Photo) -> Void)?
    
    var onScaleChange: ((Photo) -> Void)?
    
    var onLoadStart: ((Photo) -> Void)?
    
    var onLoadEnd: ((Photo) -> Void)?
    
    var onDragStart: ((Photo) -> Void)?
    
    var onDragEnd: ((Photo) -> Void)?
    
    var onSave: ((Photo, Bool) -> Void)?

    private lazy var photoView: PhotoView = {
        let view = PhotoView()
        view.onTap = {
            self.onTap?(self.photo)
        }
        view.onLongPress = {
            self.onLongPress?(self.photo)
        }
        view.onScaleChange = { scale in
            self.photo.scale = scale
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
        let view = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        contentView.addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        return view
    }()
    
    private var photo: Photo!
    
    private var loadedUrl = ""
    
    private var hasRawUrl: Bool {
        get {
            return photo.rawUrl != "" && photo.rawUrl != photo.highQualityUrl
        }
    }

    func update(photo: Photo, configuration: PhotoBrowserConfiguration) {
        
        self.photo = photo
        
        var url = photo.highQualityUrl
        
        if hasRawUrl && (configuration.isLoaded(url: photo.rawUrl) || photo.isRawPhotoLoaded) {
            url = photo.rawUrl
        }
        
        if url != loadedUrl {
            loadPhoto(url: url, configuration: configuration)
        }
        
    }
    
    func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(photoView.imageView.image!, self, #selector(onSaveEnd), nil)
    }

    func loadRawPhoto(configuration: PhotoBrowserConfiguration) {
        loadPhoto(url: photo.rawUrl, configuration: configuration)
    }
    
    private func loadPhoto(url: String, configuration: PhotoBrowserConfiguration) {
        
        configuration.load(
            imageView: photoView.imageView,
            url: url,
            onLoadStart: { hasProgress in
                self.onLoadStart(url: url, hasProgress: hasProgress)
            }, onLoadProgress: { loaded, total in
                self.onLoadProgress(loaded: loaded, total: total)
            }, onLoadEnd: { success in
                self.onLoadEnd(url: url, success: success)
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
    
    private func onLoadProgress(loaded: Int64, total: Int64) {
        
        guard normalSpinner.isHidden else {
            return
        }
        circleSpinner.value = CGFloat(loaded) / CGFloat(total)
        circleSpinner.setNeedsDisplay()
        
    }
    
    private func onLoadEnd(url: String, success: Bool) {
        
        if circleSpinner.isHidden {
            normalSpinner.stopAnimating()
            normalSpinner.isHidden = true
        }
        else {
            circleSpinner.isHidden = true
        }
        
        if success {
            if hasRawUrl {
                if url == photo.highQualityUrl {
                    photo.isRawButtonVisible = true
                }
                else {
                    photo.isRawPhotoLoaded = url == photo.rawUrl
                    photo.isRawButtonVisible = false
                }
            }
            photo.isSaveButtonVisible = true
            loadedUrl = url
        }
        else if hasRawUrl && url == photo.rawUrl {
            photo.isRawButtonVisible = true
        }
        
        onLoadEnd?(photo)
        
    }
    
    @objc private func onSaveEnd(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        onSave?(photo, error == nil)
    }

}
