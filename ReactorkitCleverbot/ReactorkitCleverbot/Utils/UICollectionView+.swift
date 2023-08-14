//
//  UICollectionView+.swift
//  ReactorkitCleverbot
//
//  Created by yangjs on 2023/08/14.
//

import UIKit

extension UICollectionView {
    func isReachedBottom(withOffset offset: CGFloat = 0) -> Bool {
        guard self.contentSize.height > self.height, self.height > 0 else { return true}
        let contentOffsetBottom = self.contentOffset.y + self.height
        return contentOffsetBottom - offset >= self.contentSize.height
    }
    
    func scrollToBottom(animated: Bool) {
        let scrollHeight = self.contentSize.height + self.contentInset.top + self.contentInset.bottom
        guard scrollHeight > self.height, self.height > 0 else { return }
        let targetOffset = CGPoint(x: 0, y: self.contentSize.height + self.contentInset.bottom - self.height)
        self.setContentOffset(targetOffset, animated: animated)
    }
    
    func cellWidth(forSectionAt section: Int) -> CGFloat {
        var width = self.width
        width -= self.contentInset.left
        width -= self.contentInset.right
        
        if let delegate = self.delegate as? UICollectionViewDelegateFlowLayout,
           let inset = delegate.collectionView?(self, layout: self.collectionViewLayout, insetForSectionAt: section) {
            width -= inset.left
            width -= inset.right
        } else if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            width -= layout.sectionInset.left
            width -= layout.sectionInset.right
        }
        
        return width
    }
}
