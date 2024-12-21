//
//  MeetingsViewModel.swift
//  Taskly
//
//  Created by Islam Rzayev on 14.12.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class MeetingViewModel: ObservableObject {
    @Published var meetings: [Meeting] = []
   
    
    private let db = Firestore.firestore()
    
    // Add a new meeting to Firestore
    func addMeeting(title: String, description: String, deadline: Date, time: Date) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: No logged-in user.")
            return
        }
        
        let newMeeting = Meeting(userId: userId, title: title, description: description, deadline: deadline, time: time)
       
        
        do {
            let _ = try db.collection("meetings").addDocument(from: newMeeting) { error in
                if let error = error {
                    print("Error adding meeting: \(error.localizedDescription)")
                } else {
                    print("Meeting added successfully!")
                    self.fetchMeetings()
                }
            }
        } catch {
            print("Error adding meeting: \(error.localizedDescription)")
        }
    }
    
    // Fetch meetings in real-time
    func fetchMeetings() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: No logged-in user.")
            return
        }
        
        db.collection("meetings")
            .whereField("userId", isEqualTo: userId) // Fetch meetings only for the logged-in user
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching meetings: \(error.localizedDescription)")
                    return
                }
                
                self.meetings = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Meeting.self)
                } ?? []
            }
    }
    // Delete meeting
    func deleteMeeting(meetingId: String, completion: @escaping () -> Void) {
        db.collection("meetings").document(meetingId).delete { error in
            if let error = error {
                print("Error deleting meeting: \(error.localizedDescription)")
            } else {
                print("Meeting deleted successfully!")
                completion()
            }
        }
    }
    
    // Toggle the meeting's isFinished state
    func toggleMeetingCompletion(meeting: Meeting) {
        guard let meetingId = meeting.id else { return }
        
        let updatedIsFinished = !meeting.isFinished
        
        db.collection("meetings").document(meetingId).updateData([
            "isFinished": updatedIsFinished
        ]) { error in
            if let error = error {
                print("Error updating meeting: \(error.localizedDescription)")
            } else {
                print("Meeting completion updated successfully!")
            }
        }
    }
}
