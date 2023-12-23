//
//  AddTaskView.swift
//  ToDoList
//
//  Created by ifpb on 22/12/23.
//

import SwiftUI
import CoreData

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var taskName: String = ""
    @State private var priority: Int = 0
    @State private var dueDate = Date()
    @State private var isCompleted = false
    
    var body: some View {
        VStack {
            TextField("Digite a Atividade a ser completada", text: $taskName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            DatePicker("Até", selection: $dueDate, displayedComponents: .date)
                .datePickerStyle(DefaultDatePickerStyle())
                .padding()
            Stepper(value: $priority, in: 0...10) {
                Text("Prioridade: \(priority)")
            }
            .padding()
            Toggle("Completado", isOn: $isCompleted)
                .padding()
            Button(action: {
                saveTask()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Adicionar tarefa")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .navigationTitle("Adicionar Atividade")
    }
    private func saveTask() {
        withAnimation{
            let newTask = Task(context: viewContext)
            newTask.name = taskName
            newTask.priority = Int16(priority)
            newTask.dueDate = dueDate
            newTask.isCompleted = isCompleted
            do {
                try viewContext.save()
                taskName = ""
                priority = 0
                dueDate = Date()
                isCompleted = false
            } catch {
                let nsError = error as NSError
                fatalError("Erro não resolvido \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
