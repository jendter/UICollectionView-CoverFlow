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
@property (nonatomic) CGFloat totalWidth;

@end

@implementation CoverFlowLayout


- (void)prepareLayout {
        
    // Setting the basics that we will need later on
    CGRect visibleRegion;
    visibleRegion.origin = self.collectionView.contentOffset;
    visibleRegion.size   = self.collectionView.bounds.size;
    
    self.cellAttributes = [NSMutableArray array];
    
    NSUInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    
    
    // Set the initial spacing between all of the items
    UICollectionViewLayoutAttributes *previousAttr;
    for (int i = 0; i < cellCount; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        
        if (i == 0) {
            attr.center = (CGPoint){visibleRegion.size.width/2, visibleRegion.size.height/2};
        } else {
            //NSLog(@"previous attribute: %@", previousAttr);
            //NSLog(@"Previous Center: {%f, %f}", previousAttr.center.x, previousAttr.center.y);
            attr.center = (CGPoint){previousAttr.center.x+50, previousAttr.center.y};
        }
        
        attr.size = [self.coverFlowDelegate cellSize];
        
        previousAttr = attr;
        [self.cellAttributes addObject:attr];
    }
    
    
    
    // Correct for the center object having more spacing
    NSIndexPath *indexPathOfCenterLayoutAttribute = [self getIndexPathOfCenterForLayoutAttributes:self.cellAttributes inVisibleRegion:visibleRegion];
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in self.cellAttributes) {
        if (indexPathOfCenterLayoutAttribute.item == 0) {
            // Item is at the start
            if (attributesForSingleElement.indexPath.item > indexPathOfCenterLayoutAttribute.item) {
                attributesForSingleElement.center = (CGPoint){attributesForSingleElement.center.x+100, attributesForSingleElement.center.y};
            }
        } else if (indexPathOfCenterLayoutAttribute.item == self.cellAttributes.count-1) {
            // Item is at the end
            if (attributesForSingleElement.indexPath.item < indexPathOfCenterLayoutAttribute.item) {
                attributesForSingleElement.center = (CGPoint){attributesForSingleElement.center.x-100, attributesForSingleElement.center.y};
            }
        } else {
            // Item is inbetween
            if (attributesForSingleElement.indexPath.item > indexPathOfCenterLayoutAttribute.item) {
                //NSLog(@"Item is after");
                attributesForSingleElement.center = (CGPoint){attributesForSingleElement.center.x+100, attributesForSingleElement.center.y};
            } else if (attributesForSingleElement.indexPath.item < indexPathOfCenterLayoutAttribute.item) {
                //NSLog(@"Item is before");
                attributesForSingleElement.center = (CGPoint){attributesForSingleElement.center.x-100, attributesForSingleElement.center.y};
            } else {
                //NSLog(@"Item is the same");
            }
        }
    }
    
    // Let the coverFlowDelegate know that which cell is centered
    // In this case, this will trigger an update of the title and dewscription labels
    [self.coverFlowDelegate cellIsCenteredAtIndexPath:indexPathOfCenterLayoutAttribute];
    
    
    // Calculate scroll width and insets
    NSMutableArray *attributesForAllRectElements = self.cellAttributes;
    CGFloat newWidth = 0;
    UICollectionViewLayoutAttributes *firstLayoutAttributes;
    UICollectionViewLayoutAttributes *previousLayoutAttributes;
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in attributesForAllRectElements) {
        
        if (!previousLayoutAttributes) {
            firstLayoutAttributes = attributesForSingleElement;
        }
        
        newWidth = attributesForSingleElement.frame.origin.x+attributesForSingleElement.frame.size.width;
        
        //NSLog(@"New width: %f", newWidth);
        
        previousLayoutAttributes = attributesForSingleElement;
    }
    
    
    
    // Make this part of the CoverFlowDelegate protocol?
    // Right now there is nothing to guarantee that self.coverFlowDelegate is also a collectionViewDelegateFlowLayout
    // Make CoverFlowDelegate a subclass of <UICollectionViewDelegateFlowLayout>?
    // A better idea?
    id<UICollectionViewDelegateFlowLayout> collectionViewDelegateFlowLayout = (id<UICollectionViewDelegateFlowLayout>)self.coverFlowDelegate;
    CGFloat rightInset = [collectionViewDelegateFlowLayout collectionView:self.collectionView layout:self insetForSectionAtIndex:0].right;
    
    newWidth = newWidth + rightInset;
    
    //NSLog(@"------------FINAL SCROLL VIEW WIDTH: %f", newWidth);
    
    self.totalWidth = newWidth;
    
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGRect visibleRegion;
    visibleRegion.origin = self.collectionView.contentOffset;
    visibleRegion.size   = self.collectionView.bounds.size;
    
    //NSLog(@"layoutAttributesForElementsInRect: origin{%f, %f} size{width:%f height:%f}", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    // Get all of the elements that are in the rect
    NSMutableArray *attributesForAllRectElements = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in self.cellAttributes) {
        if (CGRectIntersectsRect(rect, attributesForSingleElement.frame)) {
            [attributesForAllRectElements addObject:attributesForSingleElement];
        }
    }
    
    // Do all of the 3d transforms
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in attributesForAllRectElements) {
        
        CGFloat distanceFromCenterInRangeZeroToOne = [self distanceFromCenterInRangeZeroToOne:attributesForSingleElement visibleRegion:visibleRegion];
        CGFloat distanceFromCenterInRangeZeroToOneWithNegativeNums = [self distanceFromCenterInRangeZeroToOneWithNegativeNums:attributesForSingleElement visibleRegion:visibleRegion];

        //NSLog(@"The element at index: {%ld-%ld} is %f points from the center of the visible region.", attributesForSingleElement.indexPath.section, attributesForSingleElement.indexPath.item, distanceFromCenterInPoints );
        
        // Currently have opacity adjustment turned off (looks better when using the old cover flow style)
        //attributesForSingleElement.alpha =  distanceFromCenterInRangeZeroToOne;
        
        CGFloat itemScaleFactor = 1;  // Only for debugging, if you want to experiment with different sizes. Normally, it should be 1.
        
        itemScaleFactor = itemScaleFactor + distanceFromCenterInRangeZeroToOne*0.45; // The center item should get bigger
        
        attributesForSingleElement.zIndex = distanceFromCenterInRangeZeroToOne*500; // The center item should always be on top
        
        attributesForSingleElement.transform3D = CATransform3DScale(attributesForSingleElement.transform3D, itemScaleFactor, itemScaleFactor, 0);
        
        
        CGFloat degreesToRotate = (distanceFromCenterInRangeZeroToOneWithNegativeNums-1) * 400;
        
        if (degreesToRotate < -60.0) {
            degreesToRotate = -60.0;
        } else if (degreesToRotate > 60.0) {
            degreesToRotate = 60.0;
        }
        
        //NSLog(@"Degrees to rotate: %f", degreesToRotate);
        
        
        CATransform3D t = attributesForSingleElement.transform3D;
        t.m34 = 1.0/ -500;
        t = CATransform3DRotate(t, DegreesToRadians(degreesToRotate), 0, 1, 0);
        attributesForSingleElement.transform3D = t;
        
        // TODO: (maybe) Rotate everything for a slight top down perspective
        
        //NSLog(@"current layout attributes: %@", attributesForSingleElement);
        
    }
    
    return attributesForAllRectElements;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

-(CGSize)collectionViewContentSize {
    CGSize size = [super collectionViewContentSize];
    size = (CGSize){self.totalWidth, size.height};
    return size;
}

CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
};


-(NSIndexPath *)getIndexPathOfCenterForLayoutAttributes:(NSArray *)layoutAttributes inVisibleRegion:(CGRect)visibleRegion {
    
    NSMutableArray *attributesForAllRectElements = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in layoutAttributes) {
        if (CGRectIntersectsRect(visibleRegion, attributesForSingleElement.frame)) {
            [attributesForAllRectElements addObject:attributesForSingleElement];
        }
    }
    
    UICollectionViewLayoutAttributes *centerObject;
    int bestZIndex = 0; // Start at lowest possible value (the highest being 500, in this case). See zIndex below.
    
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in attributesForAllRectElements) {
        
        CGFloat distanceFromCenterInRangeZeroToOne = [self distanceFromCenterInRangeZeroToOne:attributesForSingleElement visibleRegion:visibleRegion];
        int zIndex = (int)(distanceFromCenterInRangeZeroToOne*500);
        
        if (zIndex >= bestZIndex) {
            centerObject = attributesForSingleElement;
            bestZIndex = zIndex;
            //NSLog(@"new best!");
        }
        
        //NSLog(@"checking float: %f", distanceFromCenterInPoints);
        //NSLog(@"most centered zIndex: %i", bestZIndex);
        //NSLog(@"zIndex: %i", zIndex);
    }
    
    
    return centerObject.indexPath;
}

-(CGFloat)distanceFromCenterInPointsWithNegativeNums:(UICollectionViewLayoutAttributes *)attributesForSingleElement visibleRegion:(CGRect)visibleRegion {
    CGFloat distanceFromCenterInPointsWithNegativeNums = attributesForSingleElement.center.x-(visibleRegion.origin.x+(visibleRegion.size.width/2.00));
    return distanceFromCenterInPointsWithNegativeNums;
}

-(CGFloat)distanceFromCenterInPoints:(UICollectionViewLayoutAttributes *)attributesForSingleElement visibleRegion:(CGRect)visibleRegion {
    CGFloat distanceFromCenterInPoints = fabs([self distanceFromCenterInPointsWithNegativeNums:attributesForSingleElement visibleRegion:visibleRegion]);
    return distanceFromCenterInPoints;
}


-(CGFloat)distanceFromCenterInRangeZeroToOneWithNegativeNums:(UICollectionViewLayoutAttributes *)attributesForSingleElement visibleRegion:(CGRect)visibleRegion {
    CGFloat distanceFromCenterInPointsWithNegativeNums = [self distanceFromCenterInPointsWithNegativeNums:attributesForSingleElement visibleRegion:visibleRegion];
    CGFloat distanceFromCenterInRangeZeroToOneWithNegativeNums = (visibleRegion.size.width - distanceFromCenterInPointsWithNegativeNums)/visibleRegion.size.width;
    return distanceFromCenterInRangeZeroToOneWithNegativeNums;
}

-(CGFloat)distanceFromCenterInRangeZeroToOne:(UICollectionViewLayoutAttributes *)attributesForSingleElement visibleRegion:(CGRect)visibleRegion {
    CGFloat distanceFromCenterInPoints = [self distanceFromCenterInPoints:attributesForSingleElement visibleRegion:visibleRegion];
    CGFloat distanceFromCenterInRangeZeroToOne = (visibleRegion.size.width - distanceFromCenterInPoints)/visibleRegion.size.width;
    return distanceFromCenterInRangeZeroToOne;
}


@end
