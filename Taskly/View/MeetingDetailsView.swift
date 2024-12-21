//
//  MeetingDetailsView.swift
//  Taskly
//
//  Created by Islam Rzayev on 05.12.24.
//

import SwiftUI

struct MeetingDetailsView: View {
    @EnvironmentObject var meetingViewModel: MeetingViewModel
    @Environment(\.dismiss) var dismiss
    let meeting: Meeting

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(colors: [
                Color(red: 0.14, green: 0.21, blue: 0.26),
                Color(red: 0.89, green: 0.95, blue: 0.91)
            ], startPoint: .bottom, endPoint: .top)
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Meeting Details Card
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 380, height: 250)
                    .foregroundStyle(Color.earthyBackground)
                    .shadow(color: Color.black.opacity(0.8), radius: 5, x: -5, y: 10)
                    .shadow(color: Color.black.opacity(0.8), radius: 5, x: 5, y: -10)
                    .padding()
                    .overlay {
                        VStack {
                            VStack(alignment: .leading, spacing: 10) {
                                VStack {
                                    Text(meeting.title)
                                        .font(.title)
                                        .foregroundStyle(Color.earthyTitle)
                                    Rectangle()
                                        .foregroundStyle(Color.earthySeparator)
                                        .frame(width: 300, height: 1)
                                }
                                
                                
                                Text(meeting.description)
                                    .font(.headline)
                                    .foregroundStyle(Color.earthySubtitle)
                                
                                
                                
                            }
                            .padding(.horizontal)
                            
                            
                            Rectangle()
                                .foregroundStyle(Color.earthySeparator)
                                .frame(width: 300, height: 1)
                            
                            HStack{
                                
                                Group{
                                    Text(meeting.deadline, formatter: dateFormatter)
                                    Text("at \(meeting.time != nil ? formatTime(meeting.time!) : "No time specified")")
                                }
                                .font(.subheadline)
                                .foregroundStyle(Color.vibrantSeparator)
                            }
                        }
                    }
                    .navigationTitle("Meeting Details")
                    
                
                Spacer()
                
              
                
                // Delete Button
                Button {
                    deleteMeeting()
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 40)
                        .foregroundStyle(Color.black)
                        .shadow(color: Color.black.opacity(0.8), radius: 10, x: -10, y: 5)
                        .overlay {
                            Text("Delete")
                                .foregroundStyle(.red)
                        }
                }
               
                
                Spacer()
            }
        }
    }
    
    // MARK: - Delete Meeting
    func deleteMeeting() {
        guard let meetingId = meeting.id else { return }
        meetingViewModel.deleteMeeting(meetingId: meetingId) {
            dismiss() // Navigate back after deletion
        }
    }
    
    // MARK: - Format Date
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter
    }
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        MeetingDetailsView(meeting: Meeting(
            id: "exampleID",
            userId: "exampleUserID",
            title: "Team Meeting",
            description: "Discuss Goals",
            deadline: Date(),
            time: Date(),
            isFinished: false
        ))
        .environmentObject(DailyTaskViewModel())
        .environmentObject(AuthViewModel())
        .environmentObject(MeetingViewModel())
        
    }
}
