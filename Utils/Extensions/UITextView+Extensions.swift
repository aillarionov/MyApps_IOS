//
//  UILabel+Extensions.swift
//  Informer
//
//  Created by Александр on 12.03.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit

extension UITextView {
    func setHTMLFromString(_ text: String) {
        
        let textColor = UIColor.black
        let font = self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        
        
        let modifiedFont = String(format:"<span style=\"color:\(textColor.toHexString());font-family: \(font.fontName); font-size: \(font.pointSize)\">%@</span>", text)
        
        guard let data = modifiedFont.utfData else { self.attributedText = nil; return }
        
        let attrStr = try? NSAttributedString(data: data, options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil)
        
        self.attributedText = attrStr
    }
}
