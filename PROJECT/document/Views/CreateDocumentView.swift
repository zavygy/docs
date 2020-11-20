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
                Spacer()
                Button(action: {
                    self.presentSelf = false
                }) {
                    HStack(spacing: 8) {
                        Text("Close")
                            .foregroundColor(.primary)
                            .fontWeight(.medium)
    //                            .padding(.trailing, 2)
                    }.padding(.horizontal)
                    .padding(.vertical, 2)
                }
            }.padding(.top)
            
            VStack {
                HStack {
                    Text("Type document name")
                        .font(.footnote)
                    Spacer()
                }
                TextField("...", text: $documentName, onCommit: {
                    UIApplication.shared.endEditing()
                })
                    .foregroundColor(.primary)
                    .font(Font.title.bold())
                    .lineLimit(1)
                    .frame(height: 49)
                    .cornerRadius(4.0)
                    
            }.padding(.leading, 23.5)
            .padding(.trailing, 60)
            
          
            
           
            VStack {
                HStack {
                   Text("Type document url")
                    .font(.footnote)
                    Spacer()
                }.padding(.horizontal, 24)
                TextField("URL: ", text: $url)
                    .padding(.horizontal, 24)
            }
                   
            
            Spacer()
            
            HStack {
                Button(action: pickDocument) {
                    HStack {
                        Spacer()
                        Text("Choose document")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                        Spacer()
                    }
                }
                .clipped()
                .background(Color(r: 240, g: 240, b: 240))
                .cornerRadius(8)
                .padding(.top, 20)
                .sheet(isPresented: $pickerIsPresented, content: {
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
                
            }
            .padding(.horizontal, 24)
            
            HStack {
                Button(action: create) {
                    HStack {
                        Spacer()
                        Text("Create")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                        Spacer()
                    }
                }
                .clipped()
                .background(Color(r: 240, g: 240, b: 240))
                .cornerRadius(8)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 24)
        
           
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
