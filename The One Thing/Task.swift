//
//  Task.swift
//  The One Thing
//
//  Created by ZHIWEN HUANG on 7/10/25.
//

import Foundation
import SwiftData

@Model
final class Task {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var completedAt: Date?
    var priority: Int
    
    init(title: String, priority: Int = 0) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.createdAt = Date()
        self.completedAt = nil
        self.priority = priority
    }
    
    func complete() {
        self.isCompleted = true
        self.completedAt = Date()
    }
}
