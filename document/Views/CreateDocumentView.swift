//
//  CreateDocumentView.swift
//  document
//
//  Created by Глеб Завьялов on 01.10.2020.
//

import SwiftUI

struct CreateDocumentView: View {
    @ObservedObject var globalEnviroment: GlobalEnviroment
    @State var documentName: String = ""
    @State var url: String = ""
    
    @State var documentPickerMode: Int = 1 // 1 - manual url, 0 - from local
    @State var pickerIsPresented: Bool = false
    
    @Binding var presentSelf: Bool
    
    let documentId: String = UUID().uuidString
    var body: some View {
        VStack {
            TextField("Name: ", text: $documentName).padding()
            HStack {
                Spacer()
                Picker(selection: $documentPickerMode, label: Text("")) {
                    Text("URL").tag(1)
                    Text("Document").tag(0)
                }.pickerStyle(SegmentedPickerStyle())
                Spacer()
            }.padding(.horizontal)
        if (documentPickerMode == 1) {
            TextField("URL: ", text: $url).padding(.horizontal)
        } else {
            Button("Pick document", action: pickDocument).padding()
                .sheet(isPresented: $pickerIsPresented, content: {
                    DocumentPicker(documentName: documentId, url: $url)
                        .ignoresSafeArea()
                })
        }
            Spacer()
            HStack {
                Spacer()
                Button("Create", action: create)
                Spacer()
            }
        }.padding(.top, 10)
    }
    
    func pickDocument() {
        pickerIsPresented = true
    }
    
    func create() {
        withAnimation {
            globalEnviroment.addCreatedDocument(DocumentModel(id: documentId, name: documentName, url: url))
            presentSelf = false
        }
    }
}

//struct CreateDocumentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateDocumentView(globalEnviroment: GlobalEnviroment(), presentSelf: $presSelf)
//    }
//}
