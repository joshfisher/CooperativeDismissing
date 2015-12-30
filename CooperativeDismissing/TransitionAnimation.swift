//
//  TransitionAnimation.swift
//  CooperativeDismissing
//
//  Created by Joshua Fisher on 12/30/15.
//  Copyright © 2015 Calendre Co. All rights reserved.
//

import UIKit

class TransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: NSTimeInterval
    var setUp: ((transitionContext: UIViewControllerContextTransitioning) -> Void)?
    var apply: ((transitionContext: UIViewControllerContextTransitioning) -> Void)?
    
    init(duration: NSTimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let finalize = { (_: Bool) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
        setUp?(transitionContext: transitionContext)
        
        if transitionContext.isAnimated() {
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                self.apply?(transitionContext: transitionContext)
                }, completion: { completed in
                    finalize(completed)
            })
        } else {
            apply?(transitionContext: transitionContext)
            finalize(true)
        }
    }
}