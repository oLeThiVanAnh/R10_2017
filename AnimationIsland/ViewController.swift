//
//  ViewController.swift
//  AnimationIsland
//
//  Created by Administrator on 2/9/17.
//  Copyright © 2017 Le Thi Van Anh. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    var scene: AnimationScene!
    var size: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        size = self.view.frame.size
        scene = AnimationScene(size: size)

        let skView = self.view as! SKView
        skView.presentScene(scene)
    }
}
