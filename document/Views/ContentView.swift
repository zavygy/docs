//
//  ContentView.swift
//  documents
//
//  Created by Глеб Завьялов on 14.08.2020.
//

import SwiftUI
import CodeScanner

var statusBarHeight = UIApplication.shared.statusBarFrame.height

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: CDDocumentModel.getAllCDDocs()) var cdDocuments: FetchedResults<CDDocumentModel>
    @FetchRequest(fetchRequest: CDDocumentField.getAllCDFields()) var cdFields: FetchedResults<CDDocumentField>
    @FetchRequest(fetchRequest: CDPerData.getAllCDData()) var cdPerData: FetchedResults<CDPerData>

    @ObservedObject var globalEnviroment: GlobalEnviroment
    @State private var createIsPresented: Bool = false
    @State private var typeInIsPresented: Bool = false
    @State private var downloadOptionsIsPresented: Bool = false
    @State private var qrScanIsPresented: Bool = false
    @State private var downloadingDocument: Bool = false
    @State private var documentId: String = ""
    @State private var personalDataIsPresented: Bool = false
    @State private var showDownloadOptions: Bool = true
    @State private var myCreatedState: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack {
                        HStack {
                            Text("Documents")
                                .foregroundColor(.black)
                                .font(.title)
                                .bold()
                                .padding(.leading, 24)
                                .padding(.trailing, 8)
                                
                            
                            Button(action: {
                                DispatchQueue.main.async {
                                    withAnimation {
                                        showDownloadOptions.toggle()
                                    }
                                }
                                
                            }) {
                                Image(showDownloadOptions ? "arrowUp" : "arrowDown")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 6, alignment: .center)
                                    .accentColor(.black)
                            }
                            
                                
                            Spacer()
                            Button(action: {
                                self.personalDataIsPresented = true
                            }){
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .accentColor(.black)
                                    .frame(width: 24, height: 24)
                                                  
                            }.padding(.trailing, 24)
                        }.padding(.top, 40 + statusBarHeight)
                        .padding(.bottom, showDownloadOptions ? 0 : 32)
                        
                        if (showDownloadOptions) {
                        
                        VStack {
                            HStack {
                                Text("Enter document id or scan QR")
                                    .foregroundColor(.black)
                                    .font(.footnote)
                                Spacer()
                            }
                            HStack {
                                TextField("ID", text: $documentId, onCommit: {
                                    handleTypeIn()
                                    UIApplication.shared.endEditing()
                                })
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .frame(height: 49)
                                .cornerRadius(4.0)
                                
                                .padding(.trailing, 8)
                                

                                
                                
                                Button(action: scanQRDownloaded) {
                                    Image(systemName: "qrcode")
        //                                .frame(width: 24, height: 24)
                                        .resizable()
                                        .padding(13)
                                        .accentColor(.black)
                                }.frame(width: 49, height: 49)
                                .background(Color.white)
                                .clipped()
                                .cornerRadius(4)
                            }.frame(height: 49)
                            .padding(.top, 8)
                        }.padding(.top, 40)
                        .padding(.horizontal, 24)
                        
                        Button(action: {
                            handleTypeIn()
                            UIApplication.shared.endEditing()
                        }) {
                            HStack {
                                Spacer()
                                Text("Download")
                                    .font(.headline)
                                    .bold()
                                    .accentColor(.white)
                                    .padding(.vertical, 13)
                                Spacer()
                                
                            }
                            
                        }
                        .clipped()
                        .background(Color(r: 17, g: 17, b: 17))
                        .cornerRadius(4)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        .padding(.bottom, 40)
                        }
                                        
                    }
                    .navigationBarTitle("Home")
                    .navigationBarHidden(true)
                    .background(Color(r: 255, g: 206, b: 0))
                    .cornerRadius(16, corners: [.bottomRight, .bottomLeft])
                    
                    HStack {
                        HomeSegmentedControl(myCreatedState: $myCreatedState)
//                                .background(Color(r: 247, g: 247, b: 247))
                            .cornerRadius(4)
                        Spacer()
                    }.padding(.top, 12)
                    .padding(.leading, 24)
                    
                    ScrollView {
                        
                        
                       
                        if myCreatedState {
                        
                        ForEach(globalEnviroment.loadedDocuments, id: \.cdID) { document in
                            NavigationLink(destination: DetailedLoadedDocumentModel(globalEnviroment: globalEnviroment, document: document, completeArray: arrayStringOf(document.fieldsToFill.count))) {
                                DownloadedDocumentItem(documentModel: document, onDelete: {
                                    let delItem = document
                                    for i in 0..<globalEnviroment.loadedDocuments.count {
                                        if (globalEnviroment.loadedDocuments[i].cdID == document.cdID) {
                                            withAnimation(.easeOut) {
                                                globalEnviroment.loadedDocuments.remove(at: i)
                                            }
                                            break;
                                        }
                                    }
                                    
                                    for i in 0..<cdDocuments.count {
                                        let m = cdDocuments[i]
                                        if (m.cdId! == delItem.cdID) {
                                            self.managedObjectContext.delete(cdDocuments[i])
                                            do {
                                                try self.managedObjectContext.save()
                                            } catch {
                                                print(error)
                                            }
                                            break
                                        }
                                    }
                                    for i in 0..<cdFields.count {
                                        if (cdFields[i].parent! == delItem.cdID) {
                                            self.managedObjectContext.delete(cdFields[i])
                                        }
                                    }
                                    
                                    do {
                                        try self.managedObjectContext.save()
                                    } catch {
                                        print(error)
                                    }
                                    print("\(document.name)")
                                })
                                    .background(Color(UIColor.systemBackground))
                                    .clipped()
                                    .cornerRadius(4)
                                    .padding(.horizontal, 24) //bycicle
                                    .shadow(color: Color(r: 230, g: 230, b: 230)!, radius: 5, x: 0, y: 0)
                                    
                            }.buttonStyle(PlainButtonStyle())
                                
                        }.padding(.top, 16)
//                        .padding(.bottom, 60)
                            
                        } else {
                        
                            ForEach(globalEnviroment.createdDocuments, id: \.cdID) { document in
                                NavigationLink(destination: DetailedDocumentView(managedObjectContext: managedObjectContext, cdDocuments: cdDocuments, cdFields: cdFields,  globalEnviroment: globalEnviroment, document: document)) {
                                    DownloadedDocumentItem(documentModel: document, onDelete: {
                                        let delItem = document
                                        for i in 0..<globalEnviroment.createdDocuments.count {
                                            if (globalEnviroment.createdDocuments[i].cdID == document.cdID) {
                                                withAnimation(.easeOut) {
                                                    globalEnviroment.createdDocuments.remove(at: i)
                                                }
                                                break;
                                            }
                                        }
        
                                        for i in 0..<cdDocuments.count {
                                            let m = cdDocuments[i]
                                            if (m.cdId! == delItem.cdID) {
                                                self.managedObjectContext.delete(cdDocuments[i])
                                                do {
                                                    try self.managedObjectContext.save()
                                                } catch {
                                                    print(error)
                                                }
                                                break
                                            }
                                        }
        
        
                                        for i in 0..<cdFields.count {
                                            if (cdFields[i].parent! == delItem.cdID) {
                                                self.managedObjectContext.delete(cdFields[i])
                                            }
                                        }
                                        
                                        do {
                                            try self.managedObjectContext.save()
                                        } catch {
                                            print(error)
                                        }
                                        
                                        
                                        print("\(document.name)")
                                    })
                                        .background(Color(UIColor.systemBackground))
                                        .clipped()
                                        .cornerRadius(4)
                                        .padding(.horizontal, 24)
                                        .padding(.top, 16)//bycicle
                                        .shadow(color: Color(r: 230, g: 230, b: 230)!, radius: 5, x: 0, y: 0)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                        
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 100)
                        
                    }
                    Text("").frame(width: 0, height: 0, alignment: .bottom)
                        .sheet(isPresented: $createIsPresented, content: {
                            CreateDocumentView(globalEnviroment: globalEnviroment, presentSelf: $createIsPresented)
                                .ignoresSafeArea()
                        })
                    Text("").frame(width: 0, height: 0, alignment: .bottom)
                        .sheet(isPresented: $personalDataIsPresented, onDismiss: {
                            self.personalDataIsPresented = false

                        } ,content: {
                            PersonalDataView(managedObjectContext: self.managedObjectContext, globalEnviroment: globalEnviroment)
                        })
                    Text("").frame(width: 0, height: 0, alignment: .bottom)
                        .sheet(isPresented: $qrScanIsPresented, onDismiss: {
                            withAnimation {
                                qrScanIsPresented = false
                                downloadOptionsIsPresented = false
                            }
                        }, content: {
                            ZStack {
                                CodeScannerView(codeTypes: [.qr], completion: self.handleScan).ignoresSafeArea()
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            self.qrScanIsPresented = false
                                            self.downloadOptionsIsPresented = false
                                        }) {
                                            Image(systemName: "multiply.circle.fill")
                                                .resizable()
                                                .foregroundColor(Color(UIColor.systemGray2))
                                                .opacity(0.85)
                                                .frame(width: 30, height: 30)
                                            }.padding(.horizontal, 15)
                                    }.padding(.top, 15)
                                    Spacer()
                                }
                            }
                    })

                    
                }.ignoresSafeArea(.all, edges: .top)
                
                VStack {
                    Spacer()
                    HStack {
                        Button(action: addCreated) {
                            HStack {
                                Spacer()
                                Text("Create new document")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding()
                                Spacer()
                            }
                        }
                        .background(Color(r: 240, g: 240, b: 240))
                        .cornerRadius(4)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
//                        .shadow(color: Color(r: 230, g: 230, b: 230)!, radius: 5, x: 0, y: 0)
                    }.padding(.horizontal, 24)
                }

            }.ignoresSafeArea(.all, edges: [.top, .bottom])
                
                
        }.onAppear {
            globalEnviroment.managedObjectContext = self.managedObjectContext
            globalEnviroment.loadDocuments(cdFields: cdFields, cdDocuments: cdDocuments)
            globalEnviroment.personalData = []
            for i in cdPerData {
                globalEnviroment.personalData.append(TextPersonalInfo(i.info, type: fieldTypeFromString(i.type ?? ""), createdAt: i.createdAt ?? Date()))
            }
        }

    }
    
    func arrayStringOf(_ size: Int) -> [String]{
        var array: [String] = []
        for i in 0..<size {
            array.append("")
        }
        return array
    }
    
    func removeItemCreated(at offsets: IndexSet) {
        withAnimation {
            globalEnviroment.createdDocuments.remove(atOffsets: offsets)
        }
//        expenses.items.remove(atOffsets: offsets)
    }
    func removeItemLoaded(at offsets: IndexSet) {
        withAnimation {
            globalEnviroment.loadedDocuments.remove(atOffsets: offsets)
        }
    }

    func scanQRDownloaded() {
        qrScanIsPresented = true

        withAnimation {
            typeInIsPresented = false
        }
        
    }
//    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {

       
        withAnimation {
            qrScanIsPresented = false

            downloadOptionsIsPresented = false
            downloadingDocument = true

        }
        

        
        switch result {
            case .success(let code):
                globalEnviroment.downloadDocument(key: code, comletion: {
                    _ in
                    
                    withAnimation {
                        downloadingDocument = false
                    }
                    
                })
            case .failure(let error):
                withAnimation {
                    downloadingDocument = false
                }
                print("Scanning failed")
        }
        
       
    }
    
    func handleTypeIn() {
        typeInIsPresented = false


//        withAnimation {
            downloadingDocument = true
//        }

        globalEnviroment.downloadDocument(key: documentId, comletion: {
                _ in
                
            withAnimation {
                downloadingDocument = false
                downloadOptionsIsPresented = false
            }
            self.documentId = ""

        })
        
        
    }
    
    func typeDownloaded() {
        withAnimation {
            typeInIsPresented = true
        }
    }
    
    func addDownloaded() {
        withAnimation {
            downloadOptionsIsPresented = true
        }
        print("add downloaded")

    }
    
    func addCreated() {
        createIsPresented = true
        print("add created")
    }
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(globalEnviroment: GlobalEnviroment())
//    }
//}
//

