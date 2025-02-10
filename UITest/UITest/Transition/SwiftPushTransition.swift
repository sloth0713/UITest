//
//  SwiftPushTransition.swift
//  UITest
//
//  Created by ByteDance on 2025/2/8.
//

import Foundation
import UIKit

@objc
public class SwiftPushTransition: NSObject {

    @MainActor @objc
    public func animateTransitionPropertyAnimator(transitionContext:UIViewControllerContextTransitioning) {
        
        guard         let toVC = transitionContext.viewController(forKey: .to),
                          let fromVC = transitionContext.viewController(forKey: .from) else {
            // 如果对象为 nil，提前退出函数或作用域
            return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        containerView.addSubview(toVC.view)
        
        // 设置目标视图的初始frame
        let screenBounds = UIScreen.main.bounds
        //右移tovc
        let initialFrame = CGRectOffset(finalFrame, screenBounds.width, 0)
        toVC.view.frame = initialFrame
        

        let stiffness: CGFloat = 100
        let dampingRatio: CGFloat = 0.5

        let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: UISpringTimingParameters(dampingRatio: dampingRatio, initialVelocity: CGVector(dx: 0, dy: 0)))
        // 添加动画效果
        animator.addAnimations {
            fromVC.view.frame = CGRectOffset(fromVC.view.frame, -screenBounds.size.width, 0);// 将当前视图向左移动一半的距离，这样fromvc和toVC一起配合移动。注释掉这行，fromvc不动，相当于tovc覆盖过去
            toVC.view.frame = finalFrame // 将目标视图移动到最终frame
        }

        animator.addCompletion { position in
            transitionContext.completeTransition(true)
        }
        animator.startAnimation()
    }
    
    @objc
    static public func animateTransitionPropertyAnimator() {
        print("dfas")
    }
}

