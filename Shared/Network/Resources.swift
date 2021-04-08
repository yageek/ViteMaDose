//
//  Resources.swift
//  ViteMaDose (iOS)
//
//  Created by Yannick Heinrich on 07/04/2021.
//

import Foundation

// MARK: - DepartmentResourceElement
struct DepartmentResourceElement: Codable, Identifiable, Hashable {
    let codeDepartement, nomDepartement: String
    let codeRegion: Int
    let nomRegion: String

    enum CodingKeys: String, CodingKey {
        case codeDepartement = "code_departement"
        case nomDepartement = "nom_departement"
        case codeRegion = "code_region"
        case nomRegion = "nom_region"
    }

    var id: String {
        return self.codeDepartement
    }
}

typealias DepartmentResource = [DepartmentResourceElement]


// MARK: - CenterResources
struct CenterResources: Codable {
    let version: Int
    let lastUpdated: String
    let centresDisponibles, centresIndisponibles: [CentresDisponible]

    enum CodingKeys: String, CodingKey {
        case version
        case lastUpdated = "last_updated"
        case centresDisponibles = "centres_disponibles"
        case centresIndisponibles = "centres_indisponibles"
    }
}

// MARK: - CentresDisponible
struct CentresDisponible: Codable, Identifiable {
    let departement, nom: String
    let url: String
    let plateforme: Plateforme
    let prochainRdv: Date?

    enum CodingKeys: String, CodingKey {
        case departement, nom, url, plateforme
        case prochainRdv = "prochain_rdv"
    }
    var id: String {
        return url
    }
}

enum Plateforme: String, Codable {
    case autre = "Autre"
    case doctolib = "Doctolib"
    case maiia = "Maiia"
    case ordoclic = "Ordoclic"
    case keldoc = "Keldoc"
}
