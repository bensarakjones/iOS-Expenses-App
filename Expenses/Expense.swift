//
//  Expense.swift
//  Assessment
//
//  Created by Ben Sarak-Jones on 28/02/2024.
//

import Foundation
import SwiftUI


class Expense:Identifiable, ObservableObject, Codable{
    
    //here is published variables so that any changes in these variables will update the app
    //they are dcelared according to the requirements of the assesment
    @Published var ExpensePaid:Bool
    @Published var TotalCashAmount:Double
    @Published var isVat:Bool
    @Published var DateReceiptIncurred:Date
    @Published var DateExpenseAdded:Date
    @Published var DateExpensePaid:Date
    @Published var ExpenseSummary:String
    @Published var TotalExpense:Double
    @Published var image:UIImage?
    
    //published temporray variables that will be used for updating an expense
    @Published var TempExpensePaid:Bool
    @Published var TempTotalCashAmount:Double
    @Published var TempisVat:Bool
    @Published var TempDateReceiptIncurred:Date
    @Published var TempDateExpenseAdded:Date
    @Published var TempDateExpensePaid:Date
    @Published var TempExpenseSummary:String
    @Published var TemptTotalExpense:Double
    @Published var editImage:UIImage?
    
    
    let id = UUID() // a unique id for an expense
    
    //initliase the variables
    init (ExpensePaid:Bool = false, TotalCashAmount:Double,isVat:Bool, DateReceiptIncurred:Date,DateExpenseAdded:Date, DateExpensePaid:Date, ExpenseSummary:String, TotalExpense:Double ){
        
        self.ExpensePaid = ExpensePaid
        self.TotalCashAmount = TotalCashAmount
        self.isVat = isVat
        self.DateReceiptIncurred = DateReceiptIncurred
        self.DateExpenseAdded = DateExpenseAdded
        self.DateExpensePaid = DateExpensePaid
        self.ExpenseSummary = ExpenseSummary
        self.TotalExpense = TotalExpense
        self.TempExpensePaid = ExpensePaid
        self.TempTotalCashAmount = TotalCashAmount
        self.TempisVat = isVat
        self.TempDateReceiptIncurred = DateReceiptIncurred
        self.TempDateExpenseAdded = DateExpenseAdded
        self.TempDateExpensePaid = DateExpensePaid
        self.TempExpenseSummary = ExpenseSummary
        self.TemptTotalExpense = TotalExpense
    }
    
    enum CodingKeys:CodingKey{
        case ExpensePaid,TotalCashAmount,isVat,DateReceiptIncurred,DateExpenseAdded,DateExpensePaid,ExpenseSummary,TotalExpense
    }
    
    func encode(to encoder: Encoder) throws {
        writeImageToDisk() //writeimagetodisk function
        var container = encoder.container(keyedBy:CodingKeys.self)
        try container.encode(ExpensePaid, forKey:.ExpensePaid)
        try container.encode(TotalCashAmount, forKey:.TotalCashAmount)
        try container.encode(isVat, forKey:.isVat)
        try container.encode(DateReceiptIncurred, forKey:.DateReceiptIncurred)
        try container.encode(DateExpenseAdded, forKey:.DateExpenseAdded)
        try container.encode(DateExpensePaid, forKey:.DateExpensePaid)
        try container.encode(ExpenseSummary, forKey:.ExpenseSummary)
        try container.encode(TotalExpense, forKey:.TotalExpense)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy:CodingKeys.self)
        let decodedExpensePaid = try container.decode(Bool.self, forKey:.ExpensePaid)
        let decodedTotalCashAmount = try container.decode(Double.self, forKey:.TotalCashAmount)
        let decodedisVat = try container.decode(Bool.self, forKey:.isVat)
        let decodedDateReceiptIncurred = try container.decode(Date.self, forKey:.DateReceiptIncurred)
        let decodedDateExpenseAdded = try container.decode(Date.self, forKey:.DateExpenseAdded)
        let decodedDateExpensePaid = try container.decode(Date.self, forKey:.DateExpensePaid)
        let decodedExpenseSummary = try container.decode(String.self, forKey:.ExpenseSummary)
        let decodedTotalExpense = try container.decode(Double.self, forKey:.TotalExpense)
        
        ExpensePaid = decodedExpensePaid
        TotalCashAmount = decodedTotalCashAmount
        isVat = decodedisVat
        DateReceiptIncurred = decodedDateReceiptIncurred
        DateExpenseAdded = decodedDateExpenseAdded
        DateExpensePaid = decodedDateExpensePaid
        ExpenseSummary = decodedExpenseSummary
        TotalExpense = decodedTotalExpense
        
        TempExpensePaid = decodedExpensePaid
        TempTotalCashAmount = decodedTotalCashAmount
        TempisVat = decodedisVat
        TempDateReceiptIncurred = decodedDateReceiptIncurred
        TempDateExpenseAdded = decodedDateExpenseAdded
        TempDateExpensePaid = decodedDateExpensePaid
        TempExpenseSummary = decodedExpenseSummary
        TemptTotalExpense = decodedTotalExpense
        
        let imagePath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false).appendingPathComponent("\(DateExpenseAdded).jpg")
        
        if let loadPath = imagePath{
            if let data = try? Data(contentsOf: loadPath){
                self.image = UIImage(data: data)
                print("loaded")
            }
        }
    }
    
func writeImageToDisk() {
    if let imageToSave = self.image{
        let imagePath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:false).appendingPathComponent("\(DateExpenseAdded).jpg") //Don't use the UUID for the image name.
        if let jpegData = imageToSave.jpegData(compressionQuality: 0.5) { // I can adjust the compression quality.
            if let savePath = imagePath{
                try? jpegData.write(to: savePath, options: [.atomic, .completeFileProtection])
                print("saved \(savePath)")
            }
        }
    }
}

    
}
