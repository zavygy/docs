//
//  SetupDocumentFieldView.swift
//  documents
//
//  Created by Глеб Завьялов on 21.09.2020.
//

import SwiftUI
import PDFKit
struct SetupDocumentFieldView: View {
    @ObservedObject var globalEnviroment: GlobalEnviroment
    @ObservedObject var documentModel: DocumentModel
    @State var selection: PDFSelection?
    var onDismiss: () -> ()
    @State private var selectedFieldType = 0
    var stringTypes = ["Имя", "Фамилия", "ФИО", "Адрес", "Серия", "Номер", "Другое"]

    @Binding var fieldDescription: String
    
    var body: some View {
        VStack {
            TextField("smth", text: $fieldDescription, onEditingChanged: { (changed) in
                print("Username onEditingChanged - \(changed)")
            })
            Picker(selection: $selectedFieldType, label: Text("Strength")) {
                ForEach(0 ..< stringTypes.count) {
                    Text(self.stringTypes[$0])
                }
            }
            Spacer()
            Button("Save", action: {
                print(fieldDescription)
                globalEnviroment.appendField(docID: documentModel.id, selection!, description: fieldDescription, type: fieldTypeFromString(stringTypes[selectedFieldType]))
              
                selection?.color = UIColor(.orange)
                onDismiss()
                fieldDescription = ""
            })
        }.padding()
        
      
    }
}

