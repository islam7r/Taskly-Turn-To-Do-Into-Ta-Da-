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
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = taskViewModel.tasks[index] // Access task at specific index
            guard let taskId = task.id else { return }
            
            // Call ViewModel to delete from Firebase and update the local list
            taskViewModel.deletetask(taskId: taskId)
        }
        // Remove the task from the local list after deletion
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
