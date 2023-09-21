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
    
    init(viewModel: PersonViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(sectionedPersons, id: \.isEmployed) { section in
                    Section(header: Text(section.isEmployed ? "Employed" : "Unemployed")) {
                        ForEach(section.persons, id: \.self) { person in
                            VStack{
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
                                HStack (alignment: .center, spacing: 2.0, content: {
                                    
                                    Button(action: {
                                        // Set the selectedPerson when the Edit button is pressed
                                        self.selectedPerson = person
                                        // Trigger the navigation by setting userSelected to true
                                        self.userSelected.toggle()
                                        self.presentationMode.wrappedValue.dismiss()
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
                                            .cornerRadius(/*@START_MENU_TOKEN@*/15.0/*@END_MENU_TOKEN@*/)
                                            .shadow(radius: /*@START_MENU_TOKEN@*/14/*@END_MENU_TOKEN@*/)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding()
                                    Button(action: {
                                        viewModel.deletePerson(person)
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
                                        
                                    }                            .buttonStyle(PlainButtonStyle())
                                        .padding()
                                    
                                })
                                .padding(.horizontal, 60.0)
                                
                                .scrollContentBackground(.hidden)
                                NavigationLink(destination: EditPersonView(viewModel: viewModel, person: selectedPerson ?? person), isActive: $userSelected) {
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
                
            }
            .scrollContentBackground(.hidden)
                .navigationTitle("Persons")
                .toolbar {
                    NavigationLink(destination: AddUserView(viewModel: viewModel), label: {
                        Image(systemName: "plus")
                    })
                }
        }
    }
        private var sectionedPersons: [SectionedPersons] {
            viewModel.getSectionedPersonsList() ?? []
        }
    }
    
    struct PersonView_Previews: PreviewProvider {
        static var previews: some View {
            let viewModel = PersonViewModel() // Create an instance of PersonViewModel
            return PersonView(viewModel: viewModel)
        }
    }
