//
//  AssessmentApp.swift
//  Assessment
//
//  Created by Ben Sarak-Jones on 28/02/2024.
//

import SwiftUI

@main
struct AssessmentApp: App {
    @StateObject private var data = Expenses()
    var body: some Scene {
        WindowGroup {
            //
            ContentView(data:self.data) //this displays contentview as the main view and allows contentview to interact with the expenses data.
            {
                Expenses.save(expenses: data.expenses) //this saves the expenses data
                {result in
                    if case .failure(let error) = result
                    {
                        fatalError(error.localizedDescription)
                    }
                }
            }.onAppear
            {
                Expenses.load{result in
                    switch result 
                    {
                       case .failure(let error):fatalError(error.localizedDescription)
                       case .success(let expenses):data.expenses = expenses //this loads the expense data
                    }
                }
            }
        }
    }
}

