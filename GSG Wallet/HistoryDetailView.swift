//
//  HistoryDetailView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/9/30.
//

import Foundation
import SwiftUI

struct HistoryDetailView: View {
    @Environment(\.presentationMode) var presentationMode // Access the presentation mode environment variable
    
    var body: some View {
        VStack {
            // Top bar with back arrow and title
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Navigate back when the button is tapped
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding()
                }

                Spacer()
                
                Text("交易歷史") // Title for History Detail
                    .font(.headline)
                
                Spacer()
                
                // Filter icon on the right
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding()
            }
            Spacer()
            
            // Empty history icon
            Image(systemName: "doc.text.magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.purple)
            
            Spacer()
        }
        .padding()
        .navigationBarHidden(true) // Hide the default navigation bar
    }
}

struct HistoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDetailView()
    }
}
