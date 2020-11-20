//
//  DetailedLoadedDocumentModel.swift
//  document
//
//  Created by Глеб Завьялов on 03.10.2020.
//

import SwiftUI

struct DetailedLoadedDocumentModel: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let width = UIScreen.main.bounds.width
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
                Button(action:{
                    withAnimation {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }){
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .renderingMode(.original)
                            .font(.body)
                            .accentColor(.primary)
                        Text("Back")
                            .foregroundColor(.primary)
                            .fontWeight(.medium)
//                            .padding(.trailing, 2)
                    }.padding(.horizontal)
                    .padding(.vertical, 2)
                    
                }
//                .background(Color(r: 255, g: 193, b: 87))
                .cornerRadius(4)
                Spacer()
                
                Button(action:{
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
                }){
                    HStack(spacing: 8) {
                        Text("Share")
                            .foregroundColor(.primary)
                            .fontWeight(.medium)
//                            .padding(.trailing, 2)
                    }.padding(.horizontal)
                    .padding(.vertical, 2)
                    
                }
//                .background(Color(r: 255, g: 193, b: 87))
                .cornerRadius(4)
                
            }
            .padding(.top)
            
            HStack {
                Text(document.name)
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
            }.padding(.horizontal)
                
        
            HStack {
                CompleteDocumentSegmentedControl(myCreatedState: $pageState)
                Spacer()
            }.padding(.horizontal)
            .padding(.top, -6)
            VStack {
                
                if (pageState == 0) {
                    
                    ScrollView {
                        ForEach(0..<document.fieldsToFill.count) { i in
                            let field = document.fieldsToFill[i]
                            InputForm(description: field.description, input: Binding(get: {
                                completeArray[i]
                            }, set: { newVal in
                               completeArray[i] = newVal
                            }))
                            .background(Color(UIColor.systemBackground))
                            .clipped()
                            .cornerRadius(8)
                            .shadow(color: Color(r: 230, g: 230, b: 230)!, radius: 4, x: 0, y: 0)
                            .padding(.horizontal, 18)
                            .padding(.top, 8)

                           
                        }
                        Text("").frame(height: 200)
                    }.padding(.top, 18)
                    
                } else {
                    PDFRelay(globalEnviroment: globalEnviroment, document: document, addFieldAbility: false)
                            .background(Color(.clear)).clipped()
                    
                }
                
                
                if (showSheet) {
                    SwiftUIActivityViewController(data: data!, showing: $showSheet)
                }
                Spacer()
                    
                    
                
            }.navigationBarHidden(true)
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
            
        
        }
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
                    HStack {
                        Spacer()
                        Text("Autocomplete")
                            .font(.headline)
                            .bold()
                            .accentColor(.white)
                            .padding(.vertical, 13)
                        Spacer()
                        
                    }
                }.clipped()
                .background(Color(r: 17, g: 17, b: 17))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 4)
                Spacer()
            }
            }
        }
    }
}

struct InputForm: View {
    @State var description: String
    @Binding var input: String
    var body: some View {
        VStack {
            HStack {
                Text("\(description)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
                Spacer()
            }
            TextField("...", text: $input)
        }.padding()
    }
}

struct FixedInputForm: View {
    @State var description: String
    @State var input: String
    var body: some View {
        VStack {
            HStack {
                Text("\(description)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
                Spacer()
            }
            HStack {
                Text("\(input)")
                Spacer()
            }.padding(.top, 2)
        }.padding()
    }
}


class CompleteRelay: ObservableObject {
    @Published var fillWith: [String] = []
}

struct DetailedLoadedDocumentModel_Previews: PreviewProvider {
    static var previews: some View {
        DetailedLoadedDocumentModel(globalEnviroment: GlobalEnviroment(), document: DocumentModel(id: "iddd", name: "Title", url: "https://firebasestorage.googleapis.com/v0/b/document-relay.appspot.com/o/0C9B4909-3EF7-4012-A725-5908513F22A9.pdf?alt=media&token=a8fc6339-e52c-4c96-84bf-20c3c8612a8f"))
    }
}
