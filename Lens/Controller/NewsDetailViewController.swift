//
//  NewsDetailViewController.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/26.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    var urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置WKWebView
        self.webView = WKWebView(frame: self.view.bounds)
        self.webView.navigationDelegate = self
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.view.addSubview(self.webView)
        
        // 设置进度条
        self.progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 2))
        self.progressView.transform = CGAffineTransform(scaleX: 1, y: 2)
        self.progressView.trackTintColor = Color.translucent
        self.progressView.progressTintColor = Color.tint
        self.view.addSubview(self.progressView)
        
        // 开始加载
        self.webView.load(URLRequest(url: URL(string: urlString)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 恢复导航栏阴影（1）
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 恢复导航栏阴影（2）
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.progress = Float(self.webView.estimatedProgress)
            if self.progressView.progress == 1 {
                self.progressView.isHidden = true
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressView.isHidden = false
    }

//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        return
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        self.progressView.isHidden = true
//    }
//
//    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        self.progressView.isHidden = true
//    }
//
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        self.progressView.isHidden = true
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
