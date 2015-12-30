import UIKit

enum Direction {
    case Up
    case Down
}

protocol CooperativeDismissing: class {
    func canDismissInDirection(direction: Direction) -> Bool
    func willBeginDismissing()
    func didCancelDismissing()
}

class PresentationController: UIPresentationController {
    private(set) var interactiveDismissalController: UIPercentDrivenInteractiveTransition?
    private(set) var interactiveDismissalAnimation: UIViewControllerAnimatedTransitioning?
    private weak var cooperativeDismissing: CooperativeDismissing?
    
    override func presentationTransitionWillBegin() {
        if let view = presentedView() {
            containerView?.addSubview(view)
            
            if let coop = presentedViewController as? CooperativeDismissing {
                cooperativeDismissing = coop
                let dismissPanGesture = UIPanGestureRecognizer(target: self, action: "panned:")
                dismissPanGesture.delegate = self
                containerView?.addGestureRecognizer(dismissPanGesture)
            }
        }
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        if !completed {
            presentedView()?.removeFromSuperview()
        }
    }
    
    private func slideOffAnimationWithDirection(direction: Direction) -> UIViewControllerAnimatedTransitioning {
        let transition = TransitionAnimation(duration: 0.25)
        transition.apply = { context in
            switch direction {
            case .Up: context.fromView?.top = context.containerView()!.frame.size.height
            case .Down: context.fromView?.bottom = 0.0
            }
        }
        return transition
    }
}

extension PresentationController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func panned(panGesture: UIPanGestureRecognizer) {
        guard let panView = panGesture.view, coop = cooperativeDismissing else { return }
        
        let pan = panGesture.translationInView(panView)
        let direction: Direction = pan.y < 0.0 ? .Down : .Up
        
        guard coop.canDismissInDirection(direction) else {
            panGesture.setTranslation(CGPoint.zero, inView: panView)
            return
        }
        
        startDismissingInDirection(direction)
        
        let sign: CGFloat = direction == .Up ? 1.0 : -1.0
        let percent = (pan.y * sign) / panView.frame.size.height
        
        switch panGesture.state {
        case .Changed:
            interactiveDismissalController?.updateInteractiveTransition(percent)
            
        case .Ended:
            finishDismissing(percent > 0.3)
            
        case .Cancelled:
            finishDismissing(false)
            
        default: break
        }
    }
    
    func startDismissingInDirection(direction: Direction) {
        if interactiveDismissalController == nil {
            cooperativeDismissing?.willBeginDismissing()
            interactiveDismissalController = UIPercentDrivenInteractiveTransition()
            interactiveDismissalAnimation = slideOffAnimationWithDirection(direction)
            presentedViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func finishDismissing(completed: Bool) {
        if let interactionController = interactiveDismissalController {
            if completed {
                interactionController.finishInteractiveTransition()
            } else {
                cooperativeDismissing?.didCancelDismissing()
                interactionController.cancelInteractiveTransition()
            }
            interactiveDismissalController = nil
            interactiveDismissalAnimation = nil
        }        
    }
}
