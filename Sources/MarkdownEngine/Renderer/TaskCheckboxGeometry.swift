//
//  TaskCheckboxGeometry.swift
//  MarkdownEngine
//
//  Created by Luca Chen on 09.07.26.
//
//  Shared geometry for the drawn task-checkbox square. The hidden `[ ] ` chars
//  are collapsed to ~zero advance by the styler, so `drawPosition`/
//  `boundingRect` of the box range sit at the task CONTENT's left edge. When
//  the embedder pins a marker column (`ListStyle.markerColumnWidth`) the square
//  is centred on that column, exactly where a bullet of the same depth sits;
//  otherwise it is right-aligned to the content edge with a small gap
//  (Obsidian-style), occupying the `- ` marker slot. Fragment draw and click
//  hit-test both use these functions so their rects can't drift apart.
//

import AppKit

enum TaskCheckboxGeometry {

    /// Side length of the square for the given (body) font.
    static func size(for font: NSFont) -> CGFloat {
        let ascent = max(0, font.ascender)
        let descent = max(0, -font.descender)
        let fontHeight = max(1, ceil(ascent + descent))
        let markerWidth = ("[ ]" as NSString).size(withAttributes: [.font: font]).width
        return max(1.0, min(floor(fontHeight * 1.2), floor(markerWidth * 1.2)))
    }

    static func size(for font: NSFont, style: TaskCheckboxStyle) -> CGFloat {
        style.size ?? size(for: font)
    }

    /// Left edge of the square. With a pinned marker column the box is centred
    /// on the column (same anchor as the bullet); without one it stays
    /// right-aligned to the content start x with `taskCheckbox.gap`.
    static func boxX(contentX: CGFloat, size: CGFloat, lists: ListStyle) -> CGFloat {
        guard let column = lists.markerColumnWidth else {
            return contentX - size - lists.taskCheckbox.gap
        }
        return contentX - column + (lists.markerCenterOffset ?? column / 2) - size / 2
    }
}
