//
//  ContentView.swift
//  documents
//
//  Created by Глеб Завьялов on 14.08.2020.
//

import SwiftUI
import CodeScanner
import PartialSheet

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: CDDocumentModel.getAllCDDocs()) var cdDocuments: FetchedResults<CDDocumentModel>
    @FetchRequest(fetchRequest: CDDocumentField.getAllCDFields()) var cdFields: FetchedResults<CDDocumentField>

    @EnvironmentObject var partialSheetManager: PartialSheetManager
    @ObservedObject var globalEnviroment: GlobalEnviroment
    @State private var createIsPresented: Bool = false
    @State private var typeInIsPresented: Bool = false
    @State private var downloadOptionsIsPresented: Bool = false
    @State private var qrScanIsPresented: Bool = false
    @State private var downloadingDocument: Bool = false
    @State private var documentId: String = ""
    
    var body: some View {
        NavigationView {
                VStack {
                    List {
                        Section(header: Text("Downloaded")) {
                            ForEach(globalEnviroment.loadedDocuments, id: \.cdID) { document in
                                NavigationLink(destination: DetailedLoadedDocumentModel(globalEnviroment: globalEnviroment, document: document)) {
                                    DocumentListItem(documentModel: document)
                                }
                            }.onDelete { indexSet in
                                    let delItem = globalEnviroment.loadedDocuments[indexSet.first!]
                                    globalEnviroment.loadedDocuments.remove(at: indexSet.first!)
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
                                    
                            }
                           
                            if (typeInIsPresented == true) {

                                TextField("ID: ", text: $documentId, onCommit:  {
                                    handleTypeIn()
                                    UIApplication.shared.endEditing()
                                })
                                .padding(.horizontal)

                            }
                                
                            
                            VStack {
                                if downloadOptionsIsPresented == true {
                                    HStack {
                                        HStack {
                                            Button(action: typeDownloaded) {
                                                VStack {
                                                    Image(systemName: "pencil.and.ellipsis.rectangle").frame(width: 25, height: 25)
                                                    Text("Type")
                                                }
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .buttonStyle(PlainButtonStyle())
                                            
                                        }
                                        Divider().background(Color.secondary)
                                        HStack {
                                            Button(action: scanQRDownloaded) {
                                                VStack {
                                                    Image(systemName: "qrcode.viewfinder").frame(width: 25, height: 25)
                                                    Text("Scan")
                                                }
                                            
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .buttonStyle(PlainButtonStyle())
                                            
                                        }
                                    }
                                } else {
                                    Button (action: addDownloaded, label: {
                                        HStack {
                                            Spacer()
                                            Text("+").font(.title3)
                                            Spacer()
                                        }
                                    })
                                }
                                
                            }
                        }.cornerRadius(10.0)
//                        .padding(.horizontal, 5)
                        
                        
                        Section(header: Text("Created")) {
                            ForEach(globalEnviroment.createdDocuments, id: \.cdID) { document in
                                NavigationLink(destination: DetailedDocumentView(managedObjectContext: managedObjectContext, cdDocuments: cdDocuments, cdFields: cdFields,  globalEnviroment: globalEnviroment, document: document)) {
                                    DocumentListItem(documentModel: document)
                                }
                            }.onDelete { indexSet in
                                let delItem = globalEnviroment.createdDocuments[indexSet.first!]
                                globalEnviroment.createdDocuments.remove(at: indexSet.first!)

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
                                        do {
                                            try self.managedObjectContext.save()
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
//
                                
                            }
                            Button (action: addCreated, label: {
                                HStack {
                                    Spacer()
                                    Text("+").font(.title3)
                                    Spacer()
                                }
                            }).sheet(isPresented: $createIsPresented, content: {
                                CreateDocumentView(globalEnviroment: globalEnviroment, presentSelf: $createIsPresented)
                                    .ignoresSafeArea()
                            })
                        }.cornerRadius(10.0)
                        
                    }.listStyle(InsetGroupedListStyle())
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
                    .navigationViewStyle(StackNavigationViewStyle())
                    .navigationBarTitle("Documents")
                    
                }
                
                
        }.onAppear {
            globalEnviroment.managedObjectContext = self.managedObjectContext
            globalEnviroment.loadDocuments(cdFields: cdFields, cdDocuments: cdDocuments)
        }

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
        withAnimation {
            typeInIsPresented = false
        }
        qrScanIsPresented = true
        
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

