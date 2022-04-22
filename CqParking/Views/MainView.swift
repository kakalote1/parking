//
//  MainView.swift
//  CqParking
//
//  Created by 王思远 on 2021/5/18.
//

import SwiftUI
import WebKit

var webView : WKWebView!



struct MainView: View {
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
    
        let url = URL (string: "https://esalotto.cn/cq-parking-h5/")
        WebView(request: URLRequest(url: url!)).ignoresSafeArea(.all)
    }
}


struct WebView: UIViewRepresentable {
    let request: URLRequest
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<WebView>) {
         uiView.load(request)
        uiView.allowsBackForwardNavigationGestures = true
        uiView.allowsLinkPreview = false
        uiView.scrollView.bounces = false
        uiView.scrollView.isScrollEnabled = false
        
        
    }
 
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
