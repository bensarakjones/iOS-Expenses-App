//
//  ExpenseRowView.swift
//  Assessment
//
//  Created by Ben Sarak-Jones on 28/02/2024.
//

import SwiftUI

struct ExpenseRowView: View {
    @StateObject var expense:Expense //uses the expense list for the data
    var currencyFormat: FloatingPointFormatStyle<Double>.Currency = .currency(code: "GBP") //variable that helps format numbers to GBP format

    
    var body:some View{
        
        VStack{
           
         HStack{
            // hstack for displaying the summary of the expense and the flag for displaying vat
             Text("Summary: \(expense.ExpenseSummary)").font(.subheadline) //displays expense summary
             Spacer() //spacer helps format
             Image(systemName: expense.isVat ? "doc.plaintext" : "doc.plaintext")
                 .foregroundColor(expense.isVat ? .green : .red)
             //displays if there is vat or not and uses an icon that is red or green depending if there is vat or not
         }
            
            HStack {
                // hstack for displaying the total expense and the flag for displaying if it is paid
                Text("Total: \(expense.TotalExpense, format: currencyFormat)").font(.subheadline)
                //this bit displays the total expense
                Spacer() //spacer helps format
                    Image(systemName: expense.ExpensePaid ? "checkmark.circle" : "xmark.circle")
                        .foregroundColor(expense.ExpensePaid ? .green : .red)
                //this displays if the expense is paid or not with a checkmark or x which is red or green
                }
 
        }
    }
}
    


#Preview {
    ExpenseRowView(expense:Expense(ExpensePaid:false,
                                   TotalCashAmount:0,
                                   isVat:false,
                                   DateReceiptIncurred: Date(),
                                   DateExpenseAdded:Date(),
                                   DateExpensePaid:Date(),
                                   ExpenseSummary:"",
                                  TotalExpense:0))
}
