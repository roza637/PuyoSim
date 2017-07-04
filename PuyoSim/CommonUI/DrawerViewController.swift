//
//  DrawerViewController.swift
//  PuyoSim
//
//  Created by roza on 2016/11/14.
//  Copyright © 2016年 roza All rights reserved.
//

import UIKit

//TODO: α版のドロワー用仮画面
final class DrawerViewController: UIViewController, StoryboardInstantiatable, DrawerPresentable {
    
    static func getInstance() -> DrawerViewController {
        return DrawerViewController.instantiate()
    }

    @IBOutlet weak var drawerView: UIView!
    @IBOutlet weak var backgroundView: UIView!

    var drawerGravity: DrawerGravity {
        return DrawerGravity.right
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
