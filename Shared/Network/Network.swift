//
//  Network.swift
//  ViteMaDose (iOS)
//
//  Created by Yannick Heinrich on 07/04/2021.
//

import Foundation
import Combine
enum DateError: String, Error {
    case invalidDate
}

let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)

        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        if let date = formatter.date(from: dateStr) {
            return date
        }
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        if let date = formatter.date(from: dateStr) {
            return date
        }
        throw DateError.invalidDate
    })
    return decoder
}()

let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()


final class APIClient {

    let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Base URL

    private let baseHostURL = URL(string: "https://raw.githubusercontent.com/CovidTrackerFr/vitemadose/data-auto/data/output")!

    private func getOutputFile<T: Decodable>(for name: String) -> AnyPublisher<T, Error> {
        let url = baseHostURL.appendingPathComponent(name)
        return self.session.dataTaskPublisher(for: url).tryMap { response in
            return try decoder.decode(T.self, from: response.data)
        }.eraseToAnyPublisher()
    }

    func getDepartments() -> AnyPublisher<DepartmentResource, Error> {
        return self.getOutputFile(for: "departements.json")
    }

    func getDepartmentData(department: DepartmentResourceElement) -> AnyPublisher<CenterResources, Error> {
        return self.getOutputFile(for: "\(department.codeDepartement).json")
    }
}
