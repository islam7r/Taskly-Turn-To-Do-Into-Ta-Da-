//
//  AddDailyTask.swift
//  Taskly
//
//  Created by Islam Rzayev on 05.12.24.
//

import SwiftUI

struct AddDailyTask: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    @EnvironmentObject var taskViewModel: DailyTaskViewModel
    

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Info")) {
                    TextField("Enter task", text: $title)
                    TextField("Add a brief description (e.g., go to gym, drink water)", text: $description)
                }
            }
            Spacer()
            AdBannerView(adUnitID: "ca-app-pub-4816684168621488/9132437955")
                .frame(height: 70)
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if !title.isEmpty {
                            if !description.isEmpty{
                                taskViewModel.addTask(title: title, description: description)
                                dismiss()
                            }else{
                                taskViewModel.addTask(title: title, description: "No description")
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
    
}
#Preview {
    AddDailyTask()
        .environmentObject(DailyTaskViewModel()) 
        .environmentObject(AuthViewModel())
        .environmentObject(MeetingViewModel())
        
}
