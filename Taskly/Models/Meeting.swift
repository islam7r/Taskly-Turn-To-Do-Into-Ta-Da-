//
//  Meeting.swift
//  Taskly
//
//  Created by Islam Rzayev on 04.12.24.
//

import Foundation
import FirebaseFirestore

struct Meeting: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var userId: String
    var title: String
    var description: String
    var deadline: Date
    var time: Date
    var currentDate: Date?
    var selectedIcon: String?
    var isFinished: Bool = false
    
}
