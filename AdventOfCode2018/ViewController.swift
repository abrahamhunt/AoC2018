//
//  ViewController.swift
//  AdventOfCode2018
//
//  Created by Abraham Hunt on 12/1/18.
//  Copyright © 2018 Abraham Hunt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dayOfAdvent = Calendar.current.dateComponents([.day], from: Date(timeIntervalSinceNow: 3600 * 2)).day!
        let range = dayOfAdvent ..< dayOfAdvent + 1
        // For all answers
//         let range = 1 ..< 26
        for i in range {
            let classString = NSStringFromClass(Day.self) + String(i)
            guard let newType = NSClassFromString(classString) as? Day.Type else {
                print("No type available for Day \(i)")
                continue
            }
            print(newType.init())
        }
    }

}

