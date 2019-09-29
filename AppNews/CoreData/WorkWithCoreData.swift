//
//  WorkWithCoreData.swift
//  AppNews
//
//  Created by Максим Лисица on 29/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit
import CoreData

class WorkWithCoreData {
    
    var context: NSManagedObjectContext?
    
    func getReadedNews(array: inout [ReadedNews]){
        guard let context = self.context else { return }
            //Заполнение массива array избранными блюдами
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //let context = appDelegate.persistentContainer.viewContext
            let fetch: NSFetchRequest<ReadedNews> = ReadedNews.fetchRequest()
            do {
                array = try context.fetch(fetch)
                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        
    }
    
    func saveNew(id: String, readedNews: inout [ReadedNews]){
        guard let context = context else { return }
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        let context = appDelegate.persistentContainer.viewContext
        let readNew = ReadedNews(context: context)
        readNew.id = id
        do {
            try context.save()
            readedNews.append(readNew)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
