//
//  ViewController.swift
//  Project-MiniBrowser
//
//  Created by Amit Bhujbal on 25/02/2026.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var inputURLTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var toolbarControl: UIToolbar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var opensafariButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbarControl.clipsToBounds = true
        toolbarControl.layer.cornerRadius = 12.0
        
        inputURLTextField.placeholder = "Enter website name"
        inputURLTextField.delegate = self
        
        goButton.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
        
        progressBar.isHidden = true
        
        webView.layer.cornerRadius = 10.0
        webView.layer.borderWidth = 1
        webView.layer.borderColor = UIColor.lightGray.cgColor
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    //MARK: Input TextField, Go Button & Add URL "https+ URL String"
    @objc func goButtonTapped(){
        if let urlString = inputURLTextField.text, var url = URL(string: urlString) {
            if url.scheme == nil {
                url = URL(string: "https://" + urlString)!
            }
            let request = URLRequest(url: url)
            webView.load(request)
        }
        inputURLTextField.resignFirstResponder()
        inputURLTextField.text = ""
    }

    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputURLTextField.resignFirstResponder()
        goButtonTapped()
        return true
    }

    //MARK: Remove the observer to prevent memory leaks
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    //MARK: Loading ProgressBar
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            let newProgress = Float(webView.estimatedProgress)
            progressBar.progress = newProgress
            if newProgress >= 1.0 {
                progressBar.isHidden = true
            } else {
                progressBar.isHidden = false
            }
        }
    }
    
    //MARK: Toolbar Control
    
    //Back Button
    @IBAction func backButtonAction(_ sender: Any) {
        webView.goBack()
    }
    
    //Forward Button
    @IBAction func forwardButtonAction(_ sender: Any) {
        webView.goForward()
    }
    
    //Refresh Button
    @IBAction func reloadButtonAction(_ sender: Any) {
        webView.reload()
    }
    
    //Open go to Safari Browser
    @IBAction func openSafariButtonAction(_ sender: Any) {
        if let url = webView.url {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

