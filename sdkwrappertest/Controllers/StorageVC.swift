//
//  StorageVC.swift
//  sdkwrappertest
//
//  Created by Ruben Mimoun on 16/10/2021.
//

import Foundation
import UIKit
import FirebaseWrapperSPM

class StorageVC : TableViewController, Storyboarded{
    
    let storageWrapper = StorageWrapper()
    let indicator : UIProgressView?  = UIProgressView()
    var uploadingLabel : UILabel?  =  UILabel()


    override func viewDidLoad() {
        self.title =  "Storage Test"
        initTableView()

//        uploadFileLocal()
//        uploadFileFromData()
        uploadHeavyFile()
        downloadFile(fromPath: "images/pikachu.jpeg")
        

    }
    
    
    func uploadFileLocal(){
        let storageRef = storageWrapper.getReference(for: "images/pikachu.jpeg", from: false)
        if let ref = storageRef,
           let localURL = URL.localURLForXCAsset(name: "pikachu", withExtension: "jpg") {
            storageWrapper.uploadFile(from: localURL, in: ref) { result in
                switch result{
                case .success(let successUrl):
                    print("upload file local", "SUCCESS -  \(successUrl?.absoluteString ?? "")")
                case .failure(let error):
                    print("upload file local", "FAILURE -  \(error)")
                }
            }
        }
        

    }
    
    
    func uploadFileFromData(){
        if let image =  UIImage(named: "pikachu"),
           let dataImage =  image.pngData(),
           let storageRef = storageWrapper.getReference(for: "images/pikachu2.png", from: false){
            storageWrapper.uploadFile(from: dataImage, in: storageRef){result in
                switch result{
                case .success(let successUrl):
                    print("upload file data", "SUCCESS -  \(successUrl?.absoluteString ?? "")")
                case .failure(let error):
                    print("upload file data", "FAILURE -  \(error)")
                }
            }
        }
        storageWrapper.addUploadingObserver(taskStatus: .success)
            
    }
    
    
    func uploadHeavyFile(){
        if let ref = storageWrapper.getReference(for: "videos/working.mov", from: false),
           let urlLocal =  Bundle.main.url(forResource: "Working?", withExtension: "mov"){
            storageWrapper.uploadFile(from: urlLocal, in: ref) { result in
                switch result{
                case .success(let successUrl):
                    print("upload HEAVY", "SUCCESS -  \(successUrl?.absoluteString ?? "")")
                case .failure(let error):
                    print("upload HEAVY", "FAILURE -  \(error)")
                }
            }
        }
        
        
        let progressView =  createProgressView()
        navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: progressView)
        storageWrapper.addUploadProgressObserver{ [weak self] result in
            DispatchQueue.main.async {
                self?.updateProgressView(progress: Float(result))
            }
            
        }
    }
    
    
    private func createProgressView() -> UIView{
        let progressViewHolder = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 100)))
        indicator?.progressViewStyle = .default
       
        indicator?.frame =  CGRect(origin: .zero, size: CGSize(width: progressViewHolder.frame.width, height: progressViewHolder.frame.height / 2))
        uploadingLabel?.frame = CGRect(origin: CGPoint(x: 0, y: indicator!.frame.maxY), size: CGSize(width: progressViewHolder.frame.width, height: progressViewHolder.frame.height / 2))
      
        uploadingLabel?.text =  "Uploading..."
        uploadingLabel?.adjustsFontSizeToFitWidth = true
        uploadingLabel?.textAlignment = .center
        uploadingLabel?.numberOfLines = 3
        
        progressViewHolder.addSubview(uploadingLabel!)
        progressViewHolder.addSubview(indicator!)
        return progressViewHolder
    }
    
    
    private func updateProgressView(progress : Float){
        indicator?.setProgress(progress/100, animated: true)
        self.uploadingLabel?.text = "Uploading \n \(Int(progress))%"
        if Int(progress) == 100{
            UIView.animate(withDuration: 2.0, delay: 0, options: .autoreverse) {[weak self] in
                self?.uploadingLabel?.text = "Uploaded"
                self?.navigationItem.rightBarButtonItem?.customView?.layer.opacity = 0
            } completion: { [weak self]  completed in
                self?.navigationItem.rightBarButtonItem?.customView?.removeFromSuperview()
            }


        }
    }
    
    func downloadFile(fromPath : String){
        if let ref =  storageWrapper.getReference(for: fromPath, from: false){
            storageWrapper.getDownloadURL(from: ref) {[weak self] resul in
                switch resul{
                case .success(let url):
                    print("Download file", "URL : \(url)")
                    self?.downloadFileWithUrl(urlString: url.absoluteString)
                case .failure(let error):
                    print("Download file", error)

                }
            }
        }
        
    }
    
    
    private func downloadFileWithUrl(urlString : String){

        let ref =  storageWrapper.getURLReference(for: urlString)
            storageWrapper.downloadToLocal(with: ref, fileName: "pikachu5.jpg"){[weak self] result in
                switch result{
                case .success(let url):
                    print("DOWNLOAD SUCCESS" ,  "download local url \(url.absoluteString)")
                    DispatchQueue.main.async {
                        self?.getDataFrom()
                    }
                case .failure(let error):
                    print("DOWNLOAD FAILURE" ,  "download error\(error.localizedDescription)")

                }
                print(ref.description)
                
            
        }
    }
    
    
    public func getDataFrom(){
        if let files =  storageWrapper.getDownloadedFiles(){
            self.dataSource =  files
            self.tableView?.reloadData()
        }
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell  = tableView.dequeueReusableCell(withIdentifier: cellIdentifier){
            let imageView =  UIImageView()
            imageView.frame = CGRect(x: cell.frame.maxX -  cell.frame.width / 2, y: 0, width: cell.frame.width / 2 , height: cell.frame.height)
            imageView.contentMode = .scaleAspectFit
            let label = UILabel()
            label.frame =  CGRect(x: 10, y: 0, width: cell.frame.width / 2, height: cell.frame.height)
            label.text =  (dataSource[indexPath.row] as! String)
            cell.addSubview(imageView)
            cell.addSubview(label)
            let ref = storageWrapper.getReference(for: "images/pikachu.jpeg", from: false)!
            imageView.addImage(with: ref, placeHolder: UIImage(systemName: "paperplane"))
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    
    deinit{
        storageWrapper.removeAllUploadObservers()
        storageWrapper.removeAllDownloadObservers()

    }
}


