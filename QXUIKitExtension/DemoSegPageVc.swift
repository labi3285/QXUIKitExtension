//
//  DemoSegPageVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/4.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoSegPageVc: QXViewController {
    
    public final lazy var segmentsView: QXSegmentsView<String> = {
        let e = QXSegmentsView<String>()
        e.indicatorView = QXSegmentIndicatorView()
        e.compressResistance = QXView.resistanceStable
        var arr: [QXSegmentView<String>] = self.vcs.map { (e) -> QXSegmentView<String> in
            let e = QXSegmentView<String>(e.title ?? "xxx")
            return e
        }
        e.segmentViews = arr
        e.respondSelect = { [weak self] i, t in
            self?.pageVc.scrollTo(index: i, animated: true)
        }
        return e
    }()
    lazy var pageVc: QXPageViewController = {
        let e = QXPageViewController(self.vcs)
        e.respondIndex = { [weak self] i in
            self?.segmentsView.scrollTo(index: i, animated: true)
        }
        return e
    }()
    
    lazy var vcs: [QXViewController] = {
        var es = [QXViewController]()
        for i in 0...5 {
            let e = DemoListVc()
            e.title = "标题\(i)"
            es.append(e)
        }
        return es
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QXPageViewController"
        view.addSubview(segmentsView)
        view.addSubview(pageVc.view)
        addChild(pageVc)
        segmentsView.IN(view).TOP.LEFT.RIGHT.MAKE()
        pageVc.view.IN(view).LEFT.RIGHT.BOTTOM.MAKE()
        pageVc.view.TOP.EQUAL(segmentsView).BOTTOM.MAKE()
    }
    
}
