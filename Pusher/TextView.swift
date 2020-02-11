//
//  TextView.swift
//  Pusher
//
//  Created by Alex Bartis on 11/02/2020.
//  Copyright © 2020 Alex Bartis. All rights reserved.
//

import Foundation
import SwiftUI
import AppKit

class ScrollableTextView: NSScrollView {
    @IBOutlet var textView: NSTextView!
}

struct TextView: NSViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> ScrollableTextView {
        var views: NSArray?
        Bundle.main.loadNibNamed("ScrollableTextView", owner: nil, topLevelObjects: &views)
        let scrollableTextView = views!.compactMap({ $0 as? ScrollableTextView }).first!
        scrollableTextView.textView.delegate = context.coordinator
        return scrollableTextView
    }

    func updateNSView(_ nsView: ScrollableTextView, context: Context) {
        guard nsView.textView.string != text else { return }
        nsView.textView.string = text
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        let parent: TextView

        init(_ textView: TextView) {
            self.parent = textView
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            self.parent.text = textView.string
        }
    }
}
