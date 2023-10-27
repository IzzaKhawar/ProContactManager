//
// PersonView.swift
// UserData
//
// Created by apple on 9/15/23.
//
import CoreData
import SwiftUI

struct PersonView: View {
    @ObservedObject var viewModel = PersonViewModel()
    @State private var selectedPerson: Person?
    @State private var userSelected: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State var selectedCase: ListView = .all
    @State var navigateToAddUser = false
    @State var isDeleted: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Picker to select the sectioning criteria
//
                Picker("Section By:", selection: $selectedCase) {
                    ForEach([ListView.all,
                             ListView.name,
                             ListView.email,
                             ListView.profession,
                             ListView.employed], id: \.self) { criteria in
                        Text(criteria.rawValue.capitalized)
                            .tag(criteria)
                            
                    }
                }
                .padding(.horizontal, 4.0)
                .frame(height: 36, alignment: .top)
                .pickerStyle(SegmentedPickerStyle())
                .navigationTitle("Persons")
                .toolbar {
                    NavigationLink(destination: AddUserView(viewModel: viewModel), label: {
                        Image(systemName: "plus")
                    })
                }
                .font(.headline)
                
                if selectedCase.rawValue == "all" {
                    List {
                        ForEach(viewModel.persons, id: \.id) { person in
                            VStack {
                                PersonInfoView(person: person)
                                Spacer()
                                ActionButtonsView(viewModel: viewModel,  person: person)
                                
                            }
                            .id(person.id)
                        }
                    }.scrollContentBackground(.hidden)
                } else {
                    List {
                        ForEach(sectionedPersons, id: \.sectioner) { section in
                            Section(header: Text(section.sectioner)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
                                .underline(true, pattern: .solid , color: Color.black)
                            ) {
                                ForEach(section.persons, id: \.id) { person in
                                    VStack {
                                        PersonInfoView(person: person)
                                        
                                        Spacer()
                                        
                                        ActionButtonsView(viewModel: viewModel, person: person)
                                        
                                    }
                                    .id(person.id)
                                }
                            }
                        }
                    }.scrollContentBackground(.hidden)
                }
            }
        }
    }
    
    private var sectionedPersons: [SectionedPersons] {
        viewModel.getSectionedPersonsList(viewBy: selectedCase) ?? []
    }
    
}



struct PersonInfoView: View {
    var person: Person
    
    var body: some View {
        HStack {
            Text(person.name ?? "")
            Spacer()
            Text(person.email ?? "")
            Spacer()
            Text(person.profession ?? "")
            Spacer()
            Text(person.phoneNumber ?? "")
            Spacer()
            Text(person.employed ? "Employed" : "Unemployed")
        }
        .frame(height: 24)
        
        .font(.system(size: 18))
        .scrollContentBackground(.hidden)
        
    }
}



struct ActionButtonsView: View {
    @ObservedObject var viewModel: PersonViewModel
    @State private var userSelected: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPerson: Person?
    @State private var personToDelete: Person?
    @State private var isDeleted: Bool = false
    @State var person: Person
    
    var body: some View {
        HStack (alignment: .center, spacing: 10, content: {
           
            Button{
                // Set the selectedPerson when the Edit button is pressed
                self.selectedPerson = person
                // Trigger the navigation by setting userSelected to true
                self.userSelected.toggle()
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Label("Edit", systemImage: "pencil")
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .font(.headline)
                    .background(
                        Color.blue
                    )
                    .cornerRadius(16)

                
            }
            .buttonStyle(PlainButtonStyle())
            
            
            
            Spacer()
            
            Button {
                // Action on button click
                self.personToDelete = person
                self.isDeleted.toggle()
                self.presentationMode.wrappedValue.dismiss()
                if personToDelete?.id != nil, isDeleted {
                    viewModel.deletePerson(personToDelete ?? person)
                }
            } label: {
                Label("Delete", systemImage: "trash")
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .font(.headline)
                    .background(Color.red)
                    .cornerRadius(16)
            }
            .buttonStyle(PlainButtonStyle())
            
        })
        
        if selectedPerson?.id != nil{
            NavigationLink("",destination: EditPersonView(viewModel: viewModel, person: selectedPerson ?? person ), isActive: $userSelected)
                .hidden()
        }
        
    }
    
    func  deletePerson(person:Person){
        viewModel.deletePerson(person)
    }
}
struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PersonViewModel() // Create an instance of PersonViewModel
        return PersonView(viewModel: viewModel)
    }
}
