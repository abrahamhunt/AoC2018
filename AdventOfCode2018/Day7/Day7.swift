//
//  Day7.swift
//  AdventOfCode2018
//
//  Created by Abraham Hunt on 12/2/18.
//  Copyright © 2018 Abraham Hunt. All rights reserved.
//

import Foundation

class Day7: Day {
    
    class Step: NSObject {
        
        static func == (lhs: Day7.Step, rhs: Day7.Step) -> Bool {
            return lhs.name == rhs.name
        }
        
        let name: String
        var parents = Set<Step>()
        var timeToComplete = 60
        var inProgress = false
        
        init(name: String) {
            self.name = name
            let lowerName = name.lowercased()
            timeToComplete += String.alphabet.firstIndex(of: lowerName)! + 1
        }
        
    }
    
    override func prepareSampleInputs() {
        partOneSampleInputs = [["Step C must be finished before step A can begin.",
            "Step C must be finished before step F can begin.",
            "Step A must be finished before step B can begin.",
            "Step A must be finished before step D can begin.",
            "Step B must be finished before step E can begin.",
            "Step D must be finished before step E can begin.",
            "Step F must be finished before step E can begin."]]
        partTwoSampleInputs = partOneSampleInputs
    }
    
    func stepsFromInputs(_ inputs: [String]) -> [String: Step] {
        var steps = [String: Step]()
        for input in inputs {
            let stepLetters = input.components(separatedBy: .whitespacesAndNewlines).filter({$0.count == 1})
            let parentLetter = stepLetters[0]
            let parentStep = steps[parentLetter] ?? Step(name: parentLetter)
            let childLetter = stepLetters[1]
            let childStep = steps[childLetter] ?? Step(name: childLetter)
            childStep.parents.insert(parentStep)
            steps[parentLetter] = parentStep
            steps[childLetter] = childStep
        }
        return steps
    }
    
    override func solvePartOne(_ inputs: [String]) -> String {
        var steps = stepsFromInputs(inputs)
        
        var stepsTaken = ""
        
        while steps.count > 0 {
            let stepToTake = steps.values.filter({$0.parents.count == 0}).sorted(by: { $0.name < $1.name }).first!
            stepsTaken += stepToTake.name
            steps[stepToTake.name] = nil
            steps.values.forEach({$0.parents.remove(stepToTake)})
        }
        
        return stepsTaken
    }
    
    override func solvePartTwo(_ inputs: [String]) -> String {
        var steps = stepsFromInputs(inputs)
        
        var stepsTaken = ""
        var timeTaken = 0
        
        while steps.count > 0 {
            let availableWorkers = 5
            let availableSteps = steps.values.filter({$0.parents.count == 0}).sorted(by: {
                if $0.inProgress {
                    return true
                } else if $1.inProgress {
                    return false
                }
                return $0.name < $1.name
            })
            let stepsToWorkOn = availableSteps[..<min(availableWorkers, availableSteps.count)]
            let nextToComplete = stepsToWorkOn.min(by: {$0.timeToComplete <= $1.timeToComplete})!
            let nextTimeToComplete = nextToComplete.timeToComplete
            timeTaken += nextTimeToComplete
            stepsTaken += nextToComplete.name
            steps[nextToComplete.name] = nil
            stepsToWorkOn.forEach({
                $0.timeToComplete -= nextTimeToComplete
                $0.inProgress = true
            })
            steps.values.forEach({$0.parents.remove(nextToComplete)})
        }
        
        return "Finished \(stepsTaken) in \(timeTaken)"
    }
}
