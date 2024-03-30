//
//  ExpenseAddView.swift
//  Assessment
//
//  Created by Ben Sarak-Jones on 28/02/2024.
//

import SwiftUI

struct ExpenseAddView: View {
    @ObservedObject var expenseList:Expenses //list of expenses
    @StateObject var newExpense:Expense = //declaring a new expense object with variables initliased
    Expense(ExpensePaid:false,
            TotalCashAmount:0,
            isVat:false,
            DateReceiptIncurred: Date(),
            DateExpenseAdded:Date(),
            DateExpensePaid:Date(),
            ExpenseSummary:"",
            TotalExpense: 0)
    @Environment(\.dismiss) private var dismiss //environemnt value that dismisses a view
    @State private var showingImagePicker = false // variable to shwo imagepicker or not
    @State var image:Image? //image variable
    @State var inputImage:UIImage? //image variable
     var currencyFormat: FloatingPointFormatStyle<Double>.Currency = .currency(code: "GBP") //format variable that formats the display of currency to GBP format

    
    func loadImage(){ //load image function
        guard let inputImage = inputImage else {return}
        image = Image(uiImage:inputImage)
        newExpense.image = inputImage
    }
    
    
    var body:some View{
        VStack{
            HStack{
                Button(action:{
                    dismiss() //dismisses the view for the cancel button
                    
                }){
                    Text("Cancel") //makes the button say cancel
                }
                Spacer()
                Button(action:{
                   //sets the temporary variables to that of the actual variables
                    newExpense.editImage = newExpense.image
                    newExpense.TempExpensePaid = newExpense.ExpensePaid
                    newExpense.TempTotalCashAmount = newExpense.TotalCashAmount
                    newExpense.TempisVat = newExpense.isVat
                    newExpense.TempDateReceiptIncurred = newExpense.DateReceiptIncurred
                    newExpense.TempDateExpenseAdded = newExpense.DateExpenseAdded
                    newExpense.TempDateExpensePaid = newExpense.DateExpensePaid
                    newExpense.TempExpenseSummary = newExpense.ExpenseSummary
                    newExpense.TemptTotalExpense = newExpense.TotalExpense

                    expenseList.expenses.append(newExpense) //appends the new expense to the list of expenses
                    dismiss() //dismisses the view after its all saved
                }){Text("Save")} //makes the button say save
            }
            .padding()
            
            ZStack
            {//this allows an image to be displayed
                Circle().fill(.secondary)//creates a nice placeholder for when there is no image if the image
                if image != nil {
                        image? //formats the image to make it ook nice
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    } else { //if no image asks the user to tap to select
                        Text("Tap to select picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }

            }
            .frame(height: 300)
            .frame(height: 300) 
            .frame(width: 300)
            .onTapGesture {
                showingImagePicker = true;
            }
            .padding()
            
            VStack{ //this vstack contaisn the input fields for the expense variables in the newexpense list
                Divider()
                HStack{
                    Toggle(isOn: $newExpense.ExpensePaid) {
                        Text("Expense Paid?")
                    }.disabled(true)//disables the ability to make the expense paid true when adding an expense
                }
                Divider()

                HStack{
                    Text("Total cash amount:")
                    TextField("", value: $newExpense.TotalCashAmount, format: currencyFormat) //total cash amount variable formatted to the curreny format of GBP

                    
                } .onChange(of: newExpense.TotalCashAmount) { _ in
                    updateTotalExpense() // keeps the total amount updating
                }
                Divider()

                
                HStack{
                    Toggle(isOn: $newExpense.isVat) {
                        Text("VAT (20%)")
                        
                    }.disabled(false).onChange(of: newExpense.isVat) { _ in
                        updateTotalExpense()//keeps the total variable also updating based on the vat
                    }
                }
                Divider()
                
                HStack{
                    
                    DatePicker(selection: $newExpense.DateExpenseAdded, label: { Text("Date Added")}).disabled(true)
                }
                Divider()

                HStack{
                    DatePicker(selection: $newExpense.DateReceiptIncurred, label: { Text("Date on receipt")})
                }
                Divider()
               

                HStack{
                    Text("Summary")
                    TextField("Enter Summary", text: $newExpense.ExpenseSummary)
                }
                Divider()

                HStack{
                    Text("Total:")
                    TextField("", value: $newExpense.TotalExpense, format: currencyFormat).disabled(true)
                    //total is displayed here and also disabled so users cannot change it
                }.onChange(of: newExpense.TotalExpense) { _ in
                    updateTotalExpense() // if the total changes it also ensures it is updated with the corrcet value
                }
                Divider()
                Spacer()
                
            }.padding()
            .onChange(of:inputImage)
            { _ in
                loadImage()}.sheet(isPresented:$showingImagePicker)
                {
                    ImagePicker(image:$inputImage)
                }
        }.padding(.top,50)

    }
    
 
    //function for updating the total expense
    func updateTotalExpense() {
            if newExpense.isVat {
                newExpense.TotalExpense = newExpense.TotalCashAmount * 1.20 //adds 20% if there is vat
            } else {
                newExpense.TotalExpense = newExpense.TotalCashAmount //if there is no vat makes it equal to the cash amount
            }
        }

    
    
    
    }


#Preview {
    ExpenseAddView(expenseList: Expenses())
}
