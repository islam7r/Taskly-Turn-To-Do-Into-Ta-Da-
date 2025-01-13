//
//  DailyTaskViewModel.swift
//  Taskly
//
//  Created by Islam Rzayev on 14.12.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DailyTaskViewModel: ObservableObject {
    @Published var tasks: [DailyTasks] = []
    @Published var completedTaskCount: [String] = []
    
    
    private let db = Firestore.firestore()
    
    
    func addTask(title: String, description: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: No logged-in user.")
            return
        }
        
        let newTask = DailyTasks(userId: userId, title: title, description: description)
        
        do {
            try db.collection("dailyTasks").addDocument(from: newTask)
            print("Task added successfully!")
        } catch {
            print("Error adding task: \(error.localizedDescription)")
        }
    }
    
    func fetchTasks() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: No logged-in user.")
            return
        }
        
        db.collection("dailyTasks")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching tasks: \(error.localizedDescription)")
                    return
                }
                
                self.tasks = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: DailyTasks.self)
                } ?? []
            }
    }
    func deletetask(taskId: String) {
        db.collection("dailyTasks").document(taskId).delete { error in
            if let error = error {
                print("Error deleting task: \(error.localizedDescription)")
            } else {
                print("Task deleted successfully!")
                
               
            }
        }
    }
    

    
   
    func toggleTaskCompletion(task: DailyTasks) {
        guard let taskId = task.id else { return }
        
        let updatedIsFinished = !task.isFinished
        
        db.collection("dailyTasks").document(taskId).updateData([
            "isFinished": updatedIsFinished
        ]) { error in
            if let error = error {
                print("Error updating task: \(error.localizedDescription)")
            } else {
                print("Task completion updated successfully!")
            }
        }
    }
}
