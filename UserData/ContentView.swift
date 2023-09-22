//
// PersonView.swift
// UserData
//
// Created by apple on 9/15/23.
//
import CoreData
import SwiftUI
struct PersonView: View {
    
    
    @ObservedObject var viewModel: PersonViewModel
    @State private var selectedPerson: Person?
    @State private var userSelected: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State var selectedCase : ListView = .all
    init(viewModel: PersonViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
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
            .frame(height: 20 , alignment: .top)
            .pickerStyle(SegmentedPickerStyle())
            .navigationTitle("Persons")
            .toolbar {
                NavigationLink(destination: AddUserView(viewModel: viewModel), label: {
                    Image(systemName: "plus")
                })
            }
        }
        .frame( height: /*@START_MENU_TOKEN@*/190.0/*@END_MENU_TOKEN@*/ , alignment: .top)
        if (selectedCase.rawValue == "all") {
            ListedView(viewModel: viewModel)
        }
        else{
            ListSectionView(viewModel: viewModel,sectionedPersons: sectionedPersons)
                .scrollContentBackground(.hidden)
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

struct ActionButtonsView: View {
    @ObservedObject var viewModel: PersonViewModel
    @State private var userSelected: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPerson: Person?
    @State private var isDeleted: Bool = false
    var person: Person
    
    var body: some View {
        HStack (alignment: .center, spacing: 2.0, content: {
            
            Button(action: {
                // Set the selectedPerson when the Edit button is pressed
                self.selectedPerson = person
                // Trigger the navigation by setting userSelected to true
                self.userSelected.toggle()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Edit")
                    .padding(.horizontal, 30.0)
                    .padding(/*@START_MENU_TOKEN@*/.vertical, 20.0/*@END_MENU_TOKEN@*/)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .background(
                        Color.blue
                            .shadow(radius: 10)
                    )
                    .cornerRadius(/*@START_MENU_TOKEN@*/15.0/*@END_MENU_TOKEN@*/)
                    .shadow(radius: /*@START_MENU_TOKEN@*/14/*@END_MENU_TOKEN@*/)
                
            }
            .frame(width: 100.0, height: 40.0)
            .buttonStyle(PlainButtonStyle())
            .padding()
            Button(action: {
                viewModel.deletePerson(person)
                isDeleted.toggle()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Delete")
                    .padding(.all, 20.0)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .background(
                        Color.red
                            .shadow(radius: 10)
                    )
                    .cornerRadius(/*@START_MENU_TOKEN@*/15.0/*@END_MENU_TOKEN@*/)
                    .shadow(radius: /*@START_MENU_TOKEN@*/14/*@END_MENU_TOKEN@*/)
                
            }  .frame(width: 100.0, height: 40.0)
                .buttonStyle(PlainButtonStyle())
                .padding()
            
        })
        .padding(.horizontal, 60.0)
        
        .scrollContentBackground(.hidden)
        NavigationLink("",destination: EditPersonView(viewModel: viewModel, person: selectedPerson ?? person), isActive: $userSelected)
        
            .padding(.horizontal, 60.0)
            .scrollContentBackground(.hidden)
        
    }
}

struct ListSectionView: View {
    @ObservedObject var viewModel: PersonViewModel
    var sectionedPersons: [SectionedPersons]
    @State private var userSelected: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPerson: Person?
    @State private var isDeleted: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sectionedPersons, id: \.sectioner) { section in
                    Section(header: Text(section.sectioner)) {
                        ForEach(section.persons, id: \.id) { person in
                            VStack {
                                PersonInfoView(person: person)
                                ActionButtonsView(viewModel: viewModel, person: person)
                            }
                        }
                    }
                }
            }
        }
    }
}
struct ListedView: View{
    @ObservedObject var viewModel: PersonViewModel = PersonViewModel()
    @State private var selectedPerson: Person?
    @State private var userSelected: Bool = false
    @Environment(\.presentationMode) var presentationMode
    init(viewModel: PersonViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationView{
            List {
                ForEach(viewModel.persons, id: \.id) { person in
                    VStack {
                        PersonInfoView(person: person)
                        ActionButtonsView(viewModel: viewModel, person: person)
                    }
                }
            } .scrollContentBackground(.hidden)
        }
    }
}




struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PersonViewModel() // Create an instance of PersonViewModel
        return PersonView(viewModel: viewModel)
    }
}
