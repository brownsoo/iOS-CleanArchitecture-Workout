//
//  Scheduler.swift
//  App
//
//  Created by hyonsoo on 2023/08/29.
//

import Foundation

final class Scheduler {
    static var backgroundSchduler: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        queue.qualityOfService = .userInitiated
        return queue
    }()
    
    static var masinScheduler = RunLoop.main
}
