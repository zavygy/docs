//
//  DocumentModel.swift
//  documentRelay
//
//  Created by Глеб Завьялов on 14.08.2020.
//

import Foundation
import PDFKit
import CoreData

class DocumentModel: ObservableObject {
   
    let id: String // (key)
    @Published var name: String
    @Published var pdfData: Data? = nil
    @Published var url: String? = nil
    var cdID: String = UUID().uuidString
    
    @Published var fieldsToFill: [DocumentField] = []
    
    
    
    init(id: String, name: String, pdfData: Data) {
        self.id = id
        self.name = name
        self.pdfData = pdfData
    }
    
    init(id: String, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url

    }
    
    init(id: String, name: String, url: String, fields: [DocumentField]) {
        self.id = id
        self.name = name
        self.url = url
        self.fieldsToFill = fields
    }
    
    
    func addField(_ selection: PDFSelection, description: String, type: FieldType) {
        let newField = DocumentField(rect: selection.bounds(for: selection.pages[0]), string: description, type: type)
        
        print(newField.rect)
        //(70.464, 765.29628, 99.0318, 19.263720000000035)

        fieldsToFill.append(newField)
    }
    
    func addOverlay() {
        let pdfMeta = [
            kCGPDFContextCreator: "documentRelay",
            kCGPDFContextAuthor: "documentRelay"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMeta as [String : Any]
    }
    
}

class DocumentField: Identifiable, ObservableObject {
    
    
    let rect: CGRect
    let description: String
    @Published var fillWith: String? = nil
    let type: FieldType
    
    init(rect: CGRect, string: String, type: FieldType = .custom) {
        self.rect = rect
        self.description = string
        self.type =  type
    }
    
    func fill(_ with: String) {
        fillWith = with
    }
    
}

enum FieldType {
    case name
    case surname
    case namesurname
    case address
    case serial
    case number
    case custom
}

func fieldTypeFromString(_ from: String) -> FieldType {
        switch from {
        case "Имя":
            return .name
        case "Фамилия":
            return .surname
        case "ФИО":
            return .namesurname
        case "Адрес":
            return .address
        case "Серия":
            return .serial
        case "Номер":
            return .number
        case "Другое":
            return .custom
        default:
            return .custom
        }
}

func stringFromFieldType(_ from: FieldType) -> String {
        switch from {
        case .name:
            return "Имя"
        case .surname:
            return "Фамилия"
        case .namesurname:
            return "ФИО"
        case .address:
            return "Адрес"
        case .serial:
            return "Серия"
        case .number:
            return "Номер"
        case .custom:
            return "Другое"
        default:
            return "Другое"
        }
}


public class CDDocumentModel: NSManagedObject, Identifiable {
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var groupMode: String?
    @NSManaged public var cdId: String?
}

public class CDDocumentField: NSManagedObject, Identifiable {
    @NSManaged public var parent: String?
    @NSManaged public var desc: String?
    @NSManaged public var type: String?
    @NSManaged public var height: String?
    @NSManaged public var width: String?
    @NSManaged public var x: String?
    @NSManaged public var y: String?
}

public class CDPerData: NSManagedObject, Identifiable {
    @NSManaged public var info: String?
    @NSManaged public var type: String?
    @NSManaged public var createdAt: Date?   
}



extension CDDocumentField {
    static func getAllCDFields() -> NSFetchRequest<CDDocumentField> {
        let req: NSFetchRequest<CDDocumentField> = CDDocumentField.fetchRequest() as! NSFetchRequest<CDDocumentField>
        let sortDesc = NSSortDescriptor(key: "parent", ascending: true)
        req.sortDescriptors = [sortDesc]
        return req
    }
}

extension CDPerData {
    static func getAllCDData() -> NSFetchRequest<CDPerData> {
        let req: NSFetchRequest<CDPerData> = CDPerData.fetchRequest() as! NSFetchRequest<CDPerData>
        let sortDesc = NSSortDescriptor(key: "createdAt", ascending: true)
        req.sortDescriptors = [sortDesc]
        return req
    }
}



extension CDDocumentModel {
    static func getAllCDDocs() -> NSFetchRequest<CDDocumentModel> {
        let req: NSFetchRequest<CDDocumentModel> = CDDocumentModel.fetchRequest() as! NSFetchRequest<CDDocumentModel>
        let sortDesc = NSSortDescriptor(key: "groupMode", ascending: true)
        req.sortDescriptors = [sortDesc]
        return req
    }
}
