import UIKit

struct ResolvedContextTransitioningKeys {
    let containerView: UIView
    let fromViewController: UIViewController
    let fromView: UIView
    let toViewController: UIViewController
    let toView: UIView
}

extension UIViewControllerContextTransitioning {
    var fromViewController: UIViewController? { return viewControllerForKey(UITransitionContextFromViewControllerKey) }
    var fromView: UIView? { return viewForKey(UITransitionContextFromViewKey) }
    var toViewController: UIViewController? { return viewControllerForKey(UITransitionContextToViewControllerKey) }
    var toView: UIView? { return viewForKey(UITransitionContextToViewKey) }
    
    func resolveAllKeys() -> ResolvedContextTransitioningKeys? {
        if let containerView = containerView(),
            let fromViewController = fromViewController,
            let fromView = fromView ?? fromViewController.view,
            let toViewController = toViewController,
            let toView = toView ?? toViewController.view
        {
            return ResolvedContextTransitioningKeys(
                containerView: containerView,
                fromViewController: fromViewController,
                fromView: fromView,
                toViewController: toViewController,
                toView: toView)
        } else {
            return nil
        }
    }
}