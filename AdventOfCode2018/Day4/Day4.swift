//
//  Day4.swift
//  AdventOfCode2018
//
//  Created by Abraham Hunt on 12/2/18.
//  Copyright © 2018 Abraham Hunt. All rights reserved.
//

import Foundation

class Day4: Day {
    
    struct Sleepiness {
        let minute: Int
        let frequency: Int
        let watchmanId: String
    }
    
    struct Watchman {
        let id: String
        var asleepMinutes: [Int]
        var totalMinutesAsleep: Int
        
        func maximumSleepiness() -> Sleepiness {
            var indexOfMax = 0
            var timesAsleep = 0
            for (idx, minutes) in asleepMinutes.enumerated() {
                if minutes > timesAsleep {
                    timesAsleep = minutes
                    indexOfMax = idx
                }
            }
            return Sleepiness(minute: indexOfMax, frequency: timesAsleep, watchmanId: id)
        }
    }
    
    struct LogEntry {
        let date: Date
        let action: GuardAction
        let minute: Int
    }
    
    enum GuardAction {
        case start(guardId: String)
        case fellAsleep
        case wokeUp
    }
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    override func prepareSampleInputs() {
        partOneSampleInputs = [["[1518-11-01 00:00] Guard #10 begins shift", "[1518-11-01 00:05] falls asleep", "[1518-11-01 00:25] wakes up", "[1518-11-01 00:30] falls asleep",  "[1518-11-01 00:55] wakes up", "[1518-11-01 23:58] Guard #99 begins shift", "[1518-11-02 00:40] falls asleep", "[1518-11-02 00:50] wakes up", "[1518-11-03 00:05] Guard #10 begins shift", "[1518-11-03 00:24] falls asleep", "[1518-11-03 00:29] wakes up", "[1518-11-04 00:02] Guard #99 begins shift", "[1518-11-04 00:36] falls asleep", "[1518-11-04 00:46] wakes up", "[1518-11-05 00:03] Guard #99 begins shift", "[1518-11-05 00:45] falls asleep", "[1518-11-05 00:55] wakes up"]]
        partTwoSampleInputs = partOneSampleInputs
    }
    
    func watchmenFromInputs(_ inputs:[String]) -> [Watchman] {
        var watchmen = [String: Watchman]()
        var logs = [LogEntry]()
        for input in inputs {
            let components = input.components(separatedBy: "] ")
            let dateString = components[0].dropFirst()
            let date = Day4.dateFormatter.date(from: String(dateString))!
            let timeComponents = dateString.components(separatedBy: ":")
            let minutes = Int(timeComponents[1])!
            let actionString = components[1]
            if actionString.hasPrefix("Guard") {
                let guardID = actionString.trimmingCharacters(in: NSCharacterSet.decimalDigits.inverted)
                logs.append(LogEntry(date: date, action: .start(guardId: guardID), minute: minutes))
                if watchmen[guardID] == nil {
                    watchmen[guardID] = Watchman(id: guardID, asleepMinutes: Array(repeating: 0, count: 60), totalMinutesAsleep: 0)
                }
            } else if actionString.hasPrefix("falls") {
                logs.append(LogEntry(date: date, action: .fellAsleep, minute: minutes))
            } else {
                logs.append(LogEntry(date: date, action: .wokeUp, minute: minutes))
            }
        }
        logs.sort(by: { $0.date < $1.date })
        var watchman: Watchman!
        var sleepMinute = 0
        for log in logs {
            switch log.action {
            case .start(let guardId):
                if let previousWatchman = watchman {
                    watchmen[previousWatchman.id] = previousWatchman
                }
                watchman = watchmen[guardId]
            case .fellAsleep:
                sleepMinute = log.minute
            case .wokeUp:
                for i in sleepMinute ..< log.minute {
                    watchman.asleepMinutes[i] = watchman.asleepMinutes[i] + 1
                    watchman.totalMinutesAsleep += 1
                }
            }
        }
        watchmen[watchman.id] = watchman
        return Array(watchmen.values)
    }
    
    override func solvePartOne(_ inputs: [String]) -> String {
        let watchmen = watchmenFromInputs(inputs)
        let sortedWatcmen = watchmen.sorted(by: { $0.totalMinutesAsleep > $1.totalMinutesAsleep })
        let mostSleepy = sortedWatcmen[0]
        let maxSleepiness = mostSleepy.maximumSleepiness()
        let answer = Int(mostSleepy.id)! * maxSleepiness.minute
        return "\(answer)"
    }
    
    override func solvePartTwo(_ inputs: [String]) -> String {
        let watchmen = watchmenFromInputs(inputs)
        let sleepiness = watchmen.map({$0.maximumSleepiness()})
        let sortedSleepiness = sleepiness.sorted(by: {$0.frequency > $1.frequency })
        let consistentSleeper = sortedSleepiness.first!
        let answer = consistentSleeper.minute * Int(consistentSleeper.watchmanId)!
        return "\(answer)"
    }
}
