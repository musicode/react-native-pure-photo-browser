//
//  JXPhotoBrowserNetworkingCell.swift
//  JXPhotoBrowser
//
//  Created by JiongXing on 2018/10/14.
//

import Foundation
import UIKit

/// 可展示两级资源。比如首先展示模糊的图片，然后展示清晰的图片
open class JXPhotoBrowserNetworkingCell: JXPhotoBrowserBaseCell {
    
    /// 进度环
    public let progressView = JXPhotoBrowserProgressView()
    
    /// 下载按钮
    let downloadButton = UIButton()
    
    /// 下载结果提示
    let downloadTip = UILabel()
    
    /// 初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
        progressView.isHidden = true
        downloadButton.isHidden = true
        downloadButton.setImage(UIImage(named: "photo_browser_download"), for: .normal)
        
        downloadTip.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        downloadTip.layer.cornerRadius = 8
        downloadTip.clipsToBounds = true
        
        downloadTip.textAlignment = .center
        downloadTip.isHidden = true
        downloadTip.textColor = .white
        downloadTip.font = UIFont.systemFont(ofSize: 14)
        downloadTip.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(progressView)
        contentView.addSubview(downloadButton)
        contentView.addSubview(downloadTip)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: downloadTip, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: downloadTip, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: downloadTip, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 120),
            NSLayoutConstraint(item: downloadTip, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50)
        ])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 布局
    open override func layoutSubviews() {
        super.layoutSubviews()
        progressView.center = CGPoint(x: contentView.bounds.width / 2, y: contentView.bounds.height / 2)
        downloadButton.sizeToFit()
        downloadButton.center = CGPoint(
            x: contentView.bounds.width - 20 - downloadButton.bounds.width / 2,
            y: contentView.bounds.height - 40 - downloadButton.bounds.height / 2
        )
    }
    
    /// 刷新数据
    open func reloadData(photoLoader: JXPhotoLoader,
                         placeholder: UIImage?,
                         autoloadURLString: String?) {
        // 重置环境
        progressView.isHidden = true
        progressView.progress = 0
        // url是否有效
        guard let urlString = autoloadURLString,let url = URL(string: urlString) else {
            imageView.image = placeholder
            setNeedsLayout()
            return
        }
        // 取缓存
        let image = photoLoader.imageCached(on: imageView, url: url)
        let placeholder = image ?? placeholder
        // 加载
        photoLoader.setImage(on: imageView, url: url, placeholder: placeholder, progressBlock: { receivedSize, totalSize in
            if totalSize > 0 {
                self.progressView.progress = CGFloat(receivedSize) / CGFloat(totalSize)
                if receivedSize < totalSize {
                    self.progressView.isHidden = false
                }
            } else {
                self.progressView.progress = 0
            }
        }) {
            self.progressView.isHidden = true
            self.downloadButton.isHidden = false
            self.downloadButton.addTarget(self, action: #selector(self.onDownloadClick), for: .touchUpInside)
            self.setNeedsLayout()
        }
        setNeedsLayout()
    }
    
    @objc func onDownloadClick() {
        guard let image = imageView.image else {
            return
        }
        downloadButton.isHidden = true
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(onDownloadEnd), nil)
    }
    
    @objc func onDownloadEnd(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        if error != nil {
            downloadTip.text = "保存失败"
            downloadButton.isHidden = false
        }
        else {
            downloadTip.text = "保存成功"
        }
        
        downloadTip.isHidden = false
        downloadTip.alpha = 0
        
        UIView.animateKeyframes(withDuration: 3, delay: 0, options: .calculationModeLinear, animations: {
            
            // 淡入
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.05, animations: {
                self.downloadTip.alpha = 1
            })
            
            // 淡出
            UIView.addKeyframe(withRelativeStartTime: 0.95, relativeDuration: 0.05, animations: {
                self.downloadTip.alpha = 0
            })
            
        }, completion: { success in
            self.downloadTip.isHidden = true
        })
        
    }
    
}
