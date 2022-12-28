//
//  String+Extension.swift
//  LiveGodLife
//
//  Created by Ador on 2022/11/06.
//

import UIKit

extension String {

    func attributed() -> NSMutableAttributedString {
        let attributed = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributed.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributed.length))
        return attributed
    }
}

extension String {
    var range: Range<String.Index> {
        return self.range(of: self) ?? Range<String.Index>(uncheckedBounds: (lower: self.startIndex, upper: self.endIndex))
    }
    
    var wholeRange: NSRange {
        return (self as NSString).range(of: self)
    }
    
    var html: NSAttributedString {
        return (try? NSAttributedString.init(data: self.data(using: .utf16) ?? Data(), options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)) ?? NSAttributedString()
    }
    
    var styling: NSAttributedString {
        return .init(string: self)
    }
    
    func withFont(_ font: UIFont) -> NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes:
            [
                .font: font,
            ]
        )
    }
    
    func withColor(_ color: UIColor) -> NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes:
            [
                .foregroundColor: color,
            ]
        )
    }
}

extension NSAttributedString {
    func addAttributes(_ attrs: [NSAttributedString.Key : Any]) -> NSAttributedString {
        let mutableString: NSMutableAttributedString = self.mutableCopy() as! NSMutableAttributedString
        mutableString.addAttributes(attrs, range: mutableString.string.wholeRange)
        return mutableString as NSAttributedString
    }
    
    func withFont(_ font: UIFont) -> NSAttributedString {
        return self.addAttributes([
            NSAttributedString.Key.font : font,
        ])
    }
    
    func withColor(_ color: UIColor) -> NSAttributedString {
        return self.addAttributes([
            NSAttributedString.Key.foregroundColor : color,
        ])
    }
    
    func withAlign(_ align: NSTextAlignment) -> NSAttributedString {
        let paragraph = (self.string.count > 0 ? self.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle : NSMutableParagraphStyle()) ?? NSMutableParagraphStyle()
        paragraph.alignment = align
        return self.addAttributes([
            NSAttributedString.Key.paragraphStyle : paragraph as NSParagraphStyle,
        ])
    }
    
    func withLineHeight(_ lineHeight: CGFloat) -> NSAttributedString {
        let paragraph = (self.string.count > 0 ? self.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle : NSMutableParagraphStyle()) ?? NSMutableParagraphStyle()
        paragraph.minimumLineHeight = lineHeight
        paragraph.maximumLineHeight = lineHeight
        return self.addAttributes([
            NSAttributedString.Key.paragraphStyle : paragraph as NSParagraphStyle,
        ])
    }
    
    func withKern(_ factor: CGFloat) -> NSAttributedString {
        return self.addAttributes([
            NSAttributedString.Key.kern : factor,
        ])
    }
    
    func withLineSpacing(_ lineSpacing: CGFloat) -> NSAttributedString {
        let paragraph = (self.string.count > 0 ? self.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle : NSMutableParagraphStyle()) ?? NSMutableParagraphStyle()
        paragraph.lineSpacing = lineSpacing
        return self.addAttributes([
            NSAttributedString.Key.paragraphStyle : paragraph as NSParagraphStyle,
        ])
    }
    
    func withMargin(_ margin: CGFloat) -> NSAttributedString {
        let paragraph = (self.string.count > 0 ? self.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle : NSMutableParagraphStyle()) ?? NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = margin
        paragraph.headIndent = margin
        paragraph.tailIndent = -margin
        return self.addAttributes([
            NSAttributedString.Key.paragraphStyle : paragraph as NSParagraphStyle,
        ])
    }
    
    func strike(color: UIColor) -> NSAttributedString {
        return self.addAttributes([
            NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.strokeColor : color,
        ])
    }
    
    func underline(color: UIColor) -> NSAttributedString {
        return self.addAttributes([
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.underlineColor : color,
        ])
    }
    
    var bold: NSAttributedString {
        let mutableString: NSMutableAttributedString = self.mutableCopy() as! NSMutableAttributedString
        self.enumerateAttribute(.font, in: mutableString.string.wholeRange, options: [], using: { (value, range, stop) in
            if
                let font = value as? UIFont,
                let descriptor = font.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits.traitBold)
            {
                let boldFont = UIFont(descriptor: descriptor, size: 0)
                mutableString.addAttribute(.font, value: boldFont, range: range)
            }
        })
        return mutableString as NSAttributedString
    }
    
    func bold(text: String) -> NSAttributedString {
        let mutableString: NSMutableAttributedString = self.mutableCopy() as! NSMutableAttributedString
        let range: NSRange = (self.string as NSString).range(of: text)
        self.enumerateAttribute(.font, in: range, options: [], using: { (value, range, stop) in
            if
                let font = value as? UIFont,
                let descriptor = font.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits.traitBold)
            {
                let boldFont = UIFont(descriptor: descriptor, size: 0)
                mutableString.addAttribute(.font, value: boldFont, range: range)
            }
        })
        return mutableString as NSAttributedString
    }
    
    func font(_ font: UIFont, text: String) -> NSAttributedString {
        let mutableString: NSMutableAttributedString = self.mutableCopy() as! NSMutableAttributedString
        let range: NSRange = (self.string as NSString).range(of: text)
        mutableString.addAttributes(
            [NSAttributedString.Key.font : font],
            range: range
        )
        return mutableString as NSAttributedString
    }
    
    func color(_ color: UIColor, text: String) -> NSAttributedString {
        let mutableString: NSMutableAttributedString = self.mutableCopy() as! NSMutableAttributedString
        let range: NSRange = (self.string as NSString).range(of: text)
        mutableString.addAttributes(
            [NSAttributedString.Key.foregroundColor : color],
            range: range
        )
        return mutableString as NSAttributedString
    }
    
    var verticalCenter: NSAttributedString {
        let mutableString: NSMutableAttributedString = self.mutableCopy() as! NSMutableAttributedString
        var maxHeight: CGFloat = 0
        let wholeRange: NSRange = (self.string as NSString).range(of: self.string)
        self.enumerateAttribute(NSAttributedString.Key.font, in: wholeRange, options: []) { font, range, _ in
            maxHeight = max((font as? UIFont)?.xHeight ?? 0, maxHeight)
        }
        self.enumerateAttribute(NSAttributedString.Key.font, in: wholeRange, options: []) { font, range, _ in
            guard let fontHeight = (font as? UIFont)?.xHeight else { return }
            mutableString.removeAttribute(NSAttributedString.Key.font, range: range)
            mutableString.addAttributes(
                [
                    NSAttributedString.Key.font: font as Any,
                    NSAttributedString.Key.baselineOffset: (maxHeight - fontHeight),
                ],
                range: range
            )
        }
        return mutableString
    }
}

extension NSAttributedString {
    static func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(lhs)
        result.append(rhs)
        return result
    }
    
    static func +=(lhs: inout NSAttributedString, rhs: NSAttributedString) {
        lhs = lhs + rhs
    }
    
    /// 구분점 목록 형태 들여쓰기 문자열 만들기
    /// - Note: 구분점 (간격) 내용   형태로 문자열을 만든다.
    /// - Parameters
    ///     - stringList: 본문
    ///     - bullet: 구분점으로 할 문자열
    ///     - font: 본문에 적용될 폰트
    ///     - bulletfont :구분점에 적용된 폰트
    ///     - indentation: This property represents the default tab interval in points. The system places tabs after the last specified in tabStops at integer multiples of this distance (if positive). Default value is 0.0.
    ///     - lineSpacing: This value is included in the line fragment heights in the layout manager.
    ///     - paragraphSpacing: This property contains the space (measured in points) added at the end of the paragraph to separate it from the following paragraph
    ///     - headIndent: the distance (in points) from the leading margin of a text container to the beginning of lines other than the first.
    ///     - textColor: 본문 색상
    ///     - bulletColor: 구분점 색상
    static func makeBulletParagraphString(
             stringList: [String],
             bullet: String = "\u{2022}",
             font: UIFont,
             bulletfont: UIFont,
             indentation: CGFloat = 20,
             lineSpacing: CGFloat = 2,
             paragraphSpacing: CGFloat = 12,
             headIndent: CGFloat = 20,
             textColor: UIColor = .gray,
             bulletColor: UIColor = .gray) -> NSAttributedString {

        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: bulletfont, NSAttributedString.Key.foregroundColor: bulletColor]

        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = headIndent

        let bulletList = NSMutableAttributedString()
        for (index,string) in stringList.enumerated() {
            var formattedString = "\(bullet)\t\(string)"
            if index < stringList.count - 1 {
                formattedString = formattedString + "\n"
            }
            let attributedString = NSMutableAttributedString(string: formattedString)
            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))

            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))

            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }
        return bulletList
    }
}

extension String {
    var title16White: NSAttributedString {
        return self.withFont(.title16).withColor(.white).withLineHeight(24)
    }
    var title26BoldGray6: NSAttributedString {
        return self.withFont(.title26Bold).withColor(.gray6).withKern(-0.5).withLineHeight(34)
    }
}
