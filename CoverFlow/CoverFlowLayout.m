//
//  CoverFlowLayout.m
//  CoverFlow
//
//  Created by Josh Endter on 6/26/15.
//  Copyright (c) 2015 Josh Endter. All rights reserved.
//

#import "CoverFlowLayout.h"
#import "CoverFlowDelegate.h"

@interface CoverFlowLayout ()

@property (nonatomic, strong) IBOutlet id<CoverFlowDelegate> coverFlowDelegate;
@property (nonatomic, strong) NSMutableArray *cellAttributes;

@end

@implementation CoverFlowLayout


- (void)prepareLayout {
    
    NSLog(@"--------PREPARE FOR LAYOUT-----------");
    
    NSLog(@"Delegate: %@", self.coverFlowDelegate);
    
    self.cellAttributes = [NSMutableArray array];
    
    CGSize contentSize = [self collectionViewContentSize];
    
    NSUInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    
    NSLog(@"Cell count: %lu", cellCount);
    
    for (int i = 0; i < cellCount; i++) {
        
//        CGFloat randX = arc4random_uniform(contentSize.width);
//        CGFloat randY = arc4random_uniform(contentSize.height);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        //attr.size.width = 100;
        attr.size = (CGSize){100, 184};
        
        [self.cellAttributes addObject:attr];
    }
    
    NSLog(@"%@", self.cellAttributes);
    
//    CGSize contentSize = [self collectionViewContentSize];
//    
//    NSUInteger cellCount = [self.collectionView numberOfItemsInSection:0];

//    - (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath
//atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
//animated:(BOOL)animated
    
    if (![self.coverFlowDelegate layoutHasBeenViewed]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cellCount/2 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* attributesForAllRectElements = [super layoutAttributesForElementsInRect:rect];
    //attributesForAllRectElements = self.cellAttributes;
    
    CGRect visibleRegion;
    visibleRegion.origin = self.collectionView.contentOffset;
    visibleRegion.size   = self.collectionView.bounds.size;
    
    //UICollectionViewLayoutAttributes *previousAttr;
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in attributesForAllRectElements) {
        
        // Important!! Must keep in sync with storyboard.
        // TODO: Make this a property
        attributesForSingleElement.size = (CGSize){200, attributesForSingleElement.size.height};
        //NSLog(@"attributes: %@", attributesForSingleElement);
        //NSLog(@"Center: {%f,%f}", attributesForSingleElement.center.x, attributesForSingleElement.center.y);
       
        // Warning: Insanely long variable names ahead.
        
        CGFloat distanceFromCenterInPoints = fabs(attributesForSingleElement.center.x-(visibleRegion.origin.x+(visibleRegion.size.width/2)));
        CGFloat distanceFromCenterInPointsWithNegativeNums = attributesForSingleElement.center.x-(visibleRegion.origin.x+(visibleRegion.size.width/2));
        
        CGFloat distanceFromCenterInRangeZeroToOne = (visibleRegion.size.width - distanceFromCenterInPoints)/visibleRegion.size.width;
        CGFloat distanceFromCenterInRangeZeroToOneWithNegativeNums = (visibleRegion.size.width - distanceFromCenterInPointsWithNegativeNums)/visibleRegion.size.width;
        
        
        NSLog(@"The element at index: {%ld-%ld} is %f points from the center of the visible region.", attributesForSingleElement.indexPath.section, attributesForSingleElement.indexPath.item, distanceFromCenterInPoints );
        
        
        attributesForSingleElement.alpha =  distanceFromCenterInRangeZeroToOne;
        
        CGFloat itemScaleFactor = 0.7;  // Only for debugging, if you want to experiment with different sizes
                                        // Normally, it should be 1
        itemScaleFactor = itemScaleFactor + distanceFromCenterInRangeZeroToOne*0.45; // The center item should get bigger
        
        attributesForSingleElement.zIndex = distanceFromCenterInRangeZeroToOne*100; // So that the center element is always on top
        
        attributesForSingleElement.transform3D = CATransform3DScale(attributesForSingleElement.transform3D, itemScaleFactor, itemScaleFactor, 0);
        
        
        CGFloat degreesToRotate = (distanceFromCenterInRangeZeroToOneWithNegativeNums-1) * 230;
        
        if (degreesToRotate < -60.0) {
            degreesToRotate = -60.0;
        } else if (degreesToRotate > 60.0) {
            degreesToRotate = 60.0;
        }
        
        NSLog(@"Degrees to rotate: %f", degreesToRotate);
        
        
        CATransform3D t = attributesForSingleElement.transform3D;
        t.m34 = 1.0/ -500;
        t = CATransform3DRotate(t, degreesToRotate * M_PI / 180.0f, 0, 1, 0);
        attributesForSingleElement.transform3D = t;
        

        NSLog(@"Current width:%f height:%f", attributesForSingleElement.frame.size.width, attributesForSingleElement.frame.size.height);
        
        
        // TODO: (maybe) Rotate everything for a slight top down perspective

        NSLog(@"current layout attributes: %@", attributesForSingleElement);
    }
    
    // Reposition the elements
    
    // Put this with the above loop
    int centerObjectPosition = 0;
    UICollectionViewLayoutAttributes *centerObject = [UICollectionViewLayoutAttributes new];
    int i = 0;
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in attributesForAllRectElements) {
        if (attributesForSingleElement.zIndex > centerObject.zIndex) {
            centerObject = attributesForSingleElement;
            centerObjectPosition = i;
        }
        i++;
    }
    
    // Tell the delegate which cell is currently centered
    // In this example, the method in the delegate will set the title and description labels
    [self.coverFlowDelegate cellIsCenteredAtIndexPath:centerObject.indexPath];
    
    i = 0;
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in attributesForAllRectElements) {
        if (i == 0) {
            
        } else if (i < centerObjectPosition) {
            
        } else if (i == centerObjectPosition) {
            
        } else if (i > centerObjectPosition) {
            
        }
        i++;
    }
    
    
    
    return attributesForAllRectElements;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
};

@end
