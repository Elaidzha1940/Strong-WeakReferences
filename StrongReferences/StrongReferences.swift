//  /*
//
//  Project: StrongReferences
//  File: StrongReferences.swift
//  Created by: Elaidzha Shchukin
//  Date: 07.01.2024
//
//  */

import SwiftUI

final class StrongReferencesDataService {
    
    func getData() async -> String {
        "Updated Data"
    }
}

final class StrongReferencesViewModel: ObservableObject {
    @Published var data: String = "Title"
    let dataService = StrongReferencesDataService()
    
    private var someTask: Task<Void, Never>? = nil
    private var myTasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        someTask?.cancel()
        someTask = nil
        
        myTasks.forEach({ $0.cancel() })
        myTasks = []
    }
    
    // This implies a strong reference...
    func updateData() {
        Task {
            data = await dataService.getData()
        }
    }
    
    // This is a strong reference...
    func updateData2() {
        Task {
            self.data = await dataService.getData()
        }
    }
    
    // This is a strong reference...
    func updateData3() {
        Task { [self] in
            self.data = await dataService.getData()
        }
    }
    
    // This is a weak reference...
    func updateData4() {
        Task { [weak self] in
            if let data = await self?.dataService.getData() {
                self?.data = data
            }
        }
    }
    
    // We don't need to manage weak/strong reference
    // We can manage the Task
    func updateData5() {
        someTask = Task {
            self.data = await dataService.getData()
        }
    }
    
    // We can manage the Task
    func updateData6() {
        let task1 = Task {
            self.data = await dataService.getData()
        }
        myTasks.append(task1)
        
        let task2 = Task {
            self.data = await dataService.getData()
        }
        myTasks.append(task2)
    }
    
    // We purposely do not cancel tasks to keep strong reference
    func updateData7() {
        Task {
            self.data = await dataService.getData()
        }
        Task.detached {
            self.data = await self.dataService.getData()
        }
    }
    
    func updateData8() async {
        self.data = await dataService.getData()
    }
}

struct StrongReferences: View {
    @StateObject private var viewModel = StrongReferencesViewModel()
    
    var body: some View {
        
        VStack {
            Text(viewModel.data)
        }
        .onAppear {
            viewModel.updateData()
        }
        .onDisappear {
            viewModel.cancelTasks()
        }
        .task {
             await viewModel.updateData8()
        }
    }
}

#Preview {
    StrongReferences()
}
