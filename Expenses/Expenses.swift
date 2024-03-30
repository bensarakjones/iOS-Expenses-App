//
//  Expenses.swift
//  Assessment
//
//  Created by Ben Sarak-Jones on 28/02/2024.
//

import Foundation
class Expenses:ObservableObject{
    // here i have publsihed variables for the expenses array and sortBy
    @Published var expenses:[Expense] = []
    @Published var sortBy: Int = 0 {
        didSet { //this here sorts the expenses if they are paid or unpaid
            if sortBy == 0 {
                expenses.sort { !$1.ExpensePaid && $0.ExpensePaid }
            } else {
                expenses.sort { $1.ExpensePaid && !$0.ExpensePaid }
            }
            
            }
        }
    
    
    private static func fileURL() throws -> URL{ // a function for helping to save the expenses data
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
        appropriateFor: nil, create:false) .appendingPathComponent("Expenses.data")
    }
    
    //this function saves the expense data array to a file
    static func save(expenses:[Expense], completion:@escaping(Result<Int, Error>)->Void)
    {
        DispatchQueue.global(qos: .background).async
        {
            do{
                let data = try JSONEncoder().encode(expenses)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async
                 {
                    completion(.success(expenses.count))
                 }
               }
            
            catch
            {
                DispatchQueue.main.async 
                {
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    //this function loads the expense data from the file
    static func load(completion:@escaping(Result<[Expense], Error>)->Void)
    {
        DispatchQueue.global(qos: .background).async
        {
            do{
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) 
                
                else
                {
                    DispatchQueue.main.async 
                    {
                     completion(.success([]))
                    }
                    return
                }
                let newExpense = try JSONDecoder().decode([Expense].self, from:file.availableData)
                DispatchQueue.main.async
                {
                    completion(.success(newExpense))
                }
            }
            
            catch
            {
                DispatchQueue.main.async
                {
                    completion(.failure(error))
                }
            }
            
        }
    }

    
    
     
}
