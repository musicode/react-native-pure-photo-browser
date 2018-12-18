
import UIKit

// https://www.appcoda.com/uiscrollview-introduction/

// image.size 是原始尺寸
// imageView.frame.size 是缩放后的尺寸

// 继承 UIView，而不是 UIScrollView
// 这样双击放大不会触发 layoutSubviews
public class PhotoView: UIView {
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.alwaysBounceHorizontal = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        addSubview(view)
        return view
    }()

    public lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.addObserver(self, forKeyPath: "image", options: [.new, .old], context: nil)
        scrollView.addSubview(view)
        return view
    }()

    public var scaleType = ScaleType.fillWidth
    
    public var onTap: (() -> Void)?
    public var onLongPress: (() -> Void)?
    public var onScaleChange: ((CGFloat) -> Void)?
    public var onDragStart: (() -> Void)?
    public var onDragEnd: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reset(image: UIImage? = nil) {
        
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = 1
        
        if let image = image {
            imageView.frame.size = image.size
        }
        
        updateZoomScale()
        updateImagePosition()
        
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        reset()
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let image = imageView.image {
            reset(image: image)
        }
    }

}

extension PhotoView: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView.image != nil ? imageView : nil
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        onDragStart?()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        onDragEnd?()
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateImagePosition()
        onScaleChange?(scrollView.zoomScale / scrollView.minimumZoomScale)
    }
    
}

extension PhotoView {
    
    private func setup() {
        
        backgroundColor = .black
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapGesture))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onDoubleTapGesture))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        
        // 避免 doubleTap 时触发 tap 回调
        tap.require(toFail: doubleTap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture))
        imageView.addGestureRecognizer(longPress)
        
    }
    
    private func updateZoomScale() {
        
        guard let image = imageView.image else {
            return
        }

        let viewSize = bounds.size
        let imageSize = image.size
        
        let widthScale = viewSize.width / imageSize.width
        let heightScale = viewSize.height / imageSize.height
        let scale: CGFloat
        
        if scaleType == .fillWidth {
            scale = widthScale
        }
        else if scaleType == .fillHeight {
            scale = heightScale
        }
        else {
            scale = min(widthScale, heightScale)
        }

        scrollView.maximumZoomScale = 3 * scale < 1 ? 1 : (3 * scale)
        scrollView.minimumZoomScale = scale
        scrollView.zoomScale = scale
        
    }
    
    private func updateImagePosition() {
        
        let imageSize = imageView.frame.size
        guard imageSize.width > 0 && imageSize.height > 0 else {
            return
        }
        
        let viewSize = bounds.size
        
        let x = max(viewSize.width, imageSize.width) / 2
        let y = max(viewSize.height, imageSize.height) / 2
        
        imageView.center = CGPoint(x: x, y: y)
        
    }
    
    private func getZoomRect(point: CGPoint, zoomScale: CGFloat) -> CGRect {
        
        // 传入的 zoomPoint 是相对于图片的实际尺寸计算的

        let x = point.x
        let y = point.y
        
        // 这里的 width height 需要以当前视图为窗口进行缩放
        
        let viewSize = bounds.size
        let width = viewSize.width / zoomScale
        let height = viewSize.height / zoomScale

        return CGRect(x: x - width / 2, y: y - height / 2, width: width, height: height)
        
    }
    
    @objc private func onTapGesture(_ gesture: UILongPressGestureRecognizer) {
        
        onTap?()
        
    }
    
    @objc private func onDoubleTapGesture(_ gesture: UITapGestureRecognizer) {
        
        let scale = scrollView.zoomScale < scrollView.maximumZoomScale ? scrollView.maximumZoomScale : scrollView.minimumZoomScale
        let point = gesture.location(in: imageView)
        
        scrollView.zoom(to: getZoomRect(point: point, zoomScale: scale), animated: true)
        
    }
    
    @objc private func onLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        
        guard gesture.state == .began else {
            return
        }
        
        onLongPress?()
        
    }
    
}

extension PhotoView {
    
    public enum ScaleType {
        case fit, fillWidth, fillHeight
    }
    
}


