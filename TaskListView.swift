//
//  TaskListView.swift
//  ToDoList
//
//  Created by ifpb on 22/12/23.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.name, ascending: true)]) var tasks: FetchedResults<Task>
    
    @State private var showCompletedTasks = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tasks.filter { showCompletedTasks ? true : !$0.isCompleted }, id: \.self) { task in
                    NavigationLink(destination: TaskDetailsView(task: task)) {
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                            Text(task.name ?? "Sem nome")
                        }
                    }
                }
                .onDelete(perform: deleteTask)
            }
            .navigationTitle("Lista de Atividades")
            .navigationBarItems(
                leading: EditButton(),
                trailing: HStack {
                    NavigationLink(destination: AddTaskView(), label: {
                        Image(systemName: "plus")
                    })
                    Toggle(isOn: $showCompletedTasks, label: {
                        Image(systemName: "checkmark.circle.fill")
                    })
                    .onChange(of: showCompletedTasks) { _ in
                        // Atualize a lista quando o Toggle for alterado
                        fetchTasks()
                    }
                }
            )
        }
        .onAppear {
            fetchTasks()
        }
    }

    private func deleteTask(offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Erro ao excluir tarefa: \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func fetchTasks() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let nsError = error as NSError
            fatalError("Erro ao buscar tarefas: \(nsError), \(nsError.userInfo)")
        }
    }

    private var fetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Task.name, ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistenceController.shared.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }()
}
