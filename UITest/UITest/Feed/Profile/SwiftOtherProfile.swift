//
//  SwiftOtherProfile.swift
//  UITest
//
//  Created by ByteDance on 2025/5/13.
//

import Foundation
import UIKit

@objc
public class SwiftOtherProfile:UIViewController {
    public override func viewDidLoad() {
        self.view.frame = CGRectMake(0, 0, self.navigationController?.view.frame.width ?? 100, self.navigationController?.view.frame.height ?? 100)
//        (x: 0, y: 0, width: self.navigationController?.view.frame.width!, height: self.navigationController?.view.frame.height!)
        self.view.backgroundColor = UIColor.green
        
        if #available(iOS 18.0, *) {
            
            let options = UIViewController.Transition.ZoomOptions()
            
            self.preferredTransition = .zoom(sourceViewProvider: { context in
                return context.sourceViewController.view
            })

        }
        
    }
}
