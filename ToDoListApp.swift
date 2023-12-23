//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by ifpb on 22/12/23.
//

import SwiftUI
import CoreData

@main
struct ToDoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TaskListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear() {
                    checkAndCreateInitialTask()
                }
        }
    }
    private func checkAndCreateInitialTask() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            let tasks = try persistenceController.container.viewContext.fetch(fetchRequest)
            if tasks.isEmpty {
                let initialTask = Task(context: persistenceController.container.viewContext)
                initialTask.name = "Tarefa incial"
                initialTask.priority = 1
                initialTask.dueDate = Date()
                initialTask.isCompleted = false
                
                try persistenceController.container.viewContext.save()
            }
        } catch {
            print("Erro ao criar task inicial: \(error.localizedDescription)")
        }
    }
}
