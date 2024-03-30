//
//  ContentView.swift
//  Assessment
//
//  Created by Ben Sarak-Jones on 28/02/2024.
//

import SwiftUI

struct ContentView: View {
    @State var showView: Bool = false
    @State var searchtext = "" //this is the variable for searching text used for the searchbar
    @ObservedObject public var data: Expenses // this is the expenses data
    @Environment(\.scenePhase) private var scenePhase
    @State var swipetext:String = "Mark Paid" //text for the swipe which starts as mark paid as expenses cant be created with already paid
    @State var swipecolor:Color = .blue
    let saveAction: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                // this loops through the expenses and and checks for any expense summary that matches the search text
                ForEach(data.expenses.filter({"\($0.ExpenseSummary)".contains(searchtext) || searchtext.isEmpty})) { expense in
                    NavigationLink(destination: ExpenseDetailView(expense: expense)) {
                        ExpenseRowView(expense: expense) //here it displays the found expense which summary matches the searchtext
                    }
                    
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {//this enables swipe actions
                        
                        Button("Delete"){
                            let selection = data.expenses.firstIndex(where: { $0.id == expense.id})
                            if let selectionindex = selection{
                                data.expenses.remove(at: selectionindex)} //this deletes the expense
                        }.tint(.red)
                        
                        Button(swipetext)
                        { //this is for the swipe button that allows to be paid or unpaid based on if expense is paid
                            if(expense.ExpensePaid == false){
                                swipecolor = .blue
                                swipetext = "Mark Unpaid" //sets swipe text to now be mark unpaid as it is paid
                                expense.ExpensePaid = true
                                expense.TempExpensePaid = true //sets expense and temp expense paid to true so that expense paid button works
                                expense.DateExpensePaid = Date() //sets date paid to current time and date
                                
                            }
                            else{
                                //the same is done here in opposite
                                swipecolor = .blue
                                swipetext = "Mark Paid"
                                expense.ExpensePaid = false
                                expense.TempExpensePaid = false
                            }
                            
                        }.tint(swipecolor)
        
                    }
                    }
            }
            .navigationTitle("Expenses") //title of the app
            .toolbar {//toolbar allows items such as buttons to be added to the top of the app
                ToolbarItemGroup(placement: .primaryAction){
                    Button(action:
                            {
                            showView.toggle()
                           })
                            {
                            Image(systemName: "plus")
                            }.sheet(isPresented: $showView)
                            {
                            ExpenseAddView(expenseList: data) //loads the expense add view
                            }
                    Menu
                    { //allows the expenses data to be sorted by paid or unpaid in ascending or decensing order
                    Picker(selection: $data.sortBy, label: Text("Sorting Options"))
                        {
                            Text("Sort By Paid").tag(0)
                            Text("Sort By Unpaid").tag(1)
                       

                        }
                    }
                    
                label:{
                    Label("Sort", systemImage:"arrow.up.arrow.down")
                }
                    
                }
            }
        }.searchable(text:$searchtext) //adds a searchbar to the top of the app
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() } //forces the app to save if it is set to inactive
        }
    }
}
#Preview {
    ContentView(data:Expenses(), saveAction:{})
}
