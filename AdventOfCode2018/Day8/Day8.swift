//
//  Day8.swift
//  AdventOfCode2018
//
//  Created by Abraham Hunt on 12/2/18.
//  Copyright © 2018 Abraham Hunt. All rights reserved.
//

import Foundation

class Day8: Day {
    
    class Node {
        let index: Int
        var numberOfChildren: Int
        var numberOfMetadata: Int
        var children = [Node]()
        var metadata = [Int]()
        weak var parentNode: Node?
        
        init(index: Int, numberOfChildren: Int, numberOfMetadata: Int, parentNode: Node?) {
            self.index = index
            self.numberOfChildren = numberOfChildren
            self.numberOfMetadata = numberOfMetadata
            self.parentNode = parentNode
        }
        
        var sumOfMetadata: Int {
            return metadata.reduce(0, +) + children.map({$0.sumOfMetadata}).reduce(0, +)
        }
        
        var sumOfReferences: Int {
            if children.isEmpty {
                return sumOfMetadata
            }
            var sum = 0
            for reference in metadata {
                let adjustedReference = reference - 1
                if adjustedReference < children.count {
                    let child = children[adjustedReference]
                    sum += child.sumOfReferences
                }
            }
            return sum
        }
    }
    
    override func prepareSampleInputs() {
        partOneSampleInputs = [["2", "3", "0", "3", "10", "11", "12", "1", "1", "0", "1", "99", "2", "1", "1", "2"]]
        partTwoSampleInputs = partOneSampleInputs
    }
    
    func buildTree(_ inputs: [String]) -> Node {
        let intInputs: [Int]
        if inputs.count == 1 {
            let stringInputs = inputs.first!.components(separatedBy: .whitespaces)
            intInputs = stringInputs.map({Int($0)!})
        } else {
            intInputs = inputs.map({Int($0)!})
        }
        let rootNode = Node(index: 0, numberOfChildren: intInputs[0], numberOfMetadata: intInputs[1], parentNode: nil)
        var currentNode = rootNode
        // Collect all the nodes as we pass since we start with the parent relationship and it is weak
        var allNodes = [currentNode]
        var index = 2
        while index < intInputs.count {
            if currentNode.children.count < currentNode.numberOfChildren {
                // Go down to child
                let child = Node(index: index, numberOfChildren: intInputs[index], numberOfMetadata: intInputs[index + 1], parentNode: currentNode)
                allNodes.append(child)
                index += 2
                currentNode = child
            } else if currentNode.metadata.count < currentNode.numberOfMetadata {
                // Close out node with metadata
                let offset = currentNode.numberOfMetadata
                let metadata = Array(intInputs[index ..< index + offset])
                currentNode.metadata = metadata
                index += offset
                if let parent = currentNode.parentNode {
                    parent.children.append(currentNode)
                    currentNode = parent
                }
            } else {
                currentNode = Node(index: index, numberOfChildren: intInputs[index], numberOfMetadata: intInputs[index + 1], parentNode: nil)
                allNodes.append(currentNode)
                index += 2
            }
        }
        return rootNode
    }
    
    
    override func solvePartOne(_ inputs: [String]) -> String {
        let node = buildTree(inputs)
        return String(node.sumOfMetadata)
    }
    
    override func solvePartTwo(_ inputs: [String]) -> String {
        let node = buildTree(inputs)
        return String(node.sumOfReferences)
    }
}
