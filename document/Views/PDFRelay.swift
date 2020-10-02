//
//  PDFRelay.swift
//  documents
//
//  Created by Глеб Завьялов on 21.09.2020.
//

import SwiftUI
import PDFKit

struct PDFRelay: View {
    @ObservedObject var globalEnviroment: GlobalEnviroment
    @ObservedObject var document: DocumentModel
    @State var pdfSelection: PDFSelection? = nil
    @State var shouldShowAddFieldButton: Bool = false
    @State var sheetIsPresented: Bool = false
    @State var fieldDescription: String = ""

    var body: some View {
        ZStack {
            PDFKitView(url: URL(string: document.url ?? "")!, pdfSelection:
                        Binding(get: {
                            self.pdfSelection
                        },
                        set: { (newValue) in
                            self.pdfSelection = newValue
                            if (pdfSelection == nil) {
                                print("Deselected")
                                shouldShowAddFieldButton = false
                            } else {
                                print(pdfSelection?.string ?? "")
                                shouldShowAddFieldButton = true
                                
                            }
                        }
                        )).sheet(isPresented: $sheetIsPresented){ SetupDocumentFieldView(globalEnviroment: globalEnviroment, documentModel: document, selection: pdfSelection, onDismiss: {
                            self.sheetIsPresented = false
                            
                        }, fieldDescription: $fieldDescription)
                            .onDisappear {
                                self.sheetIsPresented = false
                            }
                        
                        }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if (pdfSelection != nil) {
                        AddFieldButton(sheetIsPresented: $sheetIsPresented)
                            .padding()
                            .shadow(radius: 10)
                            
                    }
                    Spacer()
                }
            }
        }
//            .allowsHitTesting(false)
         
    }
}

//struct PDFRelay_Previews: PreviewProvider {
//    static var previews: some View {
//        PDFRelay(document: DocumentModel(id: "1", name: "Title", pdfData: Data()), pdfSelection: Binding(nil))
//    }
//}


struct AddFieldButton: View {
    @Binding var sheetIsPresented: Bool
        
    var body: some View {
        VStack {
            Button(action: addField, label: {
                Text("Add field")
                    .foregroundColor(.primary)
                    .padding()
            }).background(Color(UIColor.systemGroupedBackground))
        }.cornerRadius(10)
        
       
       
    }
    
    func addField() {
        withAnimation {
            sheetIsPresented = true
        }
    }
}
