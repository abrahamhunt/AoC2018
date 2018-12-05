//
//  Day2.swift
//  AdventOfCode2018
//
//  Created by Abraham Hunt on 12/2/18.
//  Copyright © 2018 Abraham Hunt. All rights reserved.
//

import Foundation

class Day2: Day {

    override func prepareSampleInputs() {
        partOneSampleInputs = [["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"]]
        partTwoSampleInputs = [["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"]]
    }
    
    struct UniqueCounter {
        var twoOfAKind: Bool = false
        var threeOfAKind: Bool = false
    }
        
    override func solvePartOne(_ inputs: [String]) -> String {
        var twoLetterCount = 0
        var threeLetterCount = 0
        for string in inputs {
            let counter = checkString(input: string)
            twoLetterCount += counter.twoOfAKind ? 1 : 0
            threeLetterCount += counter.threeOfAKind ? 1 : 0
        }
        return String(twoLetterCount * threeLetterCount)
    }
    
    func checkString(input: String) -> UniqueCounter {
        let countedSet = NSCountedSet()
        for character in input {
            countedSet.add(character)
        }
        var counter = UniqueCounter()
        for character in countedSet.objectEnumerator() {
            if countedSet.count(for: character) == 2 {
                counter.twoOfAKind = true
            }
            if countedSet.count(for: character) == 3 {
                counter.threeOfAKind = true
            }
            if counter.twoOfAKind && counter.threeOfAKind {
                break
            }
        }
        return counter
    }
    
    override func solvePartTwo(_ inputs: [String]) -> String {
        for i in 0 ..< inputs.count {
            let checkString = inputs[i]
            for j in i ..< inputs.count {
                let otherString = inputs[j]
                let charactersInCommon = checkString.sameCharacters(otherString)
                if charactersInCommon.count + 1 == checkString.count {
                    return charactersInCommon
                }
            }
        }
        return "Answer not found"
    }
    
}

extension String {

    func sameCharacters(_ string: String) -> String {
        var diffCount = 0
        var result = ""
        for (i, j) in zip(self, string) where diffCount < 2 {
            if i != j { diffCount += 1} else { result.append(i) }
        }
        return diffCount < 2 ? result : ""
    }
    
}
