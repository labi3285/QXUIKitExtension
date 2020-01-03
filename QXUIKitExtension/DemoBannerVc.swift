//
//  DemoBannerViewVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoBannerVc: QXViewController {

    lazy var bannerView: QXBannerView<String> = {
        let e = QXBannerView<String>()
        e.padding = QXEdgeInsets(5, 5, 5, 5)
        e.pageIndicatorView = self.indicatorView
        
        e.respondSelect = { i, e in
            print(e ?? "null")
        }
        
        let a = QXTextBanner<String>("Hello Banner", QXFont(50, .red))
        a.model = "banner text"
        
        let b = QXImageBanner<String>(QXImage("test_image"))
        b.model = "banner image"

        let label = QXLabel()
        label.text = "I'm a custom view"
        let c = QXViewBanner<String>(label)
        c.model = "banner btn"
        e.banners = [a, b, c]
        return e
    }()
    
    lazy var indicatorView: QXPageIndicatorView = {
        let e = QXPageIndicatorView()
        e.padding = QXEdgeInsets(5, 5, 5, 5)
        e.currentImage = QXImage.shapRoundRectFill(size: QXSize(18, 3), radius: 1.5, color: QXColor.hex("#5b87ff", 1))
        e.otherImage = QXImage.shapRoundRectFill(size: QXSize(7, 3), radius: 1.5, color: QXColor.hex("#bdbdbd", 1))
        
//        e.current = .ring(radicus: 3, thickness: 2)
//        e.otherShape = .ring(radicus: 3, thickness: 2)
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bannerView)
        view.addSubview(indicatorView)
        bannerView.IN(view).CENTER.SIZE(300, 150).MAKE()
        indicatorView.IN(view).TOP(100).CENTER.MAKE()
    }
    
}
