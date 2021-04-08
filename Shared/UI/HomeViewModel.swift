//
//  HomeViewModel.swift
//  ViteMaDose (iOS)
//
//  Created by Yannick Heinrich on 07/04/2021.
//

import Foundation
import Combine

final class HomeViewModel:  ObservableObject {

    @Published var availableDepartments: DepartmentResource = []

    @Published var selectedDepartment: DepartmentResourceElement?

    @Published var centers: CenterResources?

    @Published var errorOccured: Error?
    

    private var subscriptions: Set<AnyCancellable> = Set()

    init() {
        let client = APIClient()
        // Observe the updates
        self.$selectedDepartment.compactMap { $0 }
            .flatMap { client.getDepartmentData(department: $0) }
            .receive(on: DispatchQueue.main)
            .sink { (result) in
                if case .failure(let error) = result {
                    print("Error: \(error)")
                    self.errorOccured = error
                    self.selectedDepartment = nil
                    self.centers = nil
                }
            } receiveValue: { (resources) in
                self.centers = resources
            }.store(in: &self.subscriptions)


        // Load the departments
        client.getDepartments()
            .receive(on: DispatchQueue.main)
            .sink { (result) in
            if case .failure(let error) = result {
                print("Download error: \(error.localizedDescription)")
                self.errorOccured = error
                self.selectedDepartment = nil
                self.centers = nil

            }
        } receiveValue: { (value) in
            self.availableDepartments = value
        }.store(in: &self.subscriptions)

    }
}
