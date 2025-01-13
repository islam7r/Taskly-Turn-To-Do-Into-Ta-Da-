import SwiftUI

struct DailyTaskView: View {
    @EnvironmentObject var taskViewModel: DailyTaskViewModel
    @Environment(\.dismiss) var dismiss
    @State private var sheetShown: Bool = false
    
    let task: DailyTasks

    var body: some View {
        NavigationStack {
            List {
                ForEach(taskViewModel.tasks) { task in
                    HStack {
                        Button(action: {
                            taskViewModel.toggleTaskCompletion(task: task)
                        }) {
                            Image(systemName: task.isFinished ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isFinished ? .green : .gray)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(task.title)
                                .strikethrough(task.isFinished, color: .gray)
                                .font(.headline)
                            Text(task.description)
                                .strikethrough(task.isFinished, color: .gray)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteTask)
            }
            
            .scrollIndicators(.hidden)
            .toolbar(content: {
                Image(systemName: "plus")
                    .onTapGesture {
                        sheetShown = true
                    }
                    .sheet(isPresented: $sheetShown) {
                        AddDailyTask()
                    }
            })
            .navigationTitle("Daily Tasks")
            .onAppear {
                taskViewModel.fetchTasks()
            }
            Spacer()
            AdBannerView(adUnitID: "ca-app-pub-4816684168621488/9132437955")
                .frame(height: 50)
        }
        
    }
    
    
    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = taskViewModel.tasks[index]
            guard let taskId = task.id else { return }
    
            taskViewModel.deletetask(taskId: taskId)
        }
        taskViewModel.tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    NavigationStack{
        DailyTaskView(task: DailyTasks(userId: "exampleUserID", title: "Daily Task", description: "Daily Task Description"))
            .environmentObject(DailyTaskViewModel()) 
            .environmentObject(AuthViewModel())
            .environmentObject(MeetingViewModel())
    }
}
