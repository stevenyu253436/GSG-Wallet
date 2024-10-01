//
//  MultilineTextField.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/10/2.
//

import Foundation
import SwiftUI
import UIKit

struct MultilineTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultilineTextField

        init(parent: MultilineTextField) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == parent.placeholder {
                textView.text = ""
                textView.textColor = .label // Use the default label color
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = .placeholderText // Use the default placeholder color
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .placeholderText
        textView.backgroundColor = UIColor.systemGray6 // Set the background color
        textView.layer.cornerRadius = 8 // Set the corner radius
        textView.text = placeholder // Set the placeholder text
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text && text != "" {
            uiView.text = text
            uiView.textColor = .label
        }
        
        if text.isEmpty {
            uiView.text = placeholder
            uiView.textColor = .placeholderText
        }
    }
}
