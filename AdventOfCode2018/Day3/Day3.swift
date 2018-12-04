//
//  Day3.swift
//  AdventOfCode2018
//
//  Created by Abraham Hunt on 12/2/18.
//  Copyright © 2018 Abraham Hunt. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    static func rectFromAdventString(_ string: String) -> (Int, CGRect) {
        let characterSet = CharacterSet.decimalDigits.inverted
        var components = string.components(separatedBy: characterSet)
        components.removeAll(where: { $0.isEmpty })
        guard components.count == 5 else {
            print("Input doesn't match format")
            return (0, .zero)
        }
        let id: Int = Int(components[0])!
        let x: Int = Int(components[1])!
        let y: Int = Int(components[2])!
        let width: Int = Int(components[3])!
        let height: Int = Int(components[4])!
        let rect = CGRect(x: x, y: y, width: width, height: height)
        return (id, rect)
    }
}

class Day3: Day {
    
    override func prepareSampleInputs() {
        partOneSampleInputs = [["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"]]
        partTwoSampleInputs = partOneSampleInputs
    }
    
    override func solvePartOne(_ inputs: [String]) -> String {
        // Build rects out of the inputs
        let claims = inputs.map({ CGRect.rectFromAdventString($0) })
        let rects = claims.map({ $0.1 })
        var xSize: CGFloat = 0
        var ySize: CGFloat = 0
        for rect in rects {
            xSize = max(xSize, rect.maxX)
            ySize = max(ySize, rect.maxY)
        }
        var massiveArray: [Int] = Array(repeating: 0, count: Int(xSize * ySize))
        for rect in rects {
            // find each index and increment the massive array
            let x = Int(rect.minX)
            let y = Int(rect.minY)
            for i in 0 ..< Int(rect.width) {
                for j in 0 ..< Int(rect.height) {
                    let index = Int((x+i) + (y+j) * Int(xSize))
                    massiveArray[index] = massiveArray[index] + 1
                }
            }
        }
        
        let repeats = massiveArray.filter({ $0 > 1})
        return "\(repeats.count)"
    }
    
    override func solvePartTwo(_ inputs: [String]) -> String {
        let claims = inputs.map({ CGRect.rectFromAdventString($0) })
        for i in 0 ..< claims.count {
            let checkClaim = claims[i]
            var foundIntersection = false
            for j in 0 ..< claims.count {
                guard i != j else { continue }
                let secondClaim = claims[j]
                if checkClaim.1.intersects(secondClaim.1) {
                    foundIntersection = true
                    break
                }
            }
            if foundIntersection == false {
                return String(checkClaim.0)
            }
        }
        return "Unable to find independant claim"
    }
}
