//
//  Gallery.swift
//  test
//
//  Created by Devansh Kaloti on 2021-12-21.
//

import SwiftUI
import Photos

struct Gallery: View {
    
    @State var images: [PHAsset]
    
    var columns: [GridItem] =
        Array(repeating: .init(.flexible(), alignment: .center), count: 3)
    
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
    
    var body: some View {
        ScrollView {
                   LazyVGrid(columns: columns, spacing: 10) {
                    
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: getAssetThumbnail(asset: image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                       }
                   }
               }
        .navigationTitle("Sorted Photos")
        .onDisappear(perform: {
            images.removeAll()
        })
    }
}
