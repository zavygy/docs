//
//  DocumentFieldModel.swift
//  docRelay
//
//  Created by Глеб Завьялов on 01.05.2020.
//  Copyright © 2020 Глеб Завьялов. All rights reserved.
//

import Foundation
import Combine

class DocumentFieldModel: ObservableObject {
    @Published var type: PersonalInfoType
    @Published var descriptionPrefix: String?
    @Published var descriptionSuffix: String?
    @Published var prev: Int?
    @Published var next: Int?
    @Published var id: Int
    
    init(type: PersonalInfoType, _ prefix: String? = nil, _ suffix: String? = nil, _ prev: Int? = nil, _ next: Int? = nil, id: Int) {
        self.type = type
        self.descriptionPrefix = prefix
        self.descriptionSuffix = suffix
        self.prev = prev
        self.next = next
        self.id = id
    }
}

enum PersonalInfoType {
    case name
    case surname
    case passportSerial
    case addressCountry
    case addressCity
    case addressStreet
    case addressHouse
    case addressFlat
    case signature
    case any
}

func PersonalInfoTypeFormatter(fbstring: String) -> PersonalInfoType {
    var result: PersonalInfoType = .any
    switch fbstring {
        case "name":
            result = .name
        case "surname":
            result = .surname
        case "passportSerial":
            result = .passportSerial
        case "addressCountry":
            result = .addressCountry
        case "addressCity":
            result = .addressCity
        case "addressStreet":
            result = .addressStreet
        case "addressHouse":
            result = .addressHouse
        case "addressFlat":
            result = .addressFlat
        case "signature":
            result = .signature
        default:
            result = .any
    }
    return result
}

func PersonalInfoTypeFormatter(type: PersonalInfoType) -> String {
    var result: String = "any"
    switch type {
        case .name:
            result = "name"
        case .surname:
            result = "surname"
        case .passportSerial:
            result = "passportSerial"
        case .addressCountry:
            result = "addressCountry"
        case .addressCity:
            result = "addressCity"
        case .addressStreet:
            result = "addressStreet"
        case .addressHouse:
            result = "addressHouse"
        case .addressFlat:
            result = "addressFlat"
        case .signature:
            result = "signature"
        default:
            result = "any"
    }
    return result
}
