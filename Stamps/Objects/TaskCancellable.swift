//
//  TaskCancellable.swift
//  Outline
//
//  Created by James Zingel on 30/11/23.
//

import Foundation

@resultBuilder
struct TaskBuilder {
    static func buildBlock(_ components:  Task<(), Never>...) -> [ Task<(), Never>] {
        return components
    }
}

/// Run a task that will terminate if the main objected is deinited
class TaskCancellable {
    var tasks: [Task<(), Never>] = []
    
    func addTask(@TaskBuilder _ tasks: () -> [Task<(), Never>]) {
        let builtTasks = tasks()
        
        self.tasks.append(contentsOf: builtTasks)
    }
    
    deinit {
        self.tasks.forEach { task in
            task.cancel()
        }
    }
}
