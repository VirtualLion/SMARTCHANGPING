//
//  YZCollectionViewFlowLayout.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/8.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZCollectionViewFlowLayout.h"

@implementation YZCollectionViewFlowLayout

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for(int i = 0; i < [attributes count]; ++i) {
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        if (i == 0) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = self.sectionInset.left;
            currentLayoutAttributes.frame = frame;
            continue;
        }
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        //我们想设置的最大间距，可根据需要改
        CGFloat maximumSpacing = 0;
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
            maximumSpacing = [(id)self.collectionView.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:currentLayoutAttributes.indexPath.section];
        }else{
            maximumSpacing = self.minimumInteritemSpacing;
        }
        
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        
        CGRect frame = currentLayoutAttributes.frame;
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            frame.origin.x = origin + maximumSpacing;
        }else{
            frame.origin.x = self.sectionInset.left;
        }
        currentLayoutAttributes.frame = frame;
    }
    
    return attributes;
}

@end
