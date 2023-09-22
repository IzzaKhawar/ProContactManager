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
                Picker("Section By:", selection: $selectedCase) {
                    ForEach([ListView.all,
                             ListView.name,
                             ListView.email,
                             ListView.profession,
                             ListView.employed], id: \.self) { criteria in
                        Text(criteria.rawValue.capitalized).tag(criteria)
                    }
                }
                .padding(.horizontal, 10.0)
                .frame(height: 20, alignment: .top)
                .pickerStyle(SegmentedPickerStyle())
                .navigationTitle("Persons")
                .toolbar {
                    NavigationLink(destination: AddUserView(viewModel: viewModel), label: {
                        Image(systemName: "plus")
                    })
                }
                
                if selectedCase.rawValue == "all" {
                    List {
                        ForEach(viewModel.persons, id: \.id) { person in
                            VStack {
                                PersonInfoView(person: person)
                                Spacer()
                                ActionButtonsView(viewModel: viewModel, person: person)
                                
                            }
                            .id(person.id)
                        }
                    }
                } else {
                    List {
                        ForEach(sectionedPersons, id: \.sectioner) { section in
                            Section(header: Text(section.sectioner)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.black)
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
                    }
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
        .scrollContentBackground(.hidden)
        
    }
}

//struct FillButton: View {
//    let title: String
//    let color: Color
//    let onSubmit: () -> Void
//    var body: some View {
//        Button(action: {onSubmit()}, label: {
//            Text(title)
//                .frame(height: 56)
//                .frame(maxWidth: .infinity)
//                .background(color)
//                .cornerRadius(16)
//                .foregroundColor(.white)
//                .font(.headline)
//        })
//    }
//}
struct ActionButtonsView: View {
    @ObservedObject var viewModel: PersonViewModel
    @State private var userSelected: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPerson: Person?
    @State private var isDeleted: Bool = false
    var person: Person
    
    var body: some View {
        HStack (alignment: .center, spacing: 4, content: {
            
            Button(action: {
                // Set the selectedPerson when the Edit button is pressed
                self.selectedPerson = person
                // Trigger the navigation by setting userSelected to true
                self.userSelected.toggle()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Edit")
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
            Button(action: {
                viewModel.deletePerson(person)
                isDeleted.toggle()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Delete")
                    .frame(height: 56)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .font(.headline)
                    .background(
                        Color.red
                    )
                    .cornerRadius(16)

                
            }
            
        })
        NavigationLink("",destination: EditPersonView(viewModel: viewModel, person: selectedPerson ?? person), isActive: $userSelected)
        
    }
}
struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PersonViewModel() // Create an instance of PersonViewModel
        return PersonView(viewModel: viewModel)
    }
}
