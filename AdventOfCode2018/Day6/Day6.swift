//
//  Day6.swift
//  AdventOfCode2018
//
//  Created by Abraham Hunt on 12/2/18.
//  Copyright © 2018 Abraham Hunt. All rights reserved.
//

import Foundation

class Day6: Day {
    
    struct Distance: Comparable {
        static func < (lhs: Day6.Distance, rhs: Day6.Distance) -> Bool {
            return lhs.distance < rhs.distance
        }
        static func == (lhs: Day6.Distance, rhs: Day6.Distance) -> Bool {
            return lhs.distance == rhs.distance
        }
        let coordId: Int
        let distance: Int
    }
    
    struct Coordinate {
        let id: Int
        let x: Int
        let y: Int
        
        init(_ input: String, index: Int) {
            let components = input.components(separatedBy: ", ")
            x = Int(components[0])!
            y = Int(components[1])!
            id = index
        }
        
        func distanceFrom(x: Int, y: Int) -> Distance {
            let distance = abs(self.x - x) + abs(self.y - y)
            return Distance(coordId: id, distance: distance)
        }
        
    }
    
    struct Grid {
        
        static let undetermined = -1
        
        let x: Int
        let y: Int
        let width: Int
        let height: Int
        let gridPoints: [Distance]
        let coordinates: [Coordinate]
        let totalDistances: [Int]
        
        init(minX: Int, minY: Int, maxX: Int, maxY: Int, coordinates: [Coordinate]) {
            x = minX
            y = minY
            width = maxX - minX + 1
            height = maxY - minY + 1
            var gridPoints = [Distance](repeating: Distance(coordId: Grid.undetermined, distance: Int.max), count: width * height)
            var totalDistances = [Int](repeating: 0, count: width * height)
            for coordinate in coordinates {
                for i in 0 ..< gridPoints.count {
                    let gridX = i % width + x
                    let gridY = i / width + y
                    let distance = coordinate.distanceFrom(x: gridX, y: gridY)
                    let currentDistance = gridPoints[i]
                    if distance == currentDistance {
                        gridPoints[i] = Distance(coordId: Grid.undetermined, distance: distance.distance)
                    } else {
                        gridPoints[i] = min(currentDistance, distance)
                    }
                    totalDistances[i] = totalDistances[i] + distance.distance
                }
            }
            self.gridPoints = gridPoints
            self.coordinates = coordinates
            self.totalDistances = totalDistances
        }
        
        func isUnbounded(x: Int, y: Int) -> Bool {
            if x == self.x || y == self.y {
                return true
            }
            if x == width || y == height {
                return true
            }
            return false
        }
        
        func maxArea() -> Int {
            let unbounded = -2
            var maxAreas = [Int](repeating: 0, count: coordinates.count)
            for (idx, distance) in gridPoints.enumerated() {
                let gridX = idx % width + x
                let gridY = idx / width + y
                let coordIndex = distance.coordId
                if coordIndex == Grid.undetermined {
                    // none were closest, continue
                    continue
                }
                let currentAreaCount = maxAreas[coordIndex]
                if currentAreaCount == unbounded {
                    continue
                }
                if isUnbounded(x: gridX, y: gridY) {
                    maxAreas[coordIndex] = unbounded
                } else {
                    maxAreas[coordIndex] = currentAreaCount + 1
                }
            }
            return maxAreas.sorted().last!
        }
        
        func maxSafeArea(maxDistance: Int) -> Int {
            return totalDistances.filter({ $0 < maxDistance }).count
        }
        
    }
    
    override func prepareSampleInputs() {
        partOneSampleInputs = [["1, 1", "1, 6", "8, 3", "3, 4", "5, 5", "8, 9"]]
        partTwoSampleInputs = partOneSampleInputs
    }
    
    func buildGrid(_ inputs: [String]) -> Grid {
        var maxX = 0
        var maxY = 0
        var minX = Int.max
        var minY = Int.max
        var coordinates = [Coordinate](repeating: Coordinate("0, 0", index: 0), count: inputs.count)
        for (idx, input) in inputs.enumerated() {
            let coordinate = Coordinate(input, index: idx)
            coordinates[idx] = coordinate
            maxX = max(coordinate.x, maxX)
            maxY = max(coordinate.y, maxY)
            minX = min(coordinate.x, minX)
            minY = min(coordinate.y, minY)
        }
        return Grid(minX: minX, minY: minY, maxX: maxX, maxY: maxY, coordinates: coordinates)
    }
    
    override func solvePartOne(_ inputs: [String]) -> String {
        return String(buildGrid(inputs).maxArea())
    }
    
    override func solvePartTwo(_ inputs: [String]) -> String {
        let grid = buildGrid(inputs)
        let maxSafeArea = grid.maxSafeArea(maxDistance: inputs.count < 20 ? 32 : 10000)
        return String(maxSafeArea)
    }
}
