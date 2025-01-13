//
//  MeetingDetailsView.swift
//  Taskly
//
//  Created by Islam Rzayev on 05.12.24.
//

import SwiftUI

struct MeetingDetailsView: View {
    @State private var progress: CGFloat = 0.7
    @State private var daysLeft: Int = 7
    @State private var hoursLeft: Int = 12
    @State private var minutesLeft: Int = 30
    @EnvironmentObject var meetingViewModel: MeetingViewModel
    @Environment(\.dismiss) var dismiss
    let meeting: Meeting

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(colors: [
                Color(red: 0.24, green: 0.21, blue: 0.26),
                Color(red: 0.89, green: 0.85, blue: 0.71)
            ], startPoint: .bottom, endPoint: .top)
            .ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 20) {
                    // Meeting Details Card

                    MeetingCardView(meeting: meeting)
                        .navigationTitle("Meeting Details")
                    // MARK: - TimeLeftView
                    Spacer()
                    TimeLeftView(deadline: meeting.deadline, time: meeting.time)
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
                .onAppear(){
                    AppOpenAdManager.shared.loadAd()
                    AppOpenAdManager.shared.showAdIfAvailable()
                }
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
    
}
struct MeetingCardView: View{
    @State private var progress: CGFloat = 0.7
    @State private var daysLeft: Int = 7
    @State private var hoursLeft: Int = 12
    @State private var minutesLeft: Int = 30
    @EnvironmentObject var meetingViewModel: MeetingViewModel
    @Environment(\.dismiss) var dismiss
    let meeting: Meeting
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(width: 400, height: 250)
            .foregroundStyle(
                LinearGradient(
                    colors: [Color.gray, Color.black.opacity(0.5)],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            )
            .padding()
            .overlay {
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text(meeting.title)
                            .font(.title)
                            .foregroundStyle(Color.black.opacity(0.7))
                            .padding(.vertical)
                        Image(systemName: meeting.selectedIcon == "" ? "sparkles" : meeting.selectedIcon ?? "sparkles")
                            .symbolRenderingMode(.multicolor)
                            .symbolEffect(.pulse)
                    }
                    
                    HStack{
                        
                        Group{
                            Image(systemName: "calendar")
                            Text(meeting.deadline, formatter: dateFormatter)
                            Rectangle()
                                .frame(width: 1, height: 20, alignment: .center)
                            Text("\(meeting.time != nil ? formatTime(meeting.time) : "No time specified")")
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color.white.opacity(0.7))
                    }
                    
                    VStack(alignment: .leading) {
                        Rectangle()
                            .foregroundStyle(Color.earthySeparator)
                            .frame(width: 350, height: 1)
                        Text(meeting.description)
                            .font(.footnote)
                            .foregroundStyle(Color.black.opacity(0.7))
                            
                    }
                   
                }
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
            selectedIcon: "sparkles",
            isFinished: false
            
        ))
        .environmentObject(DailyTaskViewModel())
        .environmentObject(AuthViewModel())
        .environmentObject(MeetingViewModel())
        
    }
}
