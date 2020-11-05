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
            
            HStack {
                VStack {
                    TextField("Name", text: $documentName, onCommit: {
                        UIApplication.shared.endEditing()
                    })
                        .foregroundColor(.primary)
                        .font(Font.title3.bold())
                        .lineLimit(1)
                        .frame(height: 49)
                        .cornerRadius(4.0)
                }.padding(.leading, 23.5)
                .padding(.trailing, 60)
                
                    
                Spacer()
                Button(action: {}) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .font(Font.title.weight(.bold))
                        .frame(width: 16, height: 16, alignment: .center)
                        .foregroundColor(.primary)
                }
                .padding(.trailing, 23.5)
            }.padding(.top, 26)
            
            VStack {
                HStack {
                    Text("Name:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                }.padding(.top, 36)
                
                
            }.padding(.horizontal, 23.5)
           
            
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
            Spacer()
        
           
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
