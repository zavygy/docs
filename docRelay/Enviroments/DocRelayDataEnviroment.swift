//
//  DocRelayDataEnviroment.swift
//  docRelay
//
//  Created by Глеб Завьялов on 01.05.2020.
//  Copyright © 2020 Глеб Завьялов. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import Firebase

class DocRelayDataEnviroment: ObservableObject {
    @Published var loadedDocuments: [DocumentModel] = []
    @Published var createdDocuments: [DocumentModel] = [DocumentModel("Hello", [], url: "apple.com")]
    var reference: DatabaseReference!
    
    init() {
        reference = Database.database().reference()
        loadDocument("test0", completion: {document in
            if (document != nil) {
                self.loadedDocuments.append(document!)
            }
        })
    }
    
    func loadDocument(_ byId: String, completion: @escaping(DocumentModel?) -> Void){
        reference.child("documents").child(byId).observeSingleEvent(of: .value, with: {(snapshot) in
            let modelDict = snapshot.value as? NSDictionary
            
            let title: String = modelDict?["title"] as? String ?? ""
            let url: String = modelDict?["url"] as? String ?? ""
            
            let fieldsSnapshot = snapshot.childSnapshot(forPath: "fields")
            
            var fieldModels: [DocumentFieldModel] = []
            for fieldSnap in fieldsSnapshot.children {
                let fieldData = fieldSnap as? DataSnapshot
                let fieldDict = fieldData?.value as! NSDictionary
                let type = fieldDict["type"] as? String ?? "any"
                let prefix = fieldDict["prefix"] as? String ?? ""
                let suffix = fieldDict["suffix"] as? String ?? ""
                let prev = fieldDict["prev"] as? String ?? "begin"
                let next = fieldDict["next"] as? String ?? "end"
                let id = fieldDict["id"] as? Int ?? 0
                fieldModels.append(DocumentFieldModel(type: PersonalInfoTypeFormatter(fbstring: type), prefix, suffix, Int(prev), Int(next), id: id))
                
            }
            
            completion(DocumentModel(title, fieldModels, url: url))
        }) {(error) in
            print(error)
            completion(nil)
        }
        
    }
}
