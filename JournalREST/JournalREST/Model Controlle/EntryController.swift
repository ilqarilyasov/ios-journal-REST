//
//  EntryController.swift
//  JournalREST
//
//  Created by Ilgar Ilyasov on 9/20/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

class EntryController {
    
    // MARK: - Properties
    
    var entries: [Entry] = []
    
    
    // MARK: - Base URL
    
    static let baseURl = URL(string: "https://journal-b5918.firebaseio.com/")!
    
    
    // MARK: Encode PUT method
    
    func put(entry: Entry, completion: @escaping (Error?) -> Void) {
        
        // Create a request url
        var url = EntryController.baseURl.appendingPathComponent(entry.identifier)
        url.appendPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.put.rawValue
        
        // Encode data
        let encoder = JSONEncoder()
        
        do {
            let encodedEntry = try encoder.encode(entry)
            request.httpBody = encodedEntry
            completion(nil)
        } catch {
            NSLog("Error encoding \(entry): \(error)")
            completion(error)
            return
        }
        
        // Create a task
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            // Handle errors
            if let error = error {
                NSLog("Error transfering data: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    
    // MARK: - CRUD
    
    // Create an entry
    func createEntry(title: String, bodyText: String, completion: @escaping (Error?) -> Void) {
        
        let newEntry = Entry(title: title, bodyText: bodyText)
        
        put(entry: newEntry, completion: completion)
    }
    
    // Update the entry
    func updateEntry(entry: Entry, title: String, bodyText: String, completion: @escaping (Error?) -> Void) {
        guard let index = entries.index(of: entry) else { return }
        
        entries[index].title = title
        entries[index].bodyText = bodyText
        
        put(entry: entry, completion: completion)
        
    }
    
}
