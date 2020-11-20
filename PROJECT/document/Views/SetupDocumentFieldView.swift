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
            HStack {
                Text("Type field description")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
            }.padding(.horizontal, 24)
            .padding(.top, 40)
            
            TextField("...", text: $fieldDescription, onEditingChanged: { (changed) in
                print("Username onEditingChanged - \(changed)")
            }).padding(.horizontal, 24)
        
            Picker(selection: $selectedFieldType, label: Text("Strength")) {
                ForEach(0 ..< stringTypes.count) {
                    Text(self.stringTypes[$0])
                }
            }.padding(.horizontal, 24)
            Spacer()
            Button(action: {
                print(fieldDescription)
                globalEnviroment.appendField(docCDId: documentModel.cdID, selection!, description: fieldDescription, type: fieldTypeFromString(stringTypes[selectedFieldType]))
              
                selection?.color = UIColor(.orange)
                onDismiss()
                fieldDescription = ""
            }) {
                VStack {
                    
                        HStack {
                            Spacer()
                            Text("Add field")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                            Spacer()
                        }
                    
                    
            }
        }
            .clipped()
            .background(Color(r: 240, g: 240, b: 240))
            .cornerRadius(8)
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        
      
    }
}

}
