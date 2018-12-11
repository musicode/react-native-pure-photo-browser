//
//  JXPhotoBrowserFadeTransitioning.swift
//  JXPhotoBrowser
//
//  Created by JiongXing on 2018/10/16.
//

import Foundation
import UIKit

public class JXPhotoBrowserFadeTransitioning: JXPhotoBrowserTransitioning {
    public override init() {
        super.init()
        self.presentingAnimator = JXPhotoBrowserFadePresentingAnimator()
        self.dismissingAnimator = JXPhotoBrowserFadeDismissingAnimator()
    }
}
