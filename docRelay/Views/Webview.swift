//
//  WebView.swift
//  docRelay
//
//  Created by Глеб Завьялов on 30.04.2020.
//  Copyright © 2020 Глеб Завьялов. All rights reserved.
//

import Foundation
import WebKit
import SwiftUI

struct Webview: UIViewRepresentable {
    
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }
        
        let request = URLRequest(url: url)
        
        let wkWebView = WKWebView()
        wkWebView.load(request)
        return wkWebView
    }
    
    func updateUIView(_ uiView: Webview.UIViewType, context: UIViewRepresentableContext<Webview>) {
        
    }
    
}
