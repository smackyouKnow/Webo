//
//  CCYLabel.swift
//  WeiBo
//
//  Created by godyu on 2018/5/3.
//  Copyright © 2018年 godyu. All rights reserved.
//

import UIKit

@objc
public protocol CCYLabelDelegate : NSObjectProtocol {
    @objc optional func labelDidSelectedLinkText(label : CCYLabel, link : String)
}

public class CCYLabel: UILabel {
    
    ///链接文字颜色
    public var linkTextColor = UIColor.blue
    public var selectedBackgroundColor = UIColor.lightGray
    public weak var delegate : CCYLabelDelegate?
    
    //MARK: 私有属性
    private lazy var linkRanges = [NSRange]()
    private var selectedRange : NSRange?
    private lazy var textStorage = NSTextStorage()
    private lazy var layoutManager = NSLayoutManager()
    private lazy var textContainer = NSTextContainer()
    
    
    ///重写父类属性set方法
    override public var text : String? {
        didSet {
            updateTextStorage()
        }
    }
    
    override public var attributedText : NSAttributedString? {
        didSet {
            updateTextStorage()
        }
    }
    
    override public var font : UIFont! {
        didSet {
            updateTextStorage()
        }
    }
    
    override public var textColor : UIColor! {
        didSet {
            updateTextStorage()
        }
    }
    
    private func updateTextStorage() {
        if attributedText == nil {
            return
        }
        let attrStringM = addLineBreak(attrString: attributedText!)
        regexLinkRange(attrString: attrStringM)
        addLinkAttribute(attrStringM: attrStringM)
        
        textStorage.setAttributedString(attrStringM)
        
        setNeedsDisplay()
    }
    
    private func addLinkAttribute(attrStringM : NSMutableAttributedString) {
        if attrStringM.length == 0 {
            return
        }
        var range = NSRange.init(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        
        attributes[NSAttributedStringKey.font] = font!
        attributes[NSAttributedStringKey.foregroundColor] = textColor
        attrStringM.addAttributes(attributes, range: range)
        
        attributes[NSAttributedStringKey.foregroundColor] = linkTextColor
        
        for r in linkRanges {
            attrStringM.setAttributes(attributes, range: r)
        }
    }
    
    private let patterns = ["[a-zA-Z]*://[a-zA-Z0-9/\\.]*", "#.*?#", "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]
    private func regexLinkRange(attrString : NSAttributedString) {
        linkRanges.removeAll()
        let regexRange = NSRange.init(location: 0, length: attrString.length)
        
        for pattern in patterns {
            let regex = try! NSRegularExpression.init(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
            let results = regex.matches(in: attrString.string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: regexRange)
            
            for r in results {
                linkRanges.append(r.range(at: 0))
            }
        }
    }
    
    //MARK: 设置段落样式
    private func addLineBreak(attrString : NSAttributedString) -> NSMutableAttributedString {
        let attrStringM = NSMutableAttributedString.init(attributedString: attrString)
        
        if attrStringM.length == 0 {
            return attrStringM
        }
        
        var range = NSRange.init(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        var paragraphStyle = attributes[NSAttributedStringKey.paragraphStyle] as? NSMutableParagraphStyle
        
        if paragraphStyle != nil {
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byWordWrapping
        } else {
            paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byWordWrapping
            attributes[NSAttributedStringKey.paragraphStyle] = paragraphStyle
            
            attrStringM.setAttributes(attributes, range: range)
        }
        return attrStringM
    }
    
    public override func drawText(in rect: CGRect) {
        let range = glyphsRange()
        let offset = glyphsOffset(range: range)
        
        layoutManager.drawBackground(forGlyphRange: range, at: offset)
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint.zero)
    }
    
    private func glyphsRange() -> NSRange {
        return NSRange.init(location: 0, length: textStorage.length)
    }
    
    private func glyphsOffset(range : NSRange) -> CGPoint {
        let rect = layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
        let height = (bounds.height - rect.height) * 0.5
        
        return CGPoint.init(x: 0, y: height)
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareLabel()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = bounds.size
    }
    
    private func prepareLabel() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        textContainer.lineFragmentPadding = 0
        isUserInteractionEnabled = true
    }
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
        selectedRange = linkRangeAtLocation(location: location)
        modifySelectedAttribute(isSet: true)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
        if let range = linkRangeAtLocation(location: location) {
            if !(range.location == selectedRange?.location && range.length == selectedRange?.length) {
                modifySelectedAttribute(isSet: false)
                selectedRange = range
                modifySelectedAttribute(isSet: true)
            }
        } else {
            modifySelectedAttribute(isSet: false)
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if selectedRange != nil {
            let text = (textStorage.string as NSString).substring(with: selectedRange!)
            delegate?.labelDidSelectedLinkText!(label: self, link: text)
            let when = DispatchTime.now() + Double(Int64(0.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.modifySelectedAttribute(isSet: false)
            }
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        modifySelectedAttribute(isSet: false)
    }
    
    private func modifySelectedAttribute(isSet : Bool) {
        if selectedRange == nil {
            return
        }
        
        var attributes = textStorage.attributes(at: 0, effectiveRange: nil)
        attributes[NSAttributedStringKey.foregroundColor] = linkTextColor
        let range = selectedRange!
        
        if isSet {
            attributes[NSAttributedStringKey.foregroundColor] = selectedBackgroundColor
        } else {
            attributes[NSAttributedStringKey.foregroundColor] = linkTextColor
            selectedRange = nil
        }
        
        textStorage.addAttributes(attributes, range: range)
        
        setNeedsDisplay()
        
    }
    
    private func linkRangeAtLocation(location : CGPoint) -> NSRange? {
        if textStorage.length == 0 {
            return nil
        }
        
        let offset = glyphsOffset(range: glyphsRange())
        let point = CGPoint.init(x: offset.x + location.x, y: offset.y + location.y)
        let index = layoutManager.glyphIndex(for: point, in: textContainer)
        
        for r in linkRanges {
            if index >= r.location && index <= r.location + r.length {
                return r
            }
        }
        return nil
    }
    
}
