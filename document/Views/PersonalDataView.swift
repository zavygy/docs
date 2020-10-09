//
//  PersonalDataView.swift
//  document
//
//  Created by Глеб Завьялов on 09.10.2020.
//

import SwiftUI
import CoreData
struct PersonalDataView: View {
    var managedObjectContext: NSManagedObjectContext
    @ObservedObject var globalEnviroment: GlobalEnviroment
    @State private var selectedFieldType = 0
    @State var newText: String = ""
    var stringTypes = ["Имя", "Фамилия", "ФИО", "Адрес", "Серия", "Номер", "Другое"]
    
    var body: some View {
        VStack {
            HStack {
                Text("Your data")
                    .font(.title)
                    .padding(.top, 20)
                    .padding(.leading, 20)
                Spacer()
            }
               
            List {
                Section {
                    ForEach(globalEnviroment.personalData, id: \.createdAt) { infoModel in
                        HStack {
                            Text(infoModel.info ?? "")
                            Spacer()
                            Text(stringFromFieldType(infoModel.type))
                        }
                    }
                }
                
                Section {
                    VStack {
                        TextField("Hello", text: $newText).padding(.horizontal)
                            .padding(.vertical, 4)
                        VStack {
                            Picker(selection: $selectedFieldType, label: Text("Strength")) {
                                ForEach(0 ..< stringTypes.count) {
                                    Text(self.stringTypes[$0])
                                }
                            }.pickerStyle(WheelPickerStyle())
                        }.frame(height: 100)
                        .clipped()
                    }
                }
                
                Section {
                    Button(action: createNew) {
                        HStack {
                            Spacer()
                            Text("Create new")
                                .buttonStyle(PlainButtonStyle())
                            Spacer()
                        }
                    }
                }
            }.listStyle(InsetGroupedListStyle())
        }
    }
    
    func createNew() {
        let model = TextPersonalInfo(newText, type: fieldTypeFromString(stringTypes[selectedFieldType]), createdAt: Date())
        withAnimation {
            globalEnviroment.personalData.append(model)
            selectedFieldType = 0
            newText = ""
        }
        let cdPer = CDPerData(context: self.managedObjectContext)
        cdPer.info = model.info
        cdPer.type = stringFromFieldType(model.type)
        cdPer.createdAt = model.createdAt
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error)
        }
    }
    
}
//
//struct PersonalDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonalDataView(globalEnviroment: GlobalEnviroment())
//    }
//}
