//
//  FormView.swift
//  UserData
//
//  Created by apple on 9/15/23.
//

import SwiftUI

struct FormView: View {
    
    var body: some View {
        TextField( "Name: " , text: Person.name )
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
    }
}
