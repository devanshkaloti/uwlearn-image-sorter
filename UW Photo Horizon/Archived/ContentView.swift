////
////  ContentView.swift
////  Multiple Image Picker
////
////  Created by Kavsoft on 27/04/20.
////  Copyright © 2020 Kavsoft. All rights reserved.
////
//
//// Code is Updated For Memory Issue...
//
//import SwiftUI
//import Photos
//import Vision
//
//
//struct ContentView: View {
//    @State private var selection = 0
//
//    var body: some View {
//
//        Home2()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
//
//struct Home2: View {
//    @State var showModal = false
//
//
//    var body: some View {
//        VStack(alignment: .center) {
//            
//            Button(action: {
//                let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
//
//                let rootViewController = storyboard.instantiateViewController(withIdentifier: "home")
//
//                           if let window = UIApplication.shared.windows.first {
//                               window.rootViewController = rootViewController
//                               window.endEditing(true)
//                               window.makeKeyAndVisible()
//                           }
//                
//            }, label: {
//                Text("Launch Home")
//            })
//        }
//    }
//}
