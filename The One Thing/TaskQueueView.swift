//
//  TaskQueueView.swift
//  The One Thing
//
//  Created by ZHIWEN HUANG on 7/10/25.
//

import SwiftUI
import SwiftData

struct TaskQueueView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Query(sort: \Task.priority, order: .forward) private var tasks: [Task]
    @State private var showingAddTask = false
    @State private var newTaskTitle = ""
    
    var pendingTasks: [Task] {
        tasks.filter { !$0.isCompleted }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if pendingTasks.isEmpty {
                    emptyStateView
                } else {
                    taskListView
                }
            }
            .navigationTitle("The Queue")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            addTaskSheet
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checklist")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("Your Queue is Empty")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Add your first task to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("Add Task") {
                showingAddTask = true
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var taskListView: some View {
        List {
            ForEach(pendingTasks, id: \.id) { task in
                TaskRowView(task: task)
                    .onTapGesture {
                        startFocusMode(with: task)
                    }
            }
            .onMove(perform: reorderTasks)
            .onDelete(perform: deleteTasks)
        }
        .listStyle(PlainListStyle())
    }
    
    private var addTaskSheet: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("What's your One Thing?", text: $newTaskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title3)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingAddTask = false
                        newTaskTitle = ""
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addTask()
                    }
                    .disabled(newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private func addTask() {
        let trimmedTitle = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        let newTask = Task(title: trimmedTitle, priority: pendingTasks.count)
        modelContext.insert(newTask)
        
        showingAddTask = false
        newTaskTitle = ""
    }
    
    private func reorderTasks(from source: IndexSet, to destination: Int) {
        var reorderedTasks = pendingTasks
        reorderedTasks.move(fromOffsets: source, toOffset: destination)
        
        for (index, task) in reorderedTasks.enumerated() {
            task.priority = index
        }
    }
    
    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(pendingTasks[index])
        }
    }
    
    private func startFocusMode(with task: Task) {
        withAnimation(.easeInOut(duration: 0.5)) {
            appState.startFocusMode(with: task)
        }
    }
}

struct TaskRowView: View {
    let task: Task
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(task.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

#Preview {
    TaskQueueView()
        .environment(AppState())
        .modelContainer(for: Task.self, inMemory: true)
}