//
//  DetailedLoadedDocumentModel.swift
//  document
//
//  Created by Глеб Завьялов on 03.10.2020.
//

import SwiftUI

struct DetailedLoadedDocumentModel: View {
    @ObservedObject var globalEnviroment: GlobalEnviroment
    @ObservedObject var document: DocumentModel
    @State var showSheet = false
    @State var pageState = 0
//    let activityViewController = SwiftUIActivityViewController()
    @State var data: Data?
    @State var completeArray: [String] = []
    @State var fillWith: String = ""
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Picker(selection: $pageState, label: Text("")) {
                        Text("Fields").tag(0)
                        Text("Document").tag(1)
                    }.pickerStyle(SegmentedPickerStyle())
                    Spacer()
                }
                if (pageState == 0) {
                    List {
                        ForEach(0..<document.fieldsToFill.count) { i in
                            HStack {
                                VStack {
                                    HStack {
                                        let field = document.fieldsToFill[i]
                                        Text(field.description).font(.subheadline).foregroundColor(.secondary)
                                        Spacer()
                                    }
                                    TextField("Data: ", text: Binding(get: {
                                        completeArray[i]
                                    }, set: { newVal in
                                       completeArray[i] = newVal
                                    }))
//                                    .foregroundColor(.primary)
                                }
                            }.padding()
                        }
                    }
                    
                } else {
                    PDFRelay(globalEnviroment: globalEnviroment, document: document)
                        .background(Color(UIColor.systemBackground)).clipped()
                }
                
                
                if (showSheet) {
                    SwiftUIActivityViewController(data: data!, showing: $showSheet)
                }
                    
                    
                
            }.navigationBarTitle(document.name)
            .navigationBarItems(trailing: Button(action: {
                
                for i in 0..<document.fieldsToFill.count {
                    document.fieldsToFill[i].fillWith = completeArray[i]
                }
                
                let fileManager = FileManager.default
                let path = globalEnviroment.addOverlay(docModel: document)
                print(path)
                if fileManager.fileExists(atPath: path) {
                    
                    let doc =  NSData(contentsOfFile: path)
                    data = doc as Data?
                    showSheet = true
                  
                }
                
            }) {
               Text("Share")
//                Image(systemName: "square.and.arrow.up")
//                    .padding(.trailing, 2)
                  
            })
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        for i in 0..<document.fieldsToFill.count {
                            let f = document.fieldsToFill[i]
                            for model in globalEnviroment.personalData {
                                if (f.type == model.type) {
                                    completeArray[i] = model.info ?? ""
                                }
                            }
                
                        }
                        
//                        globalEnviroment.addOverlay(docModel: document)
                    
                    }) {
                        Text("Autocomplete").padding(5)
                    }.background(Color(UIColor.systemBackground))
                    .cornerRadius(5)
                    Spacer()
                }
            }
            
        }
    }
}

class CompleteRelay: ObservableObject {
    @Published var fillWith: [String] = []
}

//struct DetailedLoadedDocumentModel_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailedLoadedDocumentModel()
//    }
//}
