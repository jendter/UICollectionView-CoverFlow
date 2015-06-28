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
@property (nonatomic, strong) NSArray *cellAttributes;
//@property (nonatomic, strong) NSArray *testCellAttributes;
@property (nonatomic) CGFloat totalWidth;

@end

@implementation CoverFlowLayout


- (void)prepareLayout {
    
    NSLog(@"--------PREPARE FOR LAYOUT-----------");
    
    // Prepare all the currently known layoutAttribute and collectionView state information
    CGRect rect = self.collectionView.bounds; // where the problem is
    NSArray *attributesForAllRectElements = [super layoutAttributesForElementsInRect:rect];
    //self.testCellAttributes = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRegion;
    visibleRegion.origin = self.collectionView.contentOffset;
    visibleRegion.size   = self.collectionView.bounds.size;
    
    //NSLog(@"prepareLayout rect: origin{%f, %f} size{width:%f height:%f}", rect.origin.x, rect.origin.y, [self collectionViewContentSize].width, [self collectionViewContentSize].height);
    
    NSLog(@"visible region: origin{%f, %f} size{width:%f height:%f}", visibleRegion.origin.x, visibleRegion.origin.y, visibleRegion.size.width, visibleRegion.size.height);

    
    
    // Calculate scroll width and insets
    
    //int counter = 0;
    CGFloat newWidth = 0;
    UICollectionViewLayoutAttributes *firstLayoutAttributes;
    UICollectionViewLayoutAttributes *previousLayoutAttributes;
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in attributesForAllRectElements) {
//        if (CGRectIntersectsRect(attributesForSingleElement.frame, visibleRegion) ) {
//            NSLog(@"Visible!");
//        }
        
        NSLog(@"New old is: {%f, %f}", attributesForSingleElement.center.x, attributesForSingleElement.center.y);
        //attributesForSingleElement.center = (CGPoint){attributesForSingleElement.center.x+100, attributesForSingleElement.center.y};
        if (!previousLayoutAttributes) {
            firstLayoutAttributes = attributesForSingleElement;
            //attributesForSingleElement.center = (CGPoint){visibleRegion.size.width/2, attributesForSingleElement.center.y};
        } else {
            //attributesForSingleElement.center = (CGPoint){previousLayoutAttributes.center.x+300, attributesForSingleElement.center.y};
        }
        
        // Calculate the insets
//        UICollectionViewFlowLayout *currentCollectionView = (UICollectionViewFlowLayout *)self.collectionView;
//        CGFloat topAndBottomInset = 75; //CHANGE THIS, CURRENTLY HARDCODED.
//        currentCollectionView.sectionInset = UIEdgeInsetsMake(topAndBottomInset, 235, topAndBottomInset, 235);
        
        NSLog(@"New center is: {%f, %f}", attributesForSingleElement.center.x, attributesForSingleElement.center.y);
        
        newWidth = attributesForSingleElement.frame.origin.x+attributesForSingleElement.frame.size.width;
        NSLog(@"New width: %f", newWidth);
        NSLog(@"Now that we've changed the center, Origin:{%f, %f} Size:{width: %f, height: %f}", attributesForSingleElement.frame.origin.x, attributesForSingleElement.frame.origin.y, attributesForSingleElement.frame.size.width, attributesForSingleElement.frame.size.height);
        
        
        previousLayoutAttributes = attributesForSingleElement;
    }
    
    //newWidth = 2645; // HARDCODED, CHANGE
    
    //NSLog(@"------------INSET: %f", self.collectionView.contentInset.right);
    
    id<UICollectionViewDelegateFlowLayout> collectionViewDelegateFlowLayout = (id<UICollectionViewDelegateFlowLayout>)self.coverFlowDelegate;
    
    // Make this part of the CoverFlowDelegate protocol?
    // Right now there is nothing to guarantee that self.coverFlowDelegate is also a collectionViewDelegateFlowLayout
    // Make CoverFlowDelegate a subclass of <UICollectionViewDelegateFlowLayout>?
        // A better idea?
    CGFloat rightInset = [collectionViewDelegateFlowLayout collectionView:self.collectionView layout:self insetForSectionAtIndex:0].right;
    
    newWidth = newWidth + rightInset;
    
    //newWidth = newWidth + self.collectionView.contentInset.left + self.collectionView.contentInset.right;
    
    self.totalWidth = newWidth;
    
//    CGPoint origin = CGPointMake(0, 0);
    //CGSize size = [super collectionViewContentSize];
//    size = (CGSize){size.width+(self.collectionView.bounds.size.width/2), size.height};
    //self.collectionView.frame = CGRectMake(0, 0, newWidth, size.height);
    
    // Temp Hardcode
    // TAKE THIS OUT
    CGFloat cellCount = 12; // Make this part of the CoverFlowDelegate protocol? (getCellCount)
    
    // DO NOT DELETE
    if (![self.coverFlowDelegate layoutHasBeenViewed]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cellCount/2 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES]; // If animated = NO, breaks
    }
    
    
    self.cellAttributes = attributesForAllRectElements;
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGRect visibleRegion;
    visibleRegion.origin = self.collectionView.contentOffset;
    visibleRegion.size   = self.collectionView.bounds.size;
    
    NSLog(@"layoutAttributesForElementsInRect: origin{%f, %f} size{width:%f height:%f}", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    // WORKING, does not use any attributes from the above method
    //NSArray* attributesForAllRectElements = [super layoutAttributesForElementsInRect:rect];
    
    // Working, not needed
    NSMutableArray *attributesForAllRectElements = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in self.cellAttributes) {
        if (CGRectIntersectsRect(rect, attributesForSingleElement.frame)) {
            [attributesForAllRectElements addObject:attributesForSingleElement];
            NSLog(@"Intersection!");
        }
    }
    //NSArray* attributesForAllRectElements = ;
    //NSArray* attributesForAllRectElements = self.cellAttributes;
    

    
    //UICollectionViewLayoutAttributes *previousAttr;
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in attributesForAllRectElements) {
        
        // The actual center is:
        
        NSLog(@"The actual center is: {%f, %f}", attributesForSingleElement.center.x, attributesForSingleElement.center.y);
        
        // Important!! Must keep in sync with storyboard.
        // TODO: Make this a property
        //attributesForSingleElement.size = (CGSize){200, attributesForSingleElement.size.height};
        
        //attributesForSingleElement.center = (CGPoint){attributesForSingleElement.center.x+(self.collectionView.contentOffset.x/2), attributesForSingleElement.center.y};
        
        
        
        
        
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
    UICollectionViewLayoutAttributes *centerObject;
    int i = 0;
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in attributesForAllRectElements) {
        if (attributesForSingleElement.zIndex > centerObject.zIndex) {
            centerObject = attributesForSingleElement;
            centerObjectPosition = i;
            //NSLog(@"centerObjectPosition: %i", centerObjectPosition);
        }
        i++;
    }
    
    // Tell the delegate which cell is currently centered
    // In this example, the method in the delegate will set the title and description labels
    if (centerObject) {
        NSLog(@"IndexPath: %@", centerObject.indexPath);
        [self.coverFlowDelegate cellIsCenteredAtIndexPath:centerObject.indexPath];
    }
    
    
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

-(CGSize)collectionViewContentSize {
    NSLog(@"----------collectionViewContentSize-------------");
    CGSize size = [super collectionViewContentSize];
    
    // Use the totalWidth property set in the prepareLayout method
    size = (CGSize){self.totalWidth, size.height};
    
    //NSLog(@"Size height:%f width:%f", size.height, size.width);
    return size;
}

CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
};

@end
