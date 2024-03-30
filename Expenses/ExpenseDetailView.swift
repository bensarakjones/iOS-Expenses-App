//
//  ExpenseDetailView.swift
//  Assessment
//
//  Created by Ben Sarak-Jones on 28/02/2024.
//

import SwiftUI

struct ExpenseDetailView: View { //displayview displays expenses but also used to edit expenses as well
    @StateObject var expense:Expense //the expense object that the detail view interacts with
    @Environment(\.dismiss) private var dismiss //dismiss variable as earlier
    @State private var showingImagePicker = false //boolean to show imagepicker or not
    @State var image:Image? //selected image if there is one
    @State var inputImage:UIImage?
    var currencyFormat: FloatingPointFormatStyle<Double>.Currency = .currency(code: "GBP") // variable currency format for formatting numbers as GBP
    
    func loadImage(){ //load image function
        guard let inputImage = inputImage else {return}
        image = Image(uiImage:inputImage)
        expense.editImage = inputImage
    }
    
    var body:some View{

        ZStack{
                Circle().fill(.secondary) //placeholder if there is no image
                Text("Tap to select picture")
                    .foregroundColor(.white)
                    .font(.headline)
 
                if let image = expense.image{ //if there is an image fill the cicrcle
                    Image(uiImage:image) //keeps the same design as ad dview to keep ui consistency
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                        .frame(height: 300)
                        .frame(height: 300)
                        .frame(width: 300)
                    
                }
                Circle().fill(.clear)
                
                image?.resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .frame(height: 300)
                    .frame(height: 300)
                    .frame(width: 300)
            }.onTapGesture {
                    showingImagePicker = true; //if image tapped shows imagepicker to pick new image
                }.onChange(of: inputImage){_ in loadImage()}
                .sheet(isPresented: $showingImagePicker){
                    ImagePicker(image: $inputImage) //loads image
                }
        .padding()
        
        VStack{   //this vstack contaisn the input fields for the temp expense variables in the expense list
                  //this is so that expenses can be edited without being saved
            Divider()

            HStack{
                Toggle(isOn: $expense.TempExpensePaid) {
                    Text("Expense Paid?")
                    
                }.disabled(false) //allows expense paid to now be toggleable
            }
            Divider()

            HStack{
                Text("Total cash amount:")
                TextField("", value: $expense.TempTotalCashAmount, format: currencyFormat) //temp total cash amount formatted to GBP
             }.onChange(of: expense.TempTotalCashAmount) { _ in
                 updateTotalExpense() //runs update total expense function again if any changes made
             }
            Divider()

            HStack{
                Toggle(isOn: $expense.TempisVat)
                {
                    Text("VAT (20%)")
                }.disabled(false).onChange(of: expense.TempisVat) { _ in
                    updateTotalExpense() //if vat changed runs update total expense variable
                }
                
            }
            Divider()

            HStack{
                DatePicker(selection: $expense.TempDateExpenseAdded, label: { Text("Date Expense Added")}).disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                //this disabled as expense added date cant be changed so just displays it

            }
            Divider()
            
            HStack{
                DatePicker(selection: $expense.TempDateReceiptIncurred, label: { Text("Date on receipt")})
            }
            

            if expense.TempExpensePaid == true{
                Divider()
                HStack{
                    DatePicker(selection: $expense.TempDateExpensePaid, label: { Text("Date expense paid")})
                }

            }
            else{
                HStack{
                    DatePicker(selection: $expense.TempDateExpensePaid, label: { Text("Date expense paid")}).disabled(true).hidden()
                    
                }.hidden()

            }
               
            
Divider()
            HStack{
                Text("Summary")
                TextField("Enter Summary here", text: $expense.TempExpenseSummary)
                
            }
            Divider()

            HStack{
                Text("Total: £")
                TextField("", value: $expense.TemptTotalExpense, format: currencyFormat).disabled(true) //formatted to GBP, disbaled so cant be edited
                    .onChange(of: expense.TemptTotalExpense) { _ in
                        updateTotalExpense() //update total expense function runs to keep it live updating
                    }
            }
            Divider()

            
        }.padding()
        .onDisappear(perform:
        {
            //if view dissapears reverts the temporary expene variables back to the original ones so does not save edits
            expense.TempExpensePaid = expense.ExpensePaid
            expense.TempTotalCashAmount = expense.TotalCashAmount
            expense.TempDateReceiptIncurred = expense.TempDateReceiptIncurred
            expense.TempDateExpenseAdded = expense.DateExpenseAdded
            expense.TempDateExpensePaid = expense.DateExpensePaid
            expense.TempExpenseSummary = expense.ExpenseSummary
            expense.TempisVat = expense.isVat
            expense.editImage = expense.image

            
            
            
        })
        .toolbar{
            Button("Save")
            {
                //if save is executed then the original variable values are overwitten by what is in the temp values
                //this is so that expenses can can be updated
                    expense.ExpensePaid = expense.TempExpensePaid
                    expense.TotalCashAmount = expense.TempTotalCashAmount
                    expense.TempDateReceiptIncurred = expense.TempDateReceiptIncurred
                    expense.DateExpenseAdded = expense.TempDateExpenseAdded
                    expense.DateExpensePaid = expense.TempDateExpensePaid
                    expense.ExpenseSummary = expense.TempExpenseSummary
                    expense.isVat = expense.TempisVat
                    expense.TotalExpense = expense.TemptTotalExpense
                    if expense.editImage != nil{
                    expense.image = expense.editImage
                    }
                
                    dismiss()
                }
            }
            
        }
    
    
    //function for updating the total expense
    func updateTotalExpense() {
            if expense.TempisVat {
                expense.TemptTotalExpense = expense.TempTotalCashAmount * 1.20 //adds 20% if there is vat
            } else {
                expense.TemptTotalExpense = expense.TempTotalCashAmount //if there is no vat makes it equal to the cash amount
            }
        }
    
    }



#Preview {
    ExpenseDetailView(expense:Expense(ExpensePaid:false,
                                       TotalCashAmount:0,
                                       isVat:false,
                                       DateReceiptIncurred: Date(),
                                       DateExpenseAdded:Date(),
                                       DateExpensePaid:Date(),
                                       ExpenseSummary:"",
                                     TotalExpense: 0))
}
