//
//  QXLoadStatusView.swift
//  QXViewController
//
//  Created by labi3285 on 2019/7/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public enum QXLoadStatus {
    case loading(_ msg: String?)
    case ok
    case error(_ err: QXError?)
    case empty(_ msg: String?)
}

public protocol QXLoadStatusViewProtocol {
    func qxLoadStatusViewUpdateStatus(_ status: QXLoadStatus)
    func qxLoadStatusViewRetryHandler(_ todo: (() -> ())?)
}

open class QXLoadStatusViewController<LoadStatusView: UIView & QXLoadStatusViewProtocol>: QXViewController {
    
    open func retry() { }
    
    public required init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open var loadStatus: QXLoadStatus = .ok {
        didSet {
            switch loadStatus {
            case .ok:
                loadStatusView.isHidden = true
            case .loading(msg: _):
                loadStatusView.isHidden = false
                contentView.isHidden = true
                loadStatusView.qxLoadStatusViewUpdateStatus(loadStatus)
            case .empty(msg: _):
                loadStatusView.isHidden = false
                contentView.isHidden = true
                loadStatusView.qxLoadStatusViewUpdateStatus(loadStatus)
            case .error(err: _):
                loadStatusView.isHidden = false
                contentView.isHidden = true
                loadStatusView.qxLoadStatusViewUpdateStatus(loadStatus)
            }
        }
    }
    
    public lazy var loadStatusView: LoadStatusView = {
        let one = LoadStatusView()
        one.isHidden = true
        one.qxLoadStatusViewRetryHandler({ [weak self] in
            self?.retry()
        })
        return one
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadStatusView)
    }
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadStatusView.frame = contentView.frame
    }

}
