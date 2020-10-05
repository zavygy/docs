//
//  DetailedDocumentView.swift
//  documents
//
//  Created by Глеб Завьялов on 29.08.2020.
//

import SwiftUI
import CoreData
import PDFKit

struct DetailedDocumentView: View {
    var managedObjectContext: NSManagedObjectContext
    var cdDocuments: FetchedResults<CDDocumentModel>
    var cdFields: FetchedResults<CDDocumentField>

    
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
                    }
                    .onDelete(perform: removeField)
                    
                }
            }
            Spacer()
        }
    }
    
    func removeField(at offsets: IndexSet) {
        let delField = document.fieldsToFill[offsets.first!]
        print(delField)
        for i in 0..<cdFields.count {
            print(cdFields[i])
            if (cdFields[i].parent! == document.cdID && cdFields[i].desc == delField.description) {
                self.managedObjectContext.delete(cdFields[i])
            }
        }
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
        
        
        withAnimation {
            document.fieldsToFill.remove(atOffsets: offsets)
        }
        
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

