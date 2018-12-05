//
//  Day5.swift
//  AdventOfCode2018
//
//  Created by Abraham Hunt on 12/2/18.
//  Copyright © 2018 Abraham Hunt. All rights reserved.
//

import Foundation

class Day5: Day {
    
    override func prepareSampleInputs() {
        partOneSampleInputs = [["dabAcCaCBAcCcaDA"]]
        partTwoSampleInputs = partOneSampleInputs
    }
    
    override func solvePartOne(_ inputs: [String]) -> String {
        for input in inputs {
            return String(input.removeReactions().count)
        }
        return "Nothing yet"
    }
    
    override func solvePartTwo(_ inputs: [String]) -> String {
        for input in inputs {
            NSLog("Start part two")
            var shortest = input.count
            for letter in String.alphabet {
                let filteredInput = input.replacingOccurrences(of: letter, with: "", options: .caseInsensitive, range: input.startIndex ..< input.endIndex)
                shortest = min(filteredInput.removeReactions().count, shortest)
            }
            NSLog("End part two")
            NSLog("Start part two more optimally")
            var shortestMoreOptimally = input.count
            for letter in String.alphabet {
                let filteredInput = input.replacingOccurrences(of: letter, with: "", options: .caseInsensitive, range: input.startIndex ..< input.endIndex)
                shortestMoreOptimally = min(filteredInput.removeReactionsMoreOptimally(), shortestMoreOptimally)
            }
            NSLog("End part two more optimally: \(shortestMoreOptimally)")
            return String("shortest: \(shortestMoreOptimally)")
        }
        return ""
    }
}

extension String {
    
    static let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    func removeReactions() -> String {
        // return a string with first set of reactions removed
        var lowerIndex = self.startIndex
        var upperIndex = index(after: lowerIndex)
        var reactiveString = self
        while upperIndex < reactiveString.endIndex {
            let lowerChar = reactiveString[lowerIndex]
            let upperChar = reactiveString[upperIndex]
            if upperChar == lowerChar || String(upperChar).lowercased() != String(lowerChar).lowercased() {
                // no reaction
                lowerIndex = upperIndex
            } else {
                // reaction
                reactiveString.remove(at: upperIndex)
                reactiveString.remove(at: lowerIndex)
                if lowerIndex == reactiveString.startIndex {
                    lowerIndex = reactiveString.startIndex
                } else {
                    lowerIndex = index(before: lowerIndex)
                }
            }
            upperIndex = index(after: lowerIndex)
        }
        return reactiveString
    }
    
    func removeReactionsMoreOptimally() -> Int {
        // return a string with first set of reactions removed
        var lowerIndex = self.startIndex
        var upperIndex = index(after: lowerIndex)
        var indices = [String.Index]()
        while upperIndex < self.endIndex {
            let lowerChar = self[lowerIndex]
            let upperChar = self[upperIndex]
            if upperChar == lowerChar || (upperChar.unicodeScalars.first!.value - 65) % 32 != (lowerChar.unicodeScalars.first!.value - 65) % 32 {
                // no reaction
                indices.append(lowerIndex)
                lowerIndex = upperIndex
                upperIndex = index(after: lowerIndex)
            } else {
                if indices.last == lowerIndex {
                    indices.removeLast()
                }
                if let lastGoodIndex = indices.popLast() {
                    lowerIndex = lastGoodIndex
                    upperIndex = index(after: upperIndex)
                } else {
                    lowerIndex = index(after: upperIndex)
                    upperIndex = index(after: lowerIndex)
                }
            }
        }
        indices.append(lowerIndex)
        return indices.count
    }

}
