import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private var presentationController: PresentationController?
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return fadeInAnimation()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentationController?.interactiveDismissalAnimation ?? fadeOutAnimation()
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        presentationController = PresentationController(presentedViewController: presented, presentingViewController: presenting ?? source)
        return presentationController
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentationController?.interactiveDismissalController
    }
    
    func fadeInAnimation() -> UIViewControllerAnimatedTransitioning {
        let transition = TransitionAnimation(duration: 0.25)
        transition.setUp = { context in 
            context.toView?.alpha = 0.0
        }
        transition.apply = { context in
            context.toView?.alpha = 1.0
        }
        return transition
    }
    
    func fadeOutAnimation() -> UIViewControllerAnimatedTransitioning {
        let transition = TransitionAnimation(duration: 0.25)
        transition.apply = { context in
            context.fromView?.alpha = 0.0
        }
        return transition
    }
}

