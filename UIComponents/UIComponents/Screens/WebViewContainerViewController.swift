//
//  WebViewContainerViewController.swift
//  UIComponents
//
//  Created by Semih Emre ÜNLÜ on 9.01.2022.
//

import UIKit
import WebKit

class WebViewContainerViewController: UIViewController {
    
    // MARK: - IBOtlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var goBackButton: UIBarButtonItem!
    @IBOutlet weak var goForwardButton: UIBarButtonItem!
    @IBOutlet weak var openInSafariButton: UIBarButtonItem!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureWebView()
        configureActivityIndicator()
    }
    
    // MARK: - Variables
    var urlString = "https://www.google.com"
    
    // MARK: - Functions
    
    // Configure web view
    func configureWebView() {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        // Allow back and forward navigation gestures
        webView.allowsBackForwardNavigationGestures = true
        // Add an observer to WKWebView.isLoading
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.isLoading),
                            options: .new,
                            context: nil)
        webView.load(urlRequest)
    }
    
    // Configure Activity Indicator
    func configureActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.color = .red
        activityIndicator.hidesWhenStopped = true
    }
    
    // observeValue function
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if keyPath == "loading" {
            // Starting and stopping activityIndicator animations
            webView.isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
            
            // Toggle the UIBarButtonItems back 'ON' if the url is "google.com"
            if webView.url == URL(string: "https://www.google.com/"){ toggleUIBarButtonItemsOn() }
            
            // Setting the state of goBack and goForward buttons
            checkGoBackButton()
            checkGoForwardButton()
        }
        
    }
    
    // A function to set all the UIBarButtonItems .isEnabled state to 'false'
    func toggleUIBarButtonItemsOff() {
        reloadButton.isEnabled = false
        goBackButton.isEnabled = false
        goForwardButton.isEnabled = false
        openInSafariButton.isEnabled = false
    }
    // A function to set all the UIBarButtonItems .isEnabled state to 'true'
    func toggleUIBarButtonItemsOn() {
        reloadButton.isEnabled = true
        goBackButton.isEnabled = true
        goForwardButton.isEnabled = true
        openInSafariButton.isEnabled = true
    }
    
    // If the webView can go back set the button state to 'true', else: set it to 'false'
    func checkGoBackButton() {
        if webView.canGoBack { goBackButton.isEnabled = true }
        else { goBackButton.isEnabled = false }
    }
    
    // If the webView can go forward set the button state to 'true', else: set it to 'false'
    func checkGoForwardButton() {
        if webView.canGoForward { goForwardButton.isEnabled = true }
        else { goForwardButton.isEnabled = false }
    }
    
    // MARK: - IBActions
    @IBAction func reloadButtonTapped(_ sender: UIBarButtonItem) {
        webView.reload() // Relaod webView
    }
    
    @IBAction func goBackButtonTapped(_ sender: UIBarButtonItem) {
        webView.goBack() // Go back to the previous page
    }
    
    @IBAction func goForwardButtonTapped(_ sender: UIBarButtonItem) {
        webView.goForward() // Go forward to the next page
    }
    
    @IBAction func openInSafariButtonTapped(_ sender: UIBarButtonItem) {
        UIApplication.shared.open(webView.url!) // Open current URL in Safari
    }
    
    @IBAction func htmlButtonTapped(_ sender: UIBarButtonItem) {
        // Load htmlString and display it
        webView.loadHTMLString(htmlString, baseURL: nil)
        // When htmlString is loaded; toggle all the bar buttons states off
        toggleUIBarButtonItemsOff()
    }
}

// MARK: - HTML String

// HTML string that will be loaded.
// This HTML uses the custom font 'AmericanTypeWriter'
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
                <h3>Hello, HTML!</h3><br>
                This HTML page is using "AmericanTypeWriter" font.<br><br>
                To go back to main page tap <a href="https://www.google.com">here.</a>
            </div>
        </div>
        
    </body>
</html>
"""
