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
    }
}

#Preview {
    StrongReferences()
}
