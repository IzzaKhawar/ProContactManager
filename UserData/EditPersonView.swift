//
//  EditPersonView.swift
//  UserData
//
//  Created by apple on 9/20/23.
//
import SwiftUI

struct EditPersonView: View {
    @ObservedObject var viewModel: PersonViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String
    @State private var email: String
    @State private var phoneNumber: String
    @State private var profession: String
    @State private var isEmployed: Bool
    let person: Person
    
    init(viewModel: PersonViewModel, person: Person) {
        self.viewModel = viewModel
        self._name = State(initialValue: person.name ?? "")
        self._email = State(initialValue: person.email ?? "")
        self._phoneNumber = State(initialValue: person.phoneNumber ?? "")
        self._profession = State(initialValue: person.profession ?? "")
        self._isEmployed = State(initialValue: person.employed)
        self.person = person
    }
    
    var body: some View {
        Form {
            TextField("Name : ", text: $name)
            TextField("Email : ", text: $email)
            TextField("Phone Number : ", text: $phoneNumber)
            TextField("Profession : ", text: $profession)
            Toggle("Employed : ", isOn: $isEmployed)
            Button("Save"){
                
            }
            .frame(width: 40,height: 30, alignment: .center)
            .onTapGesture {
                viewModel.updatePerson(person, with: name, emailValue: email, phoneValue: phoneNumber, professionValue: profession, isEmployed: isEmployed)
                self.presentationMode.wrappedValue.dismiss()
            }
            
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .font(.headline)
            .background(
                Color.blue
            )
            .cornerRadius(16)
        }
//        .grayscale(0.20)
//        .font(.subheadline)
//        .fontWeight(.semibold)
        .frame(height: 350)
        .scrollContentBackground(.hidden)
        
    }
}
