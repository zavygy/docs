//
//  DocumentModel.swift
//  docRelay
//
//  Created by Глеб Завьялов on 01.05.2020.
//  Copyright © 2020 Глеб Завьялов. All rights reserved.
//

import Foundation
import Combine

class DocumentModel: Identifiable, ObservableObject {
    
    @Published var title: String
    @Published var fields: [DocumentFieldModel]
    @Published var docUrl: String
    @Published var id: UUID
    
    init(_ title: String, _ fields: [DocumentFieldModel], url: String) {
        self.title = title
        self.fields = fields
        self.docUrl = url
        id = UUID()
    }
}
