import SwiftUI

struct AddMeetingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var deadline = Date()
    @State private var time = Date()
    @EnvironmentObject var meetingViewModel: MeetingViewModel

 
    var body: some View {
        NavigationStack{
                Form {
                    Section(header: Text("Meeting Details")) {
                        TextField("Enter meeting title", text: $title)
                        TextField("Add a brief description (e.g., agenda, notes)", text: $description)
                    }

                    Section(header: Text("Deadline")) {
                        DatePicker("Set Deadline", selection: $deadline, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                        DatePicker("Set Time", selection: $time, displayedComponents: .hourAndMinute)
                            
                        
                    }
                }
                .navigationTitle("Add Meeting")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            if !title.isEmpty {
                                if !description.isEmpty{
                                    meetingViewModel.addMeeting(
                                        title: title,
                                        description: description,
                                        deadline: deadline,
                                        time: time
                                    )
                                    dismiss()
                                }else{
                                    meetingViewModel.addMeeting(
                                        title: title,
                                        description: "No description",
                                        deadline: deadline,
                                        time: time
                                    )
                                    dismiss()
                                }
                            }
                        } label: {
                            Text("Save")
                                .foregroundStyle(Color(red: 0.20, green: 0.29, blue: 0.33))
                        }
                    }
                }
            
        }
       
    }

    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    AddMeetingView()
        .environmentObject(DailyTaskViewModel())
        .environmentObject(AuthViewModel())
        .environmentObject(MeetingViewModel())
}
