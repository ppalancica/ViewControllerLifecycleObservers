//
//  UIViewControllers+LifecycleObservers.swift
//  ViewControllerLifecycleObservers
//
//  Created by Pavel Palancica  on 16.02.2025.
//

import UIKit

public protocol UIViewControllerLifecycleObserver {
    func remove()
}

public extension UIViewController {
    @discardableResult
    func onViewWillAppear(
        run callback: @escaping () -> Void
    ) -> UIViewControllerLifecycleObserver {
        let observer = ViewControllerLifecycleObserver(
            viewWillAppearCallback: callback
        )
        add(observer)
        return observer
    }
    
    private func add(_ observer: UIViewController) {
        addChild(observer)
        observer.view.isHidden = true
        view.addSubview(observer.view)
        observer.didMove(toParent: self)
    }
}

private class ViewControllerLifecycleObserver: UIViewController, UIViewControllerLifecycleObserver {
    private var viewWillAppearCallback: (() -> Void)? = nil
    private var viewDidAppearCallback: (() -> Void)? = nil
    
    private var viewWillDisappearCallback: (() -> Void)? = nil
    private var viewDidDisappearCallback: (() -> Void)? = nil
    
    convenience init(
        viewWillAppearCallback: (() -> Void)? = nil,
        viewDidAppearCallback: (() -> Void)? = nil,
        viewWillDisappearCallback: (() -> Void)? = nil,
        viewDidDisappearCallback: (() -> Void)? = nil
    ) {
        self.init()
        self.viewWillAppearCallback = viewWillAppearCallback
        self.viewDidAppearCallback = viewDidAppearCallback
        self.viewWillDisappearCallback = viewWillDisappearCallback
        self.viewDidDisappearCallback = viewDidDisappearCallback
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        viewWillAppearCallback?()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        viewDidAppearCallback?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(false)
        viewWillDisappearCallback?()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(false)
        viewDidDisappearCallback?()
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
