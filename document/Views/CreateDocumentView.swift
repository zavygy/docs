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
    @State var uplodingDocument: Bool = false
    @State var documentPickerMode: Int = 1 // 1 - manual url, 0 - from local
    @State var pickerIsPresented: Bool = false
    @State var isDocPicked: Bool = false
    
    @Binding var presentSelf: Bool
    
    let documentId: String = UUID().uuidString
    var body: some View {
        VStack {
            List {
                Section{}
                
                Section(header: Text("Name")) {
                    TextField("Name: ", text: $documentName).padding(.horizontal)
                }
                
                Section(header: Text("Pick PDF")) {
                    VStack {
                        HStack {
                            Spacer()
                            Picker(selection: $documentPickerMode, label: Text("")) {
                                Text("URL").tag(1)
                                Text("Document").tag(0)
                            }.pickerStyle(SegmentedPickerStyle())
                            Spacer()
                        }.padding(.horizontal)
                    
                        VStack {
                            if (documentPickerMode == 1) {
                                TextField("URL: ", text: $url).padding()
                            } else {
                                if (uplodingDocument) {
                                    HStack {
                                        Spacer()
                                        ProgressView("Uploading")
                                        Spacer()
                                    }.padding()
                                } else {
                                    Button("Pick document", action: pickDocument).padding()
                                        .buttonStyle(PlainButtonStyle())
                                        
                                }
                            }
                        }
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button("Create", action: create)
                           
                            .sheet(isPresented: $pickerIsPresented,content: {
                                DocumentPicker(documentName: documentId, url: Binding(
                                    get: { self.url },
                                    set: { (newValue) in
                                        if (newValue != "") {
                                            self.documentPickerMode = 1
                                        }
                                        self.url = newValue
                                        self.uplodingDocument = false
                                           
                                        
                                    }), isDocPicked: $isDocPicked)
                                    .ignoresSafeArea()
                            })
                        Spacer()
                    }
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            .padding(.bottom)
          
        
           
        }
    }
    
    func pickDocument() {
        withAnimation {
            pickerIsPresented = true
            uplodingDocument = true
        }
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
