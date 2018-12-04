//
//  Day1.swift
//  AdventOfCode2018
//
//  Created by Abraham Hunt on 12/1/18.
//  Copyright © 2018 Abraham Hunt. All rights reserved.
//

import Foundation

class Day {
    
    let dayOfMonth: Int
    var partOneSampleInputs: [[String]]?
    var partTwoSampleInputs: [[String]]?
    
    required init() {
        let dayString = NSStringFromClass(type(of: self)).components(separatedBy: "Day").last
        dayOfMonth = Int(dayString!)!
        prepareSampleInputs()
        guard let inputURL = Bundle.main.url(forResource: "Day\(dayOfMonth)", withExtension: "txt"), let string = try? String(contentsOf: inputURL, encoding: .utf8) else {
            print("Input for Day \(dayOfMonth) isn't ready")
            return
        }
        solve(string)
    }
    
    func prepareSampleInputs() {}
    
    func solve(_ input: String) {
        let cleanInput = clean(input)
        let inputArray = cleanInput.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
        solveProblem(inputArray)
    }
    
    func solveProblem(_ inputs: [String]) {
        if let partOneSampleInputs = partOneSampleInputs {
            for (idx, sampleInput) in partOneSampleInputs.enumerated() {
                print("Day \(dayOfMonth), Part I Sample \(idx): \(solvePartOne(sampleInput))")
            }
        }
        print("Day \(dayOfMonth), Part I: \(solvePartOne(inputs))")
        if let partTwoSampleInputs = partTwoSampleInputs {
            for (idx, sampleInput) in partTwoSampleInputs.enumerated() {
                print ("Day \(dayOfMonth), Part II Sample \(idx): \(solvePartTwo(sampleInput))")
            }
        }
        print("Day \(dayOfMonth), Part II: \(solvePartTwo(inputs))")
    }
    
    func solvePartOne(_ inputs: [String]) -> String {
        return "Day \(dayOfMonth) Part One isn't implemented yet"
    }
    
    func solvePartTwo(_ inputs: [String]) -> String {
        return "Day \(dayOfMonth) Part Two isn't implemented yet"
    }
    
    func clean(_ input: String) -> String {
        return input
    }
    
    func integerInputs(_ inputs: [String]) -> [Int] {
        return inputs.compactMap({Int($0)})
    }
}

class Day1: Day {
    
    let partTwoSample = [[1,-1], [3,3,4,-2,-4], [-6, 3, 8, 5, -6], [7, 7, -2, -7, -4]]
        
    override func prepareSampleInputs() {
        partTwoSampleInputs = partTwoSample.map({$0.map({String($0)})})
    }
    
    override func solvePartOne(_ inputs: [String]) -> String {
        return String(integerInputs(inputs).reduce(0, +))
    }
    
    override func solvePartTwo(_ inputs: [String]) -> String {
        let inputs = integerInputs(inputs)
        var frequency = 0
        var reachedFrequencies = Set<Int>()
        reachedFrequencies.insert(0)
        var repeatedFrequency: Int?
        while repeatedFrequency == nil {
            for adjustment in inputs {
                frequency += adjustment
                if reachedFrequencies.contains(frequency) {
                    repeatedFrequency = frequency
                    break
                }
                reachedFrequencies.insert(frequency)
            }
        }
        return String(repeatedFrequency!)
    }
}
