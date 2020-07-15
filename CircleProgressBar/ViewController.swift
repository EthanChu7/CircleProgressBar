//
//  ViewController.swift
//  CircleProgressBar
//
//  Created by Ethan Chu on 2018/2/6.
//  Copyright © 2018年 Ethan Chu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,URLSessionDownloadDelegate {
    
    let progressBar = UltimateProgressBar()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var bottomAnchor: NSLayoutConstraint!
    var isDownloading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        SetUpLayout()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleTap)))
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func SetUpLayout() {
        let barFrame = CGRect(x: view.center.x - 50, y: view.center.y - 50, width: 100, height: 100)
        progressBar.frame = barFrame
        progressBar.backgroundColor = .red
        view.addSubview(progressBar)
        progressBar.isPercentageLabelHiden = true
        progressBar.SetUpProgressBar(frame: barFrame)
        progressBar.Pulse()
        
        view.addSubview(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.width * 3 / 4)
        bottomAnchor.isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.width * 3 / 4).isActive = true
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Downloaded")
        isDownloading = false
        if let data = NSData(contentsOf: location) {
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data as Data)
                self.bottomAnchor.constant = -(self.view.frame.height / 2 - self.imageView.frame.height / 2)
                self.bottomAnchor.isActive = true
                let animator = UIViewPropertyAnimator(duration: 0.5, curve: UIViewAnimationCurve.easeOut, animations: {
                    self.view.layoutIfNeeded()
                })
                animator.startAnimation()
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        print(percentage)
        DispatchQueue.main.async {
            self.progressBar.UpdateProgress(percentage: percentage)
        }
        
    }
    
    func BeginDownFile() {
        if !isDownloading{
            let configuration = URLSessionConfiguration.default
            let operationQueue = OperationQueue()
            let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
            let urlString = "https://www.japantimes.co.jp/wp-content/uploads/2015/01/f-BRI-emmawatson-a-20150128.jpg"
            guard let url = URL(string: urlString) else {return}
            let downloadTask = urlSession.downloadTask(with: url)
            //        let dataTask = urlSession.dataTask(with: url) { (data, respond, error) in
            //            if error != nil {
            //                print(error.debugDescription)
            //            }
            //            else {
            //                let image = UIImage(data: data!)
            //                DispatchQueue.main.async {
            //                    self.imageView.image = image
            //                }
            //            }
            //        }
            downloadTask.resume()
            isDownloading = true
        }
    }
    
    @objc private func HandleTap() {
        if !isDownloading { progressBar.UpdateProgress(percentage: 0) }
        bottomAnchor.constant = imageView.frame.height
        bottomAnchor.isActive = true
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: UIViewAnimationCurve.easeOut, animations: {
            self.view.layoutIfNeeded()
//            self.imageView.image = UIImage()
        })
        animator.startAnimation()
        print("HH")
        BeginDownFile()
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.toValue = 1
//        animation.duration = 2
//        animation.isRemovedOnCompletion = false
//        shapeLayer.add(animation, forKey: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

