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
    private var viewWillAppearCallback: () -> Void = {}
    
    convenience init(viewWillAppearCallback: @escaping () -> Void = {}) {
        self.init()
        self.viewWillAppearCallback = viewWillAppearCallback
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        viewWillAppearCallback()
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
