//
//  DailyTasks.swift
//  Taskly
//
//  Created by Islam Rzayev on 05.12.24.
//

import Foundation
import FirebaseFirestore

struct DailyTasks: Codable, Identifiable {
    @DocumentID var id: String?
    var userId: String
    var title: String
    var description: String
    var isFinished: Bool = false
}
