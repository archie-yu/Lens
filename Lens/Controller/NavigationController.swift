//
//  NavigationController.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/27.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    var startX: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationBar.backgroundColor = .white
        self.navigationBar.tintColor = Color.tint
        self.navigationBar.isTranslucent = false
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17)]
        self.navigationBar.shadowImage = UIImage() // UIImage.with(color: Color.barShadow)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem()
        super.pushViewController(viewController, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
