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
    @State var selectedCase : ListView = .employed
    init(viewModel: PersonViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationView {
            VStack {
                // Picker to select the sectioning criteria
                Picker("Section By:", selection: $selectedCase) {
                    ForEach([ListView.profession, ListView.name, ListView.email, ListView.employed], id: \.self) { criteria in
                        Text(criteria.rawValue.capitalized).tag(criteria)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                ListSectionView(sectionedPersons: sectionedPersons)
                    .scrollContentBackground(.hidden)
            }
            .navigationTitle("Persons")
            .toolbar {
                NavigationLink(destination: AddUserView(viewModel: viewModel), label: {
                    Image(systemName: "plus")
                })
            }
        }
    }
    private var sectionedPersons: [SectionedPersons] {
            viewModel.getSectionedPersonsList(viewBy: selectedCase) ?? []
        }
}
    struct ListSectionView: View {
        var sectionedPersons: [SectionedPersons]

        var body: some View {
            List {
                ForEach(sectionedPersons, id: \.sectioner) { section in
                    Section(header: Text(section.sectioner)) {
                        ForEach(section.persons, id: \.id) { person in
                            VStack {
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
                                HStack(alignment: .center, spacing: 2.0) {
                                    Button(action: {
                                        // Set the selectedPerson when the Edit button is pressed
                                        // Handle Edit button action
                                    }) {
                                        Text("Edit")
                                            .padding(.all, 20.0)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .background(
                                                Color.blue
                                                    .shadow(radius: 10)
                                            )
                                            .cornerRadius(15.0)
                                            .shadow(radius: 14)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding()
                                    
                                    Button(action: {
                                        // Handle Delete button action
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
                                            .cornerRadius(15.0)
                                            .shadow(radius: 14)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding()
                                }
                                .padding(.horizontal, 60.0)
                                .scrollContentBackground(.hidden)
                            }
                        }
                    }
                }
            }
        }
    }



struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = PersonViewModel() // Create an instance of PersonViewModel
        return PersonView(viewModel: viewModel)
    }
}
