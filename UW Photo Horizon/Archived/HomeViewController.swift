////
////  HomeViewController.swift
////  test
////
////  Created by Devansh Kaloti on 2021-12-20.
////
//
//import Foundation
//import UIKit
//import Material
//import Photos
//import Vision
//
//class HomeViewController: UIViewController, UITextFieldDelegate {
//
//    @IBOutlet weak var numberOfPhotos: UITextField!
//    
//    var asset: PHAsset?
//    var abc: PHAssetCollectionChangeRequest?
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//            // return NO to disallow editing.
//            print("TextField should begin editing method called")
//            return true
//        }
//
//        func textFieldDidBeginEditing(_ textField: UITextField) {
//            // became first responder
//            print("TextField did begin editing method called")
//        }
//
//        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//            // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//            print("TextField should snd editing method called")
//            return true
//        }
//
//        func textFieldDidEndEditing(_ textField: UITextField) {
//            // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//            print("TextField did end editing method called")
//        }
//
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//            // if implemented, called in place of textFieldDidEndEditing:
//            print("TextField did end editing with reason method called")
//        }
//
//        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            // return NO to not change text
//            print("While entering the characters this method gets called")
//            return true
//        }
//
//        func textFieldShouldClear(_ textField: UITextField) -> Bool {
//            // called when clear button pressed. return NO to ignore (no notifications)
//            print("TextField should clear method called")
//            return true
//        }
//
//        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            // called when 'return' key pressed. return NO to ignore.
//            print("TextField should return method called")
//            // may be useful: textField.resignFirstResponder()
//            return true
//        }
//    
//    
//    @IBAction func run(_ sender: Any) {
//        let text = numberOfPhotos.text
//
//        if let text = text as? Int {
//            self.fetchPhotos(numberOfPhotos: text)
//            if let images = images {
//                run(asset: images)
//            }
//        }
//
//    }
//    
//    func run(asset: [PHAsset]) {
//        
//        PHPhotoLibrary.shared().performChanges({
//            guard let model = try? VNCoreMLModel(for: model1().model) else {
//                return
//            }
//            
//            let assetCollection = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "Sorted")
//            
//            if let images = self.images {
//                images.forEach({ asset in
//            
//                    do {
//                        let request = try VNCoreMLRequest(model: model, completionHandler: self.myResultsMethod)
//                        self.asset = asset
//                        
//                        guard let cgImage = self.getAssetThumbnail(asset: asset).cgImage else {
//                        return
//                    }
//                        let handler = VNImageRequestHandler(cgImage: cgImage)
//                        try handler.perform([request])
//                        
//                        guard let results = request.results as? [VNClassificationObservation]
//                            else { fatalError("huh") }
//
//                        for classification in results {
//                            
//                            if (classification.identifier == "LEARN" && classification.confidence > 0.45) {
//                            
//                                let creationRequest = PHAssetChangeRequest.init(for: asset)
//                               assetCollection.addAssets([creationRequest] as NSArray)
//                            }
//                            print(classification.identifier, // the scene label
//                                  classification.confidence)
//                        }
//                    } catch {
//                        print("FAILED")
//                    }
//                    
//                    
//                    
//                    
//                    
//
//                })
//            }
//        
//            
////            }
//        }, completionHandler: {success, error in
//            if !success { print("Error creating the asset: \(String(describing: error))") }
//        })
//        
//    
//    }
//    
//    
//    var images: [PHAsset]? = [PHAsset]()
//
//    func fetchPhotos(numberOfPhotos: Int) {
//        
//        
//           // Sort the images by descending creation date and fetch the first 3
//           let fetchOptions = PHFetchOptions()
//           fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
//           fetchOptions.fetchLimit = numberOfPhotos
//
//           // Fetch the image assets
//           let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
//
//           // If the fetch result isn't empty,
//           // proceed with the image request
//           if fetchResult.count > 0 {
//               let totalImageCountNeeded = numberOfPhotos // <-- The number of images to fetch
//               fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
//           }
//        
//       }
//    
//    func getAssetThumbnail(asset: PHAsset) -> UIImage {
//        let manager = PHImageManager.default()
//        let option = PHImageRequestOptions()
//        var thumbnail = UIImage()
//        option.isSynchronous = true
//        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
//            thumbnail = result!
//        })
//        return thumbnail
//    }
//    
//
//       // Repeatedly call the following method while incrementing
//       // the index until all the photos are fetched
//    func fetchPhotoAtIndex(_ index:Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {
//
//           // Note that if the request is not set to synchronous
//           // the requestImageForAsset will return both the image
//           // and thumbnail; by setting synchronous to true it
//           // will return just the thumbnail
//           let requestOptions = PHImageRequestOptions()
//           requestOptions.isSynchronous = true
//
//           // Perform the image request
////           PHImageManager.default().requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
////
//
//        
////        self.images.append(fetchResult)
//        
////        self.a = fetchResult.object(at: index) as PHAsset
//        let aaa = fetchResult.object(at: index) as! PHAsset
//        self.images?.append(aaa)
//        
//               // If you haven't already reached the first
//               // index of the fetch result and if you haven't
//               // already stored all of the images you need,
//               // perform the fetch request again with an
//               // incremented index
//        if index + 1 < fetchResult.count && self.images?.count ?? 0 < totalImageCountNeeded {
//                   self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
//               } else {
//                   // Else you have completed creating your array
//                   print("Completed array: \(self.images)")
//               }
//       }
//    
//        func myResultsMethod(request: VNRequest, error: Error?) {
//        }
//}
