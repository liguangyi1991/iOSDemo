//
//  TestCollectionViewLayout.swift
//  hangge_1602
//
//  Created by MAC on 2024/9/29.
//  Copyright © 2024 hangge. All rights reserved.
//

import UIKit

class TestCollectionViewLayout: UICollectionViewLayout {
    
    // 定义每个section的列数
        var columnCount: Int = 1
        
        // 定义每个item的最小尺寸
        var itemSize: CGSize = CGSize(width: 100, height: 100)
        
        // 定义section的内边距
        var sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // 定义列之间的间距
        var minimumColumnSpacing: CGFloat = 10
        
        // 定义行之间的间距
        var minimumRowSpacing: CGFloat = -90
        
        // 存储每一列的最大Y值
        var columnHeights: [CGFloat] = []
        
        // 存储所有item的布局属性
        var cache: [UICollectionViewLayoutAttributes] = []
        
        // 缓存内容的高度
        var contentHeight: CGFloat = 0
        
        override var collectionViewContentSize: CGSize {
            return CGSize(width: collectionView!.bounds.width, height: contentHeight)
        }
        
        override func prepare() {
            super.prepare()
            
            columnHeights = []
            for _ in 0..<columnCount {
                columnHeights.append(sectionInset.top)
            }
            print("测试的值",columnHeights)
            cache = []
            
            let numberOfItems = collectionView!.numberOfItems(inSection: 0)
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let width = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(columnCount - 1) * minimumColumnSpacing) / CGFloat(columnCount)
                let column = indexPath.item % columnCount
                let xOffset = sectionInset.left + CGFloat(column) * (width + minimumColumnSpacing)
                let yOffset = columnHeights[column]
//                attributes.
                if(item != numberOfItems - 1)
                {
                    attributes.frame = CGRect(x: xOffset + 12, y: 12, width: width - 24, height: itemSize.height)
                    columnHeights[column] = max(columnHeights[column], yOffset + itemSize.height + minimumRowSpacing)
                }else{
                    attributes.frame = CGRect(x: xOffset, y: 0, width: width, height: itemSize.height)
//                    columnHeights[column] = max(columnHeights[column], itemSize.height + minimumRowSpacing)
                }
                attributes.zIndex = indexPath.row;

                contentHeight = max(contentHeight, columnHeights[column])
                cache.append(attributes)
            }
        }
        
        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            return cache.filter { $0.frame.intersects(rect) }
        }
        
        override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            return cache.first { $0.indexPath == indexPath }
        }
        
        override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return true
        }
}
