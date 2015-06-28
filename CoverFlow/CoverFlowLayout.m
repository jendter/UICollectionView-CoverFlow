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


- (void)prepareLayout {

}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray* attributesForAllRectElements = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRegion;
    visibleRegion.origin = self.collectionView.contentOffset;
    visibleRegion.size   = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in attributesForAllRectElements) {
        //NSLog(@"attributes: %@", attributesForSingleElement);
        //NSLog(@"Center: {%f,%f}", attributesForSingleElement.center.x, attributesForSingleElement.center.y);
       
        CGFloat distanceFromCenterInPoints = fabs(attributesForSingleElement.center.x-(visibleRegion.origin.x+(visibleRegion.size.width/2)));
        CGFloat distanceFromCenterInPointsWithNegativeNums = attributesForSingleElement.center.x-(visibleRegion.origin.x+(visibleRegion.size.width/2));
        
        CGFloat distanceFromCenterInRangeZeroToOne = (visibleRegion.size.width - distanceFromCenterInPoints)/visibleRegion.size.width;
        CGFloat distanceFromCenterInRangeZeroToOneWithNegativeNums = (visibleRegion.size.width - distanceFromCenterInPointsWithNegativeNums)/visibleRegion.size.width;
        
        
        NSLog(@"The element at index: {%ld-%ld} is %f points from the center of the visible region.", attributesForSingleElement.indexPath.section, attributesForSingleElement.indexPath.item, distanceFromCenterInPoints );
        
        
        attributesForSingleElement.alpha =  distanceFromCenterInRangeZeroToOne;
        
        CGFloat itemScaleFactor = 1;
        itemScaleFactor = itemScaleFactor + distanceFromCenterInRangeZeroToOne*0.45; // The center item should get bigger
        
        attributesForSingleElement.zIndex = distanceFromCenterInRangeZeroToOne*100; // So that the center element is always on top
        
        attributesForSingleElement.transform3D = CATransform3DScale(attributesForSingleElement.transform3D, itemScaleFactor, itemScaleFactor, 0);
        
//        CGFloat rotationConstant;
//        if (distanceFromCenterInPointsWithNegativeNums < 0) {
//            rotationConstant = distanceFromCenterInRangeZeroToOne*-1;
//        } else {
//            rotationConstant = distanceFromCenterInRangeZeroToOne;
//        }
        
        CGFloat degreesToRotate = (distanceFromCenterInRangeZeroToOneWithNegativeNums-1) * 230;
        
        if (degreesToRotate < -60.0) {
            degreesToRotate = -60.0;
        } else if (degreesToRotate > 60.0) {
            degreesToRotate = 60.0;
        }
        
        //degreesToRotate = fabs(degreesToRotate);
        
        NSLog(@"Degrees to rotate: %f", degreesToRotate);
        
        // Rotate for
        //attributesForSingleElement.transform3D = CATransform3DRotate(attributesForSingleElement.transform3D, DegreesToRadians(degreesToRotate), 0, 1, 0);
        
        CATransform3D t = attributesForSingleElement.transform3D;
        //Add the perspective!!!
        t.m34 = 1.0/ -500;
        t = CATransform3DRotate(t, degreesToRotate * M_PI / 180.0f, 0, 1, 0);
        attributesForSingleElement.transform3D = t;
        
        
        // Rotate everything for a slight top down perspective
        //attributesForSingleElement.transform3D = CATransform3DRotate(attributesForSingleElement.transform3D, DegreesToRadians(20), 0.1, 0, 0);
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
