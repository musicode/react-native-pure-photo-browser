
import UIKit

public class PhotoBrowserController: UIViewController {

    private var index = 0
    private var photos = [Photo]()
    
    private var pageMargin: CGFloat = 0
    private var indicator: PhotoBrowser.IndicatorType!
    private var configuration: PhotoBrowserConfiguration!
    
    private let tipLabel = UILabel()
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public init(configuration: PhotoBrowserConfiguration, indicator: PhotoBrowser.IndicatorType, pageMargin: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        self.configuration = configuration
        self.indicator = indicator
        self.pageMargin = pageMargin
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(photos: [Photo], index: Int) {
        self.index = index
        self.photos = photos
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        extendedLayoutIncludesOpaqueBars = true
        automaticallyAdjustsScrollViewInsets = false
        
        let photoBrowser = PhotoBrowser(configuration: configuration)
        
        photoBrowser.delegate = self
        
        photoBrowser.indicator = indicator
        photoBrowser.pageMargin = pageMargin
        
        photoBrowser.index = index
        photoBrowser.photos = photos
        
        photoBrowser.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(photoBrowser)
        
        view.addConstraints([
            NSLayoutConstraint(item: photoBrowser, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: photoBrowser, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: photoBrowser, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: photoBrowser, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
        ])
        
        
        
        tipLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        tipLabel.layer.cornerRadius = 6
        tipLabel.clipsToBounds = true
        
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
        tipLabel.textColor = .white
        tipLabel.font = UIFont.systemFont(ofSize: 12)
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tipLabel)
        
        view.addConstraints([
            NSLayoutConstraint(item: tipLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tipLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tipLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 80),
            NSLayoutConstraint(item: tipLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        ])
        
    }

}

extension PhotoBrowserController: PhotoBrowserDelegate {
    
    public func photoBrowserDidTap(photo: Photo) {
        dismiss(animated: true, completion: nil)
    }
    
    public func photoBrowserDidLongPress(photo: Photo) {
        
    }
    
    public func photoBrowserDidSave(photo: Photo, success: Bool) {
        
        if success {
            tipLabel.text = "保存成功"
        }
        else {
            tipLabel.text = "保存失败"
        }
        
        tipLabel.isHidden = false
        tipLabel.alpha = 0
        
        UIView.animateKeyframes(withDuration: 2.5, delay: 0, options: .calculationModeLinear, animations: {
            
            // 淡入
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.05, animations: {
                self.tipLabel.alpha = 1
            })
            
            // 淡出
            UIView.addKeyframe(withRelativeStartTime: 0.95, relativeDuration: 0.05, animations: {
                self.tipLabel.alpha = 0
            })
            
        }, completion: { success in
            self.tipLabel.isHidden = true
        })
        
    }
}
