
import UIKit

public class NumberIndicator: UIView {
    
    // 当前页
    public var index = -1 {
        didSet {
            indexView.text = "\(index)"
        }
    }
    
    // 总页数
    public var count = -1 {
        didSet {
            countView.text = "\(count)"
        }
    }
    
    // 分隔符
    public var separator = "" {
        didSet {
            separatorView.text = separator
        }
    }
    
    // 分隔符与 index count 的间距
    public var gap: CGFloat = 0 {
        didSet {
            separatorLeftConstraint.constant = gap
            separatorRightConstraint.constant = -gap
            setNeedsLayout()
        }
    }
    
    // 文本字号
    public var textSize: CGFloat = 0 {
        didSet {
            let font = UIFont.systemFont(ofSize: textSize)
            indexView.font = font
            countView.font = font
            separatorView.font = font
        }
    }
    
    // 文本颜色
    public var textColor = UIColor.cyan {
        didSet {
            indexView.textColor = textColor
            countView.textColor = textColor
            separatorView.textColor = textColor
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(
            width: indexView.intrinsicContentSize.width + gap + separatorView.intrinsicContentSize.width + gap + countView.intrinsicContentSize.width,
            height: indexView.intrinsicContentSize.height
        )
    }

    private lazy var indexView: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }()
    
    private lazy var separatorView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }()
   
    private lazy var countView: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }()
    
    private lazy var separatorLeftConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: separatorView, attribute: .left, relatedBy: .equal, toItem: indexView, attribute: .right, multiplier: 1, constant: 0)
    }()
    
    private lazy var separatorRightConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: separatorView, attribute: .right, relatedBy: .equal, toItem: countView, attribute: .left, multiplier: 1, constant: 0)
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        backgroundColor = .clear

        // 确保两点：
        // 1. 能显示所有可能的长度
        // 2. 数字变更时布局不会跳动
        let labelWidth: CGFloat = 50
        
        addConstraints([
            
            NSLayoutConstraint(item: indexView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: indexView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: indexView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: labelWidth),
            
            NSLayoutConstraint(item: countView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: countView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: countView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: labelWidth),
            
            separatorLeftConstraint,
            separatorRightConstraint,
            NSLayoutConstraint(item: separatorView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            
        ])
        
    }
    
}
