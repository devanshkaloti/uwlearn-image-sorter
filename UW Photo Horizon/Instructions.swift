//
//  Instructions.swift
//  test
//
//  Created by Devansh Kaloti on 2021-12-21.
//

import SwiftUI

struct Instructions: View {
    var body: some View {
        ScrollView {
            VStack {
                // 5 Steps:
                
                HStack {
                    Image("1")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .leading)
                    Text("1: Open the Photos App")
                }
                
                HStack {
                    Image("2")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .leading)
                    Text("2: Open the Albums Tab")
                }
                
                
                HStack {
                    Image("3")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .leading)
                    Text("3: Open the 'Sorted' Album")
                }
                
                HStack {
                    Image("4")
                        .resizable()
                        .frame(width: 250, height: 500, alignment: .leading)
                    Text("4: Tap on 'Select'")
                }
                
                HStack {
                    Image("5")
                        .resizable()
                        .frame(width: 250, height: 500, alignment: .leading)
                    Text("5: Tap on 'Delete'")
                }
                
                Text("This will delete all of the pictures in this album")
                
            }
        }
        .navigationTitle("Instructions to Delete Sorted Photos")
        .padding()
    }
}

struct Instructions_Previews: PreviewProvider {
    static var previews: some View {
        Instructions()
    }
}
