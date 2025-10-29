//
//  WebView.swift
//  Movee
//
//  Created by user on 5/5/25.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias LoadingStateUpdater = (URL?, Bool) -> Void
    
    enum Content {
        case url(URL)
        case html(String)
    }

    let content: Content
    private let referrer: String?
    private let onLoadingStateChanged: LoadingStateUpdater?

    init(_ content: Content,
         referrer: String? = "https://sites.google.com/view/mowee/",
         onLoadingStateChanged: LoadingStateUpdater? = nil)
    {
        self.content = content
        self.referrer = referrer
        self.onLoadingStateChanged = onLoadingStateChanged
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.mediaTypesRequiringUserActionForPlayback = []
        config.allowsInlineMediaPlayback = true           // important!
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard !context.coordinator.hasLoadedInitialContent else { return }
        switch content {
        case .url(let url):
            print("Loading url: \(url)")
            var request = URLRequest(url: url)
            if let referrer {
                request.setValue(referrer, forHTTPHeaderField: "Referer")
            }
            webView.load(request)
        case .html(let html):
            webView.loadHTMLString(html, baseURL: nil)
        }
        context.coordinator.hasLoadedInitialContent = true
    }

    func makeCoordinator() -> Coordinator { .init(self) }

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        private var lastLoadingState: Bool = false
        var hasLoadedInitialContent: Bool = false
        init(_ parent: WebView) { self.parent = parent }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            if lastLoadingState {
                parent.onLoadingStateChanged?(webView.url, true)
                lastLoadingState = false
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if !lastLoadingState {
                parent.onLoadingStateChanged?(webView.url, false)
                lastLoadingState = true
            }
        }
    }

    /// Fluent API
    func onLoadingStateChanged(_ handler: @escaping LoadingStateUpdater) -> WebView {
        WebView(content, referrer: referrer, onLoadingStateChanged: handler)
    }
}
