import SwiftUI

struct AddMeetingView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var deadline = Date()
    @State private var time = Date()
    @State private var selectedIcon: String = ""
    @State private var isSelected: Bool = false
    @EnvironmentObject var meetingViewModel: MeetingViewModel
    
    var icons: [String] = ["curlybraces", "graduationcap.fill", "calendar", "book.fill", "brain.fill", "sparkles", "heart.text.clipboard.fill", "heart.circle.fill", "stethoscope.circle.fill", "paintbrush.fill", "scribble.variable", "gear", "globe", "chart.pie.fill", "heart.text.square.fill", "video.fill", "phone.fill", "map.fill","briefcase.fill", "pencil.and.outline", "chart.bar.fill", "lightbulb.fill", "bubble.middle.bottom.fill"]
 
    var body: some View {
        NavigationStack{
                Form {
                    Section(header: Text("Meeting Details")) {
                        TextField("Enter meeting title", text: $title)
                        TextField("Add a brief description (e.g., agenda, notes)", text: $description)
                    }
                    
                    Section(header: Text("Select Icon")) {
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing: 10) {
                                ForEach(icons, id: \.self){ imageName in
                                    Image(systemName: imageName)
                                        .symbolRenderingMode(selectedIcon == imageName ? .multicolor : .monochrome)
                                        .padding()
                                        .font(.system(size: selectedIcon == imageName ? 30 : 25))
                                        .background(
                                            Circle()
                                                .fill(selectedIcon == imageName ? Color.blue.opacity(0.7) : Color.gray.opacity(0.2))
                                                .frame(width: selectedIcon == imageName ? 60 : 50, height: selectedIcon == imageName ? 60 : 50)
                                        )
                                        .onTapGesture {
                                            if imageName != ""{
                                                selectedIcon = imageName
                                            }else{
                                                selectedIcon = "sparkles"
                                                
                                            }
                                        }
                                }
                                
                                
                            }
                        }
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
                                        time: time,
                                        currentDate: Date.now,
                                        selectedIcon: selectedIcon
                                        
                                    )
                                    dismiss()
                                }else{
                                    meetingViewModel.addMeeting(
                                        title: title,
                                        description: "No description",
                                        deadline: deadline,
                                        time: time,
                                        currentDate: Date.now,
                                        selectedIcon: selectedIcon
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
