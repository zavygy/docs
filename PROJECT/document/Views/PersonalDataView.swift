//
//  PersonalDataView.swift
//  document
//
//  Created by Глеб Завьялов on 09.10.2020.
//

import SwiftUI
import CoreData
struct PersonalDataView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: CDPerData.getAllCDData()) var cdPerData: FetchedResults<CDPerData>

    @ObservedObject var globalEnviroment: GlobalEnviroment
    @State private var selectedFieldType = 0
    @State var showType = true
    @State var newText: String = ""
    @State var extendView: Bool = false
    var stringTypes = ["Имя", "Фамилия", "ФИО", "Адрес", "Серия", "Номер", "Другое"]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Your data")
                        .foregroundColor(Color.primary)
                        .font(.title)
                        .bold()
                        .padding(.leading, 24)
                        .padding(.trailing, 8)
                    Spacer()
                }.padding(.top, 40)
                
                if (extendView) {
                    TextField("Data: ", text: $newText).padding(.horizontal)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .frame(height: 49)
                        .cornerRadius(8)
                        .shadow(color: Color(r: 230, g: 230, b: 230)!, radius: 4, x: 0, y: 0)
                        .padding(.horizontal, 24)
                        .padding(.top, 18)
                    
                    CustomPickerView(selected: $selectedFieldType, fields: stringTypes)
                        .padding(.top, 10)

                }
                
                List {
                    ForEach(globalEnviroment.personalData, id: \.createdAt) { infoModel in
                        FixedInputForm(description: stringFromFieldType(infoModel.type), input: infoModel.info ?? "")
                            .padding(.vertical, -4)
                    }.onDelete(perform: {i in
                        var s = 0
                        for x in i {
                            s = x
                        }
                        let model = globalEnviroment.personalData[s]
                        globalEnviroment.personalData.remove(atOffsets: i)
                        
                        for i in cdPerData {
                            if (i.createdAt == model.createdAt) {
                                self.managedObjectContext.delete(i)
                            }
                        }
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                    })
                }
                
                
            }
            
           
            VStack {
                Spacer()
                VStack {
                    Button(action: createNew) {
                        HStack {
                            Spacer()
                            Text(extendView ? (newText.isEmpty ? "Close" : "Add") : "Add")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                            Spacer()
                        }
                    }
                    .clipped()
                    .background(Color(r: 240, g: 240, b: 240))
                    .cornerRadius(8)
                }
                .background(Color(UIColor.systemBackground))
                .clipped()
                .cornerRadius(8)
                .padding(.horizontal, 24)
                .padding(.bottom, 14)
                
            }
        }
        
    }
    
    
    func createNew() {
        if (!extendView) {
            withAnimation {
                extendView = true
            }
        } else {
            if (newText.isEmpty) {
                withAnimation {
                    extendView = false
                }
                return
            }
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
            withAnimation {
                extendView = false
            }
        }
    }
    
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
