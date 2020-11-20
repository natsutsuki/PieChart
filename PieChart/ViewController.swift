//
//  ViewController.swift
//  PieChart
//
//  Created by c.c on 2020/11/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        let pieView = LYCirclePieView(frame: CGRect(x: 0, y: 0, width: 330, height: 270))
        pieView.pieVisual = LYPieVisual.demo
        
        pieView.backgroundColor = UIColor.systemBackground
        
        pieView.center = view.center
        view.addSubview(pieView)
    }


}

