//
//  CreateDocumentView.swift
//  docRelay
//
//  Created by Глеб Завьялов on 03.05.2020.
//  Copyright © 2020 Глеб Завьялов. All rights reserved.
//

import SwiftUI

struct CreateDocumentView: View {
    @Binding var isPresented: Bool
    @Binding var createdData: [DocumentModel]
    
    @State var title = ""
    @State var url = ""
    @State var documentFields: [DocumentFieldModel] = []
    var body: some View {
        VStack {
            HStack {
                Button(action: {self.isPresented = false}) {
                    Text("Close")
                    
                }
                Spacer()
                Button(action: addDocument) {
                    Text("Add")
                }
                
            }.padding()
            
            List {
                TextField("Title", text: $title).padding()
                TextField("Document url", text: $url).padding()
            }
        }.onDisappear {
            self.isPresented = false
        }
    }
    
    func addDocument() {
        let documentModel = DocumentModel(title, documentFields, url: url)
        createdData.append(documentModel)
        self.isPresented = false
    }
}


