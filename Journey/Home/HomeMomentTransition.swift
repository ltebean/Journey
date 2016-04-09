//
//  InteractiveModelViewTransition.swift
//  Noah
//
//  Created by ltebean on 15/11/13.
//  Copyright © 2015年 Glow. All rights reserved.
//

import UIKit
import Async

public class HomeMomentTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    let transition = HomeMomentTransition()
    let reversedTransition = HomeMomentReversedTransition()
    var interactivePopTransition: UIPercentDrivenInteractiveTransition?
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return reversedTransition
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactivePopTransition
    }
}


public class HomeMomentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    weak var toVC: UIViewController?
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.7
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()!
        
        self.toVC = toVC
        let panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        if let vc = toVC as? UINavigationController {
            if !(vc.topViewController is UITableViewController) {
                vc.topViewController?.view.addGestureRecognizer(panGesture)
            }
        } else {
            if !(toVC is UITableViewController) {
                toVC.view.addGestureRecognizer(panGesture)
            }
        }
        
        let homeVC = fromVC as! HomeViewController
        let editorVC = toVC as! MomentEditorViewController
        
        let homeCards = homeVC.allMomentViews().map({ view -> UIView in
            return view.cardView
        })
        let currentMomentView = homeVC.currentMomentView()
        let homeViewsTofadeOut = [
            currentMomentView.titleLabel,
            currentMomentView.dateLabel,
            homeVC.menuButton
        ]

//        editorVC.view.layoutIfNeeded()
        editorVC.imageView.hidden = true
        editorVC.imageView.transform = CGAffineTransformMakeTranslation(0, -editorVC.imageViewTranslationY)
        editorVC.containerView.transform = CGAffineTransformMakeTranslation(0, editorVC.containerView.bounds.height)
        editorVC.photoButton.transform = editorVC.containerView.transform
        editorVC.closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 4))
        editorVC.imageView.hidden = false
        

        UIView.animateWithDuration(0.2,
            delay: 0,
            options: [],
            animations: {
                for card in homeCards {
                    card.transform = CGAffineTransformTranslate(card.transform, 0, 200)
                }
                for view in homeViewsTofadeOut {
                    view.alpha = 0
                }
            },
            completion: { finished in
                containerView.addSubview(editorVC.view)

                UIView.animateWithDuration(0.5,
                    delay: 0,
                    usingSpringWithDamping: 0.85,
                    initialSpringVelocity: 0,
                    options: [],
                    animations: {
                        editorVC.photoButton.transform = CGAffineTransformIdentity
                        editorVC.closeButton.transform = CGAffineTransformIdentity
                        editorVC.imageView.transform = CGAffineTransformIdentity
                        editorVC.containerView.transform = CGAffineTransformIdentity
                    },
                    completion: { finished in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    }
                )
            }
        )
        
    }
    
    public func handlePan(recognizer: UIPanGestureRecognizer) {
        let translationY = recognizer.translationInView(recognizer.view).y
        let progress = min(1.0, max(0.0, translationY / screenHeight))
        let transitionDelegate = toVC?.transitioningDelegate as! HomeMomentTransitionDelegate
        
        func begin() {
            transitionDelegate.interactivePopTransition = UIPercentDrivenInteractiveTransition()
            toVC?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        
        if recognizer.state == .Began {
            if translationY > 0 {
                begin()
            }
        }
            
        else if recognizer.state == .Changed {
            if translationY > 0 && transitionDelegate.interactivePopTransition == nil {
                begin()
            }
            transitionDelegate.interactivePopTransition?.updateInteractiveTransition(progress)
        }
            
        else if recognizer.state == .Ended || recognizer.state == .Cancelled
         {
            if progress >= 0.3 {
                transitionDelegate.interactivePopTransition?.finishInteractiveTransition()
            } else {
                transitionDelegate.interactivePopTransition?.cancelInteractiveTransition()
            }
            transitionDelegate.interactivePopTransition = nil
        }
    }
}


class HomeMomentReversedTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning {
    
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    let duration = 0.6
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        startInteractiveTransition(transitionContext)
    }
    
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let sourceView = fromVC.view
        let destinationView = toVC.view
        let containerView = transitionContext.containerView()!
        

        let homeVC = toVC as! HomeViewController
        let editorVC = fromVC as! MomentEditorViewController
        
        
        homeVC.addButton.hidden = true
        let homeCards = homeVC.allMomentViews().map({ view -> UIView in
            return view.cardView
        })
        let homeImageView = homeVC.currentMomentView().imageView
        
        let homeCardTranslationY = CGFloat(200)
        for card in homeCards {
            card.transform = CGAffineTransformTranslate(card.transform, 0, homeCardTranslationY)
        }
        homeImageView.transform = CGAffineTransformMakeTranslation(0, editorVC.imageViewTranslationY)
        
        let currentMomentView = homeVC.currentMomentView()
        let homeViewsTofadeIn = [
            currentMomentView.titleLabel,
            currentMomentView.dateLabel,
            homeVC.menuButton
        ]
        for view in homeViewsTofadeIn {
            view.alpha = 0
        }
        
        editorVC.imageView.hidden = true
        
        containerView.addSubview(destinationView)
        containerView.bringSubviewToFront(sourceView)
        UIView.animateWithDuration(duration,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                homeImageView.transform = CGAffineTransformIdentity
                editorVC.containerView.transform = CGAffineTransformMakeTranslation(0, editorVC.containerView.bounds.height)
                editorVC.photoButton.transform = editorVC.containerView.transform
                editorVC.photoButton.alpha = 0

                editorVC.closeButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 4))

                for card in homeCards {
                    card.transform = CGAffineTransformTranslate(card.transform, 0, -homeCardTranslationY)
                }
                for view in homeViewsTofadeIn {
                    view.alpha = 1
                }
            },
            completion: { finished in
                homeVC.addButton.hidden = false
                editorVC.imageView.hidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                self.transitionContext = nil
            }
        )
    }
}

