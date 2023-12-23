//
//  TaskDetailsView.swift
//  ToDoList
//
//  Created by ifpb on 22/12/23.
//

import SwiftUI
import CoreData

struct TaskDetailsView: View {
    let task: Task
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()

            Text(task.name ?? "Sem nome")
                .font(.title)
                .padding()
                .foregroundColor(task.isCompleted ? .green : .primary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Prioridade:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text("\(task.priority)")
                    .font(.body)
            }
            .padding()
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Data Limite:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(formattedDate(task.dueDate))
                    .font(.body)
            }
            .padding()
            
            Divider()
            
            HStack(alignment: .center) {
                Text("Completada:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(task.isCompleted ? .green : .red)
            }
            .padding()

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle("Detalhes:")
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Sem data" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }
}

struct TaskDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        let newTask = Task(context: context)
        newTask.name = "Teste"
        newTask.priority = 7
        newTask.dueDate = Date()
        newTask.isCompleted = false
        
        return TaskDetailsView(task: newTask)
    }
}
