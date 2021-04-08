//
//  ListDepartment.swift
//  ViteMaDose (iOS)
//
//  Created by Yannick Heinrich on 07.04.21.
//

import SwiftUI

struct ListDepartment: View {

    @Binding var availableDepartments: DepartmentResource
    @Binding var selectedDepartment: DepartmentResourceElement?
    var selectedAction: (DepartmentResourceElement?) -> Void
    var body: some View {
        List {
            Section(header: Text("Choix du département")) {
                ForEach(availableDepartments) { department in
                    HStack {
                        Text(department.nomDepartement)
                        Spacer()
                        if let selected = selectedDepartment, department == selected {
                            Image(systemName: "checkmark").foregroundColor(.green)
                        }
                    }.background(Color(UIColor.secondarySystemGroupedBackground))
                    .onTapGesture {
                        selectedAction(department)
                    }
                }
            }
        }.listStyle(InsetGroupedListStyle())
    }
}

