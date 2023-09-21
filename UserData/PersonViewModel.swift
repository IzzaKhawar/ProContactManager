//
//  PersonViewModel.swift
//  UserData
//
//  Created by apple on 9/15/23.
//

import SwiftUI
import CoreData
import UIKit

struct SectionedPersons {
    let isEmployed: Bool
    let persons: [Person]
}
class PersonViewModel: ObservableObject {
    
    @Published var persons: [Person] = []
    lazy var persistentContainer: NSPersistentContainer? = {
        let container = NSPersistentContainer(name: "PersonModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    init() {
        self.loadPersons()
    }

    func getSectionedPersonsList() -> [SectionedPersons]? {
        var sectionedPersonsList = [SectionedPersons]()

        guard let per = persistentContainer else {
            return sectionedPersonsList
        }

        let managedContext = per.viewContext

        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "employed", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let persons = try managedContext.fetch(fetchRequest)
            var sectionedPersonsDictionary = [Bool: [Person]]()

            for person in persons {
                let isEmployed = person.employed

                if sectionedPersonsDictionary[isEmployed] == nil {
                    sectionedPersonsDictionary[isEmployed] = [Person]()
                }

                sectionedPersonsDictionary[isEmployed]?.append(person)
            }

            for (isEmployed, personsInSection) in sectionedPersonsDictionary {
                let sectionedPersons = SectionedPersons(isEmployed: isEmployed, persons: personsInSection)
                sectionedPersonsList.append(sectionedPersons)
            }

            return sectionedPersonsList
        } catch let error as NSError {
            debugPrint("Error fetching data: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func loadPersons() {
        guard let per = persistentContainer else{
            return
        }
        let managedContext = per.viewContext
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        
        do {
            self.persons = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            debugPrint("Error fetching data: \(error.localizedDescription)")
        }
    }

    func savePerson(nameValue: String, emailValue: String, phoneValue: String, professionValue: String, isEmployed: Bool) {
        guard let per = persistentContainer else{
            return
        }
        let managedContext = per.viewContext
        let person = Person(context: managedContext)
        person.id = UUID()
        person.name = nameValue
        person.email = emailValue
        person.phoneNumber = phoneValue
        person.profession = professionValue
        person.employed = isEmployed

        do {
            try managedContext.save()
            self.loadPersons() // Reload data after saving
        } catch let error as NSError {
            debugPrint("Error saving data: \(error.localizedDescription)")
        }
    }
    func updatePerson(_ person: Person, with nameValue: String, emailValue: String, phoneValue: String, professionValue: String, isEmployed: Bool) {
        guard let per = persistentContainer else{
            return
        }
        let managedContext = per.viewContext
         person.name = nameValue
         person.email = emailValue
         person.phoneNumber = phoneValue
         person.profession = professionValue
         person.employed = isEmployed

         do {
             try managedContext.save()
             self.loadPersons() // Reload data after updating
         } catch let error as NSError {
             debugPrint("Error updating data: \(error.localizedDescription)")
         }
     }
     
     func deletePerson(_ person: Person) {
         guard let per = persistentContainer else{
             return
         }
         let managedContext = per.viewContext

         do {
             managedContext.delete(person)
             try managedContext.save()
             self.loadPersons() // Reload data after deleting
         } catch let error as NSError {
             debugPrint("Error deleting data: \(error.localizedDescription)")
         }
     }
    
}


//    func reverseOrder() -> [PersonDemo] {
//
//        persons.reverse()
//        return persons
//    }
//    func removeLastPerson() -> [PersonDemo] {
//
//        persons.removeLast()
//        return persons
//    }
//    func removeFirstPerson() -> [PersonDemo] {
//
//        persons.removeFirst()
//        return persons
//    }
//    func shuffleOrder() -> [PersonDemo] {
//
//        persons.shuffle()
//        return persons
//    }

