//
//  WebUIView.swift
//  LiveCallClient
//
//  Created by LongNT on 29/11/2023.
//

import SwiftUI
import WebKit

struct WebUIView: UIViewRepresentable {
    @EnvironmentObject var callEvent: CallEvent
    @Binding var open: Bool
    
    var url: String
    
    init(url: String, open: Binding<Bool>) {
        self.url = url
        self._open = open
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let coordinator = makeCoordinator()
        let userContentController = WKUserContentController()
        userContentController.add(coordinator, name: "livecall")
        
        let source = """
            window.addEventListener('message', function(e) {
                window.webkit.messageHandlers.livecall.postMessage(JSON.stringify(e.data));
            });
            """
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        userContentController.addUserScript(script)
        
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController = userContentController
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        //
    }
}

// Coordinator
class Coordinator : NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    var parent: WebUIView
    var webView: WKWebView?
    
    init(_ parent: WebUIView) {
        self.parent = parent
    }
    
    func webView(
        webView: WKWebView,
        requestMediaCapturePermissionFor
        origin: WKSecurityOrigin, initiatedByFrame
        frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void) {
            self.webView = webView
            decisionHandler(.grant)
        }
    
    // receive message from wkwebview
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        self.parent.callEvent.countReceivedEvent += 1
        self.parent.open.toggle()
    }
}

#Preview {
    WebUIView(url: "https://tucthi11234.testing.3.livecall.jp", open: .constant(false))
}
