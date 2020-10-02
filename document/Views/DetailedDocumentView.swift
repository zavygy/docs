//
//  DetailedDocumentView.swift
//  documents
//
//  Created by Глеб Завьялов on 29.08.2020.
//

import SwiftUI
import PDFKit

struct DetailedDocumentView: View {
    @ObservedObject var globalEnviroment: GlobalEnviroment
    @ObservedObject var document: DocumentModel
    @State private var pageState = 0
    @State private var sharedPresentMode: Bool = false
    
    var body: some View {
        VStack {
            Picker(selection: $pageState, label: Text("")) {
                Text("PDF").tag(0)
                Text("Fields").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
            .navigationBarTitle(document.name)
            .navigationBarItems(trailing: Button("Share", action: shareDocument))
            .sheet(isPresented: $sharedPresentMode, content: {
                SharedResultView(docId: document.id, documentTitle: document.name)
            })

            .padding(.horizontal)
            if (pageState == 0) {
                PDFRelay(globalEnviroment: globalEnviroment, document: document)
                    .background(Color(UIColor.systemBackground))
                    
            } else {
                List{
                    ForEach (document.fieldsToFill) { (field) in
                        HStack {
                            Text(field.description)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(stringFromFieldType(field.type))
                        }.padding()
                    }.onDelete(perform: removeField)
                    
                }
            }
            Spacer()
        }
    }
    
    func removeField(at offsets: IndexSet) {
        withAnimation {
            document.fieldsToFill.remove(atOffsets: offsets)
        }
//        expenses.items.remove(atOffsets: offsets)
    }
    
    func shareDocument() {
        globalEnviroment.shareDoucment(document: document, completion: {(docid) in
            sharedPresentMode = true
            print(docid)
        })
    }
}

//struct DetailedDocumentView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailedDocumentView(globalEnviroment: GlobalEnviroment(), document: DocumentModel(id: "1", name: "Title", pdfData: Data()))
//    }
//}
//

