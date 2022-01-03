//
//  Home.swift
//  Home
//
//  Created by Devansh Kaloti on 2021-12-20.
//

import SwiftUI
import Photos
import Vision
import SSSwiftUIGIFView

enum Progress {
    case ready
    case loading
    case processed
}

struct Home: View {
    @State var numberOfPictures: String = "250"
    @State var date = Date()
    @State var endDate = Date()
    
    @State var progress: Progress = .ready
    
    var body: some View {
        NavigationView {
        VStack(alignment: .center) {
                
            Spacer()
        
            if progress == .loading {
                SwiftUIGIFPlayerView(gifName: "loading")
                    .frame(width: 250, height: 250)
                    .padding(.bottom)
                
            } else {
                Image("checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .padding(.bottom)
            }

            Spacer()

            if progress == .loading {
                Text("Processing")
            } else if progress == .ready {
                Text("Ready to run on pictures between ")
            } else {
                Text("Processing Completed")
            }
    
            
            HStack(alignment: .center){
                DatePicker(
                    "",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .fixedSize()
                
                Text("to")
            
                DatePicker(
                    "",
                    selection: $endDate,
                    displayedComponents: [.date]
                )
                .fixedSize()
            }
            
            Spacer()
            
            VStack {
                Button(action: {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM-dd-yyyy"
                    
                    progress = .loading
                    fetchPhotos(numberOfPhotos: Int(numberOfPictures) ?? 5, startDate: date as NSDate, endDate: endDate as NSDate)

                    if let images = images {
                        run(asset: images)
                    }
                    
                }, label: {
                    Text("1. Run the sorting Algorithm")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(GrowingButton())
                
                if let images = self.matchedImages {
                    
                    NavigationLink(destination: Gallery(images: images)) {
                        Text("2. Open the Sorted Album")
                            .frame(maxWidth: .infinity)

                    }
                    .buttonStyle(GrowingButton())
                        
                } else {
                    Button(action: {
                        
                    }, label: {
                        Text("DISABLED 2. Open the Sorted Album")
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(GrowingButton())
                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                }
        
                
    
                NavigationLink(destination: Instructions()) {
                    
                    Text("3. Delete the sorted pictures")
                        .frame(maxWidth: .infinity)

                }
                .buttonStyle(GrowingButton())

//                Button(action: {
//
//                   delete()
//
//                }, label: {
//
//
//                    Text("3. Delete the sorted pictures")
//                        .frame(maxWidth: .infinity)
//                })
//                .buttonStyle(GrowingButton())
//                .disabled(true)
//
            }
    
            Group {
                Spacer()
                
                Divider()
                Text("Run our ML model based algorithm to sort your UW Learn photos and work from your personal photos.")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 25)
                
                Text("How this app works")
                    .fontWeight(.bold)
                Text("1. Run the above algorithm")
                Text("2. Go to Photos -> Album")
                Text("3. Open the Sorted Album")
                Text("")
                Text("Privacy Policy")
                    .fontWeight(.bold)
                Text("At no point does this app save or upload your pictures. This is an open source project: _____ by Devansh Kaloti")
            }
//            Text("4. Edit or Delete all images")
        }
        .navigationTitle("UW Photo Horizon")
            
        }
    }
    
    @State private var numberOfPhotos: String = "200"

    @State var assetLink: PHAsset?
    
    func delete() {
        PHPhotoLibrary.shared().performChanges({
            if let matchedImages = matchedImages {
                PHAssetChangeRequest.deleteAssets(matchedImages as NSFastEnumeration)
                self.images?.removeAll()
                self.matchedImages?.removeAll()
            }
        })
    }
    
    func run(asset: [PHAsset]) {
        
        PHPhotoLibrary.shared().performChanges({
            guard let model = try? VNCoreMLModel(for: model1().model) else { return }
            
            let assetCollection = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "Sorted")
            
            if let images = images {
                images.forEach({ asset in
            
                    do {
                        let request = try VNCoreMLRequest(model: model, completionHandler: myResultsMethod)
                        self.assetLink = asset
                        
                        guard let cgImage = getAssetThumbnail(asset: asset).cgImage else { return }
                        
                        let handler = VNImageRequestHandler(cgImage: cgImage)
                        try handler.perform([request])
                        
                        guard let results = request.results as? [VNClassificationObservation] else { fatalError("huh") }

                        for classification in results {
                            
                            if (classification.identifier == "LEARN" && classification.confidence > 0.45) {
                                let creationRequest = PHAssetChangeRequest.init(for: asset)
                                assetCollection.addAssets([creationRequest] as NSArray)
                                self.matchedImages?.append(asset)
                            }
                            
                            print(classification.identifier, classification.confidence)
                        }
                    } catch {
                        print("Failed VNCoreMLRequest")
                    }
                })
            }
        
        }, completionHandler: {success, error in
            if success {
                progress = .processed
            } else {
                print("Error creating the asset: \(String(describing: error))")
                
            }
        })
    }
    
    @State var images: [PHAsset]? = [PHAsset]()
    @State var matchedImages: [PHAsset]? = [PHAsset]()

    func fetchPhotos(numberOfPhotos: Int, startDate:NSDate, endDate:NSDate) {
        // Sort the images by descending creation date and fetch the first 3
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = numberOfPhotos
        fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", startDate, endDate)

        // Fetch the image assets
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)

        if fetchResult.count > 0 {
            let totalImageCountNeeded = numberOfPhotos // number of images to fetch
            fetchPhotoAtIndex(0, totalImageCountNeeded, fetchResult)
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func fetchPhotoAtIndex(_ index:Int, _ totalImageCountNeeded: Int, _ fetchResult: PHFetchResult<PHAsset>) {

        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true


        let phAsset = fetchResult.object(at: index) as! PHAsset
        self.images?.append(phAsset)

        if index + 1 < fetchResult.count && self.images?.count ?? 0 < totalImageCountNeeded {
            self.fetchPhotoAtIndex(index + 1, totalImageCountNeeded, fetchResult)
        } else {
            print("Completed array: \(self.images)")
        }
   }

    func myResultsMethod(request: VNRequest, error: Error?) {
        // Empty for now
    }
}

struct Homes_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
