//
//  WebViewContainerViewController.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 9.01.2022.
//

import UIKit
import WebKit

class WebViewContainerViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureWebView()
        configureActivityIndicator()
    }

    var urlString = "https://www.google.com"

    func configureWebView() {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)

        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
//        webView.configuration = configuration
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.isLoading),
                            options: .new,
                            context: nil)
        webView.load(urlRequest)
    }

    func configureActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.color = .red
        activityIndicator.hidesWhenStopped = true
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        if keyPath == "loading" {
            webView.isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }

    }

    @IBAction func reloadButtonTapped(_ sender: UIBarButtonItem) {
        webView.reload()
        
    }
    
    @IBAction func goBackButtonTapped(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func goForwardButtonTapped(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func openInSafariButtonTapped(_ sender: UIBarButtonItem) {
        UIApplication.shared.open(webView.url!)
    }
    
    @IBAction func htmlButtonTapped(_ sender: UIBarButtonItem) {
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}

extension WebViewContainerViewController: WKNavigationDelegate {

}

extension WebViewContainerViewController: WKUIDelegate {

}

private let htmlString = """
<!doctype html>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1">
<html>
    <head>
        <style>
            body {
                font-size: 24px;
                font-family: "AmericanTypeWriter";
                
                text-align: center;
                height: 100vh;
                display:flex;
            }
            
            .container{
                align-items: center;
                justify-content: center;
                
                width:90vw;
                height: 90vh;
                margin: auto;
            }
            
            .element{
                margin: auto;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="element">
                <h3>Hello, WKWebView!</h3><br>
                This HTML page is using "AmericanTypeWriter" font.<br><br>
                To go back to main page tap <a href="https://www.google.com">here.</a>
            </div>
        </div>
        
    </body>
</html>
"""
