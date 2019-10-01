//
//  WorkWithCoreData.swift
//  AppNews
//
//  Created by Максим Лисица on 29/09/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit
import CoreData

/// Работа с CoreData
class CoreDataManager {
    
    var context: NSManagedObjectContext?
    
    /// Получить список прочтенных новостей
    ///
    /// - Parameter array: Все полученные новости присваются в этот массив
    func getReadedNews(array: inout [ReadedNews]){
        guard let context = self.context else { return }

        let fetch: NSFetchRequest<ReadedNews> = ReadedNews.fetchRequest()
        do {
            array = try context.fetch(fetch)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    /// Удалить все пометки о прочтенных новостях
    func deleteAllReadedNews() {
        guard let context = self.context else { return }

        let fetch: NSFetchRequest<ReadedNews> = ReadedNews.fetchRequest()
        do {
            let readedNews = try context.fetch(fetch)
            for news in readedNews {
                context.delete(news)
            }
            try context.save()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    /// Сохранить новость как прочтенную
    ///
    /// - Parameters:
    ///   - id: идентифатор прочтенной новости
    ///   - readedNews: массив прочтенных новостей
    func saveNew(id: String, readedNews: inout [ReadedNews]){
        guard let context = context else { return }
        
        let readNew = ReadedNews(context: context)
        readNew.id = id
        do {
            try context.save()
            readedNews.append(readNew)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Получить все сохраненные новости
    ///
    /// - Parameter array: все полученные новости заносятся в массив
    func getAllOfflineNews(in array: inout [NewOffline]){
        guard let context = context else { return }
        
        let fetch: NSFetchRequest<NewOffline> = NewOffline.fetchRequest()
        do {
            array = try context.fetch(fetch)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    /// Сохранить новость
    ///
    /// - Parameters:
    ///   - new: новость которую необходимо сохранить
    ///   - newsOffline: массив сохраненных новостей, который необходимо обновить
    func saveNewInOffline(new: NewsItem, newsOffline: inout [NewOffline]){
        guard let context = context else { return }
        
        let newInOffline = NewOffline(context: context)
        newInOffline.autor = new.author
        newInOffline.descriptionNew = new.description
        newInOffline.link = new.link
        newInOffline.title = new.title
        
        guard let urlString = new.pathToImage, let url = URL(string: urlString) else { return }
        
        if let data = try? Data(contentsOf: url) {
            newInOffline.image = data
        }
        
        guard let dateNew = new.pubDate else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss +zzzz"
        newInOffline.pubDate = dateFormatter.date(from: dateNew)
        
        do {
            try context.save()
            newsOffline.append(newInOffline)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Удалить новость из CoreData
    ///
    /// - Parameter new: новость для удаления в формате NewsItem
    func deleteNewOffline(new: NewsItem) {
        guard let context = context else { return }
        
        let fetch: NSFetchRequest<NewOffline> = NewOffline.fetchRequest()
        fetch.predicate = NSPredicate(format: "title = %@", new.title ?? "")
        
        do {
            let newDel = try context.fetch(fetch)
            guard let newForDelete = newDel.first else { return }
            context.delete(newForDelete)
            try context.save()
            print("Удалено")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Удалить конкретную новость из CoreData
    ///
    /// - Parameter newOffline: новость для удаленияя
    func deleteNewOffline(newOffline: NewOffline) {
        guard let context = context else { return }
        
        do {
            context.delete(newOffline)
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Удалить все сохраненные новости из CoreData
    func deleteAllOfflineNews(){
        guard let context = context else { return }
        
        let fetch: NSFetchRequest<NewOffline> = NewOffline.fetchRequest()
        
        do {
            let arrayOfflineNews = try context.fetch(fetch)
            for new in arrayOfflineNews {
                context.delete(new)
            }
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension NewOffline {
    /// Получить id
    ///
    /// - Returns: строка с идентификатором
    func getIdentifier() -> String?  {
        guard let id = link else { return nil }
        return id
    }
}
