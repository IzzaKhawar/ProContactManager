//
//  PersonViewModel.swift
//  UserData
//
//  Created by apple on 9/15/23.
//

import SwiftUI
import CoreData
import UIKit

enum ListView: String {
    case profession, name, email, employed
}

struct SectionedPersons {
    let sectioner: String
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

    func getSectionedPersonsList(viewBy criteria: ListView) -> [SectionedPersons]? {
         var sectionedPersonsList = [SectionedPersons]()

         guard let per = persistentContainer else {
             return sectionedPersonsList
         }

         let managedContext = per.viewContext

         let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()

         let sortDescriptor: NSSortDescriptor

         switch criteria {
         case .profession:
             sortDescriptor = NSSortDescriptor(key: "profession", ascending: true)
         case .name:
             sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
         case .email:
             sortDescriptor = NSSortDescriptor(key: "email", ascending: true)
         case .employed:
             sortDescriptor = NSSortDescriptor(key: "employed", ascending: true)
         }

         fetchRequest.sortDescriptors = [sortDescriptor]

         do {
             let persons = try managedContext.fetch(fetchRequest)
             var sectionedPersonsDictionary = [String: [Person]]()

             for person in persons {
                 let sectioner: String

                 switch criteria {
                 case .profession:
                     sectioner = person.profession ?? "Unknown"
                 case .name:
                     sectioner = person.name ?? "Unknown"
                 case .email:
                     sectioner = person.email ?? "Unknown"
                 case .employed:
                     sectioner = person.employed ? "Employed" : "Unemployed"
                 }

                 if sectionedPersonsDictionary[sectioner] == nil {
                     sectionedPersonsDictionary[sectioner] = [Person]()
                 }

                 sectionedPersonsDictionary[sectioner]?.append(person)
             }

             for (sectioner, personsInSection) in sectionedPersonsDictionary {
                 let sectionedPersons = SectionedPersons(sectioner: sectioner, persons: personsInSection)
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

