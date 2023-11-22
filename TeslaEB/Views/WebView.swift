//
//  WebView.swift
//  testmit login
//
//  Created by Florian Peters on 15.11.23.
//
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let request: URLRequest

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        // Hier können Sie auf Navigationsereignisse reagieren, wenn nötig
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Optional: Fügen Sie hier Logik hinzu, um auf das Laden der Webseite zu reagieren
        }
    }
}
