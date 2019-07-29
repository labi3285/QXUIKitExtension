# QXMessageView
A easy customize tip shower in swift.

### install
```
pod search QXMessageView
```

### simple use
![](https://github.com/labi3285/QXMessageView/blob/master/screen.png)
```objc
extension UIViewController {
    func showLoading(msg: String?) {
        _ = QXMessageView.demoLoading(msg: msg, superview: view)
    }
    func hideLoading() {
        for view in view.subviews {
            if let view = view as? QXMessageView {
                view.remove()
            }
        }
    }
    func showSuccess(msg: String, complete: (() -> ())? = nil) {
        QXMessageView.demoSuccess(msg: msg, superview: view, complete: complete)
    }
    func showFailure(msg: String, complete: (() -> ())? = nil) {
        QXMessageView.demoFailure(msg: msg, superview: view, complete: complete)
    }
    func showWarning(msg: String, complete: (() -> ())? = nil) {
        QXMessageView.demoWarning(msg: msg, superview: view, complete: complete)
    }
}

```

### customize

For customize showers, Just like how demo implemented.
```objc
class DemoView: QXMessageViewContentViewProtocol {
    // Customize view follow QXMessageViewContentViewProtocol
}

```
```objc
let demoView = DemoView()
let messageView = QXMessageView.messageView(contentView: demoView, superview: self, duration: 1, complete: {
    // todo
})

```
Have fun!
