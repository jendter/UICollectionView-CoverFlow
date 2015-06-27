//
//  CoverFlowLayout.m
//  CoverFlow
//
//  Created by Josh Endter on 6/26/15.
//  Copyright (c) 2015 Josh Endter. All rights reserved.
//

#import "CoverFlowLayout.h"

@interface CoverFlowLayout ()

@property (nonatomic, strong) NSMutableArray *cellAttributes;

@end

@implementation CoverFlowLayout

//- (void)prepareLayout {
//    
//    NSLog(@"Prepare layout");
//    
//    self.cellAttributes = [NSMutableArray array];
//    
//    CGSize contentSize = [self collectionViewContentSize];
//    
//    NSUInteger cellCount = [self.collectionView numberOfItemsInSection:0];
//    
//    
//    
//    for (int i = 0; i < cellCount; i++) {
//        
//        CGFloat randX = arc4random_uniform(contentSize.width);
//        CGFloat randY = arc4random_uniform(contentSize.height);
//        
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        
//        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//        
//        attr.center = (CGPoint){randX, randY};
//        
//        attr.size = (CGSize){100,100};
//        
//        [self.cellAttributes addObject:attr];
//    }
//
//    
//}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* attributesForAllRectElements = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRegion;
    visibleRegion.origin = self.collectionView.contentOffset;
    visibleRegion.size   = self.collectionView.bounds.size;
    
    // Modify the layout attributes as needed here
    
    //UICollectionView *collectionView = [self collectionView];
    
    
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in attributesForAllRectElements) {
        //NSLog(@"attributes: %@", attributesForSingleElement);
        //NSLog(@"Center: {%f,%f}", attributesForSingleElement.center.x, attributesForSingleElement.center.y);
       
        CGFloat distanceFromCenterInPoints = fabs(attributesForSingleElement.center.x-(visibleRegion.origin.x+(visibleRegion.size.width/2)));
        CGFloat distanceFromCenterInRangeZeroToOne = (visibleRegion.size.width - distanceFromCenterInPoints)/visibleRegion.size.width;
        
        NSLog(@"The element at index: {%ld-%ld} is %f points from the center of the visable region.", attributesForSingleElement.indexPath.section, attributesForSingleElement.indexPath.item, distanceFromCenterInPoints );
        
        
        attributesForSingleElement.alpha =  distanceFromCenterInRangeZeroToOne;
        //attributesForSingleElement.transform = CGAffineTransformMakeRotation(0.2);
        
        CGFloat itemScaleFactor = 0.74;
        //if (distanceFromCenterInRangeZeroToOne > 0.8) {
            itemScaleFactor = itemScaleFactor + distanceFromCenterInRangeZeroToOne*0.4;
        //}
        
        attributesForSingleElement.zIndex = distanceFromCenterInRangeZeroToOne*100;
        
        attributesForSingleElement.transform3D = CATransform3DScale(attributesForSingleElement.transform3D, itemScaleFactor, itemScaleFactor, 0);
    }
    
    return attributesForAllRectElements;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
