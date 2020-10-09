import SwiftUI
import RealmSwift
import Firebase
import CoreData
import PDFKit

class GlobalEnviroment: ObservableObject {
    var managedObjectContext: NSManagedObjectContext?
   

    
    @Published var loadedDocuments: [DocumentModel] = []
    @Published var createdDocuments: [DocumentModel] = []
    @Published var personalData: [TextPersonalInfo] = []
    
    let dbReference: DatabaseReference!
    init() {
        dbReference = Database.database().reference()
        let ud = UserDefaults.standard
        
        let decoded = ud.data(forKey: "personalData")
        do {
            try personalData = NSKeyedUnarchiver.unarchivedObject(ofClasses: [TextPersonalInfo.self], from: decoded ?? Data()) as! [TextPersonalInfo]
        } catch {
            print(error)
        }
        
    }
    
    
    func downloadDocument(key: String, comletion: @escaping(Bool) -> Void) {
        DispatchQueue.main.async {
            self.dbReference.child("/shared/\(key)").observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                let url = value?["url"] as? String ?? ""
                
                var fields:[DocumentField] = []
                var document = DocumentModel(id: key, name: name, url: url)

                let fields_snap = snapshot.childSnapshot(forPath: "fields")
                for f_snap in fields_snap.children.allObjects as! [DataSnapshot] {
                    let val = f_snap.value as? NSDictionary
                    let rect = val?["rect"] as? NSDictionary
                    let x = rect?["x"] as? Double ?? 0
                    let y = rect?["y"] as? Double ?? 0
                    let width = rect?["width"] as? Double ?? 0
                    let height = rect?["height"] as? Double ?? 0
                    let rectan = CGRect(x: x, y: y, width: width, height: height)
                    print(rectan)
                    let type = val?["type"] as? String ?? ""
                    let desc = val?["desc"] as? String ?? ""
                    fields.append(DocumentField(rect: rectan, string: desc, type: fieldTypeFromString(type)))
                }
                print(fields)
                document.fieldsToFill = fields
                print(document.fieldsToFill)
                
                if url != "" {
                    let cdDoc = CDDocumentModel(context: self.managedObjectContext!)
                    cdDoc.id = document.id
                    cdDoc.groupMode = "0"
                    cdDoc.cdId = document.cdID
                    cdDoc.url = document.url ?? ""
                    cdDoc.name = document.name
                    do {
                        try self.managedObjectContext!.save()
                    } catch {
                        print(error)
                    }
                    
                    
                    for i in fields {
                        let f = CDDocumentField(context: self.managedObjectContext!)
                        f.desc = i.description
                        f.parent = document.cdID
                        f.type = stringFromFieldType(i.type)
                        f.x = "\(i.rect.origin.x)"
                        f.y = "\(i.rect.origin.y)"
                        f.width = "\(i.rect.width)"
                        f.height = "\(i.rect.height)"
                        do {
                            try self.managedObjectContext!.save()
                        } catch {
                            print(error)
                        }
                    }
                    self.loadedDocuments.append(document)

                   
                }
                
                comletion(true)
            })
        }
            
    }
    
    func shareDoucment(document: DocumentModel, completion: @escaping(String) -> Void) {
        DispatchQueue.main.async {
            self.dbReference.child("/shared/\(document.id)").setValue(["name": document.name, "url": document.url])
            var cnt: Int = 0
            for field in document.fieldsToFill {
                var rect: CGRect = field.rect
                self.dbReference.child("/shared/\(document.id)/fields/field\(cnt)/desc").setValue(field.description)
                self.dbReference.child("/shared/\(document.id)/fields/field\(cnt)/type").setValue(stringFromFieldType(field.type))
                self.dbReference.child("/shared/\(document.id)/fields/field\(cnt)/rect").setValue([
                    "width": rect.width,
                    "height": rect.height,
                    "x": rect.origin.x,
                    "y": rect.origin.y
                ])
                cnt += 1
            }
            completion(document.id)
        }
    }
    
    func appendField(docCDId: String, _ selection: PDFSelection, description: String, type: FieldType) {
        let newField = DocumentField(rect: selection.bounds(for: selection.pages[0]), string: description, type: type)
        print(newField.rect)
        
        let f = CDDocumentField(context: self.managedObjectContext!)
        f.desc = newField.description
        f.parent = docCDId
        f.type = stringFromFieldType(newField.type)
        f.x = "\(newField.rect.origin.x)"
        f.y = "\(newField.rect.origin.y)"
        f.width = "\(newField.rect.width)"
        f.height = "\(newField.rect.height)"
        do {
            try self.managedObjectContext!.save()
        } catch {
            print(error)
        }
        //(70.464, 765.29628, 99.0318, 19.263720000000035)
        for i in 0..<createdDocuments.count {
            if (createdDocuments[i].cdID == docCDId) {
                createdDocuments[i].addField(selection, description: description, type: type)
            }
        }
//        fieldsToFill.append(newField)
    }

    func addCreatedDocument(_ document: DocumentModel) {
        createdDocuments.append(document)
        for i in document.fieldsToFill {
            let f = CDDocumentField(context: self.managedObjectContext!)
            f.desc = i.description
            f.parent = document.cdID
            f.type = stringFromFieldType(i.type)
            f.x = "\(i.rect.origin.x)"
            f.y = "\(i.rect.origin.y)"
            f.width = "\(i.rect.width)"
            f.height = "\(i.rect.height)"
            do {
                try self.managedObjectContext!.save()
            } catch {
                print(error)
            }
        }
        let cdDoc = CDDocumentModel(context: self.managedObjectContext!)
        cdDoc.id = document.id
        cdDoc.groupMode = "1"
        cdDoc.cdId = document.cdID
        cdDoc.name = document.name
        cdDoc.url = document.url
        do {
            try self.managedObjectContext!.save()
        } catch {
            print(error)
        }
    }
  
    
    func loadDocuments(cdFields: FetchedResults<CDDocumentField>, cdDocuments: FetchedResults<CDDocumentModel>) {
        var downModels: [DocumentModel] = []
        var creatModels: [DocumentModel] = []

        for cdDocModel in cdDocuments {
            let dm = DocumentModel(id: cdDocModel.id ?? "", name: cdDocModel.name ?? "", url: cdDocModel.url ?? "")
            dm.cdID = cdDocModel.cdId ?? ""
            if (cdDocModel.groupMode == "0") {
                downModels.append(dm)
            } else {
                creatModels.append(dm)
            }
        }
        
        for cdFieldModel in cdFields {
            let x: Double = Double(cdFieldModel.x ?? "") ?? 0
            let y: Double = Double(cdFieldModel.y ?? "") ?? 0
            let width: Double = Double(cdFieldModel.width ?? "") ?? 0
            let height: Double = Double(cdFieldModel.height ?? "") ?? 0
            let type: FieldType = fieldTypeFromString(cdFieldModel.type ?? "")
            let f = DocumentField(rect: CGRect(x: x, y: y, width: width, height: height), string: cdFieldModel.desc ?? "", type: type)
            let par = cdFieldModel.parent ?? ""
            for i in 0..<downModels.count {
                if (downModels[i].cdID == par) {
                    downModels[i].fieldsToFill.append(f)
                }
            }
            for i in 0..<creatModels.count {
                if (creatModels[i].cdID == par) {
                    creatModels[i].fieldsToFill.append(f)
                }
            }
        }
        createdDocuments = creatModels
        loadedDocuments = downModels
    }
}

class TextPersonalInfo: ObservableObject, NSCoding {
    
    @Published var info: String?
    var type: FieldType
    var createdAt: Date
    init(_ info: String? = nil, type: FieldType, createdAt: Date) {
        self.info = info
        self.type = type
        self.createdAt = createdAt
    }
    
    init() {
        type = .custom
        createdAt = Date()
    }
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()

        guard let info = decoder.decodeObject(forKey: "info") as? String
        else {return nil }
        
        guard let type = decoder.decodeObject(forKey: "type") as? String
        else {return nil }
        
        guard let date = decoder.decodeObject(forKey: "date") as? String
        else {return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        
        self.info = info
        self.type = fieldTypeFromString(type)

        self.createdAt = dateFormatter.date(from: date) ?? Date()

    }

    func encode(with coder: NSCoder) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        coder.encode(stringFromFieldType(self.type), forKey: "type")
        coder.encode(info ?? "", forKey: "info")
        coder.encode(dateFormatter.string(from: createdAt), forKey: "date")

    }
}
