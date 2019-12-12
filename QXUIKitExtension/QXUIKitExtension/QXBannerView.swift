//
//  QXBannerView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXBannerView<Model>: QXView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public var respondSelect: ((_ idx: Int, _ model: Model?) -> ())?
    public var respondChange: ((_ idx: Int, _ total: Int) -> ())?
    
    public weak var pageIndicatorView: QXPageIndicatorView?
    
    /// 自动延时
    public var autoTurnDuration: TimeInterval = 3
    /// 自动
    public var isAutoTurnEnabled: Bool = true
    /// 手动
    public var isManualTurnEnabled: Bool {
        set {
            uiCollectionView.isScrollEnabled = newValue
        }
        get {
            return uiCollectionView.isScrollEnabled
        }
    }

    open var banners: [QXBanner<Model>] = [] {
        didSet {
            uiCollectionView.reloadData()
            pageIndicatorView?.isDisplay = banners.count > 1
            pageIndicatorView?.count = banners.count
            if banners.count > 1 && isAutoTurnEnabled {
                _beginTimer()
            }
        }
    }
    
    public final lazy var flowLayout: UICollectionViewFlowLayout = {
        let one = UICollectionViewFlowLayout()
        one.scrollDirection = .horizontal
        one.minimumInteritemSpacing = 0
        one.minimumLineSpacing = 0
        one.sectionInset = UIEdgeInsets.zero
        return one
    }()
    public final lazy var uiCollectionView: UICollectionView = {
        let one = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        one.dataSource = self
        one.delegate = self
        one.isPagingEnabled = true
        one.showsHorizontalScrollIndicator = false
        one.showsVerticalScrollIndicator = false
        one.alwaysBounceHorizontal = false
        one.register(QXTextBannerCell<Model>.self, forCellWithReuseIdentifier: "QXTextBannerCell")
        one.register(QXImageBannerCell<Model>.self, forCellWithReuseIdentifier: "QXImageBannerCell")
        one.register(QXViewBannerCell<Model>.self, forCellWithReuseIdentifier: "QXViewBannerCell")
        one.scrollsToTop = false
        one.backgroundColor = UIColor.clear
        return one
    }()
    
    override init() {
        super.init()
        addSubview(uiCollectionView)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        uiCollectionView.qxRect = qxBounds.rectByReduce(padding)
    }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        if banners.count > 1 {
            return 999
        }
        return 1
    }
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let banner = banners[indexPath.row]
        if let e = banner as? QXImageBanner {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QXImageBannerCell", for: indexPath) as! QXImageBannerCell<Model>
            cell.banner = e
            return cell
        } else if let e = banner as? QXTextBanner {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QXTextBannerCell", for: indexPath) as! QXTextBannerCell<Model>
            cell.banner = e
            return cell
        } else if let e = banner as? QXViewBanner {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QXViewBannerCell", for: indexPath) as! QXViewBannerCell<Model>
            cell.banner = e
            return cell
        }
        return QXDebugFatalError("not support yet", UICollectionViewCell())
    }
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _removeTimer()
    }
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let e = uiCollectionView.visibleCells.first, let indexPath = uiCollectionView.indexPath(for: e) {
            pageIndicatorView?.current = indexPath.item
            respondChange?(indexPath.item, banners.count)
        }
    }
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if banners.count > 1 {
            _beginTimer()
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let banner = banners[indexPath.item]
        respondSelect?(indexPath.item, banner.model)
    }
    
    private func _performNext() {
        if banners.count <= 1 { return }
        if let e = uiCollectionView.visibleCells.first, let indexPath = uiCollectionView.indexPath(for: e) {
            var section: Int = 0
            var row: Int = 0
            row = indexPath.row + 1
            section = indexPath.section
            if row >= banners.count {
                row = 0
                section = indexPath.section + 1
            }
            if section >= 999 {
                section = 0
                row = 0
            }
            let idx = IndexPath(item: row, section: section)
            uiCollectionView.scrollToItem(at: idx, at: .centeredHorizontally, animated: true)
            respondChange?(idx.row, banners.count)
            pageIndicatorView?.current = idx.row
        }
    }
    
    // timer
    private var _timer: QXTimer?
    private func _removeTimer() {
        _timer?.remove()
        _timer = nil
    }
    private func _beginTimer() {
        _removeTimer()
        let e = QXTimer(duration: autoTurnDuration)
        e.loop = { [weak self] t in
            self?._performNext()
        }
        _timer = e
    }
    
}

open class QXBanner<Model> {
    var model: Model?
}
open class QXBannerCell<Model>: UICollectionViewCell {
    open var banner: QXBanner<Model>!
}

open class QXTextBanner<Model>: QXBanner<Model> {
    public init(_ text: String) {
        self.text = text
    }
    public init(_ text: String, _ font: QXFont) {
        self.text = text
        self.font = font
    }
    public init(_ items: [QXRichLabel.Item]) {
        if items.count > 0 {
            self.items = items
        }
    }
    public init(_ items: QXRichLabel.Item...) {
        if items.count > 0 {
            self.items = items
        }
    }
    open var text: String = ""
    open var font: QXFont = QXFont(14, QXColor.dynamicText)
    open var items: [QXRichLabel.Item]?
    open var respondTouchLink: ((_ data: Any) -> ())?
    open var alignmentX: QXAlignmentX = .center
    open var alignmentY: QXAlignmentY = .center
    open var lineSpace: CGFloat = 0
    open var paragraphSpace: CGFloat = 0
    open var justified: Bool = true
    open var firstLineHeadIndent: CGFloat = 0
    open var hyphenationFactor: CGFloat = 0
    open var highlightColor: QXColor = QXColor.dynamicHiglight
    open var isCopyEnabled: Bool = false
    open var numberOfLines: Int = 0
    open var padding: QXEdgeInsets = QXEdgeInsets(5, 15, 5, 15)
}

open class QXTextBannerCell<Model>: QXBannerCell<Model> {
    open override var banner: QXBanner<Model>! {
        didSet {
            if let e = banner as? QXTextBanner<Model> {
                label.respondTouchLink = e.respondTouchLink
                label.alignmentX = e.alignmentX
                label.alignmentY = e.alignmentY
                label.lineSpace = e.lineSpace
                label.paragraphSpace = e.paragraphSpace
                label.justified = e.justified
                label.firstLineHeadIndent = e.firstLineHeadIndent
                label.hyphenationFactor = e.hyphenationFactor
                label.highlightColor = e.highlightColor
                label.isCopyEnabled = e.isCopyEnabled
                label.padding = e.padding
                label.numberOfLines = e.numberOfLines
                
                if let e = e.items {
                    label.items = e
                } else {
                    label.font = e.font
                    label.text = e.text
                }
            }
        }
    }
    public final lazy var label: QXRichLabel = {
        let e = QXRichLabel()
        e.numberOfLines = 0
        return e
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        label.fixWidth = contentView.bounds.width
    }
}

open class QXImageBanner<Model>: QXBanner<Model> {
    public init(_ image: QXImage) {
        self.image = image
    }
    open var image: QXImage?
    open var isForceImageFill: Bool = false
    open var contentMode: UIView.ContentMode = .scaleAspectFit
    open var isForcePlaceHolderFill: Bool = false
    open var isThumbnail: Bool = false
    open var placeHolderImage: QXImage?
    open var padding: QXEdgeInsets = QXEdgeInsets.zero
}

open class QXImageBannerCell<Model>: QXBannerCell<Model> {
    open override var banner: QXBanner<Model>! {
        didSet {
            if let e = banner as? QXImageBanner {
                myImageView.contentMode = e.contentMode
                myImageView.isThumbnail = e.isThumbnail
                myImageView.placeHolderImage = e.placeHolderImage
                myImageView.image = e.image
                myImageView.padding = e.padding
            }
        }
    }
    public final lazy var myImageView: QXImageView = {
        let e = QXImageView()
        e.contentMode = .scaleToFill
        return e
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(myImageView)
        myImageView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class QXViewBanner<Model>: QXBanner<Model> {
    public init(_ view: QXView) {
        self.view = view
    }
    open var view: QXView
    open var padding: QXEdgeInsets = QXEdgeInsets.zero
}
open class QXViewBannerCell<Model>: QXBannerCell<Model> {
    open override var banner: QXBanner<Model>! {
        didSet {
            if let e = oldValue as? QXViewBanner {
                e.view.removeFromSuperview()
            }
            if let e = banner as? QXViewBanner {
                contentView.addSubview(e.view)
                setNeedsLayout()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        if let e = banner as? QXViewBanner {
            e.view.qxRect = contentView.qxBounds.rectByReduce(e.padding)
        }
    }
    
}