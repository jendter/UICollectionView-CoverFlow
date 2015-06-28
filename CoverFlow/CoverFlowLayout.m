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
//@property (nonatomic, strong) NSArray *testCellAttributes;
@property (nonatomic) CGFloat totalWidth;

//@property (nonatomic) BOOL hasInitialLayout;

@end

@implementation CoverFlowLayout


- (void)prepareLayout {
    
    NSLog(@"--------PREPARE FOR LAYOUT-----------");
    
    CGRect visibleRegion;
    visibleRegion.origin = self.collectionView.contentOffset;
    visibleRegion.size   = self.collectionView.bounds.size;
    
    // Prepare all the currently known layoutAttribute and collectionView state information
    //CGRect rect = self.collectionView.bounds; // where the problem is
    //NSArray *attributesForAllRectElements = [super layoutAttributesForElementsInRect:rect];
    
    self.cellAttributes = [NSMutableArray array];
    CGSize contentSize = self.collectionView.bounds.size;
    NSLog(@"Content Size width: %f, height: %f", contentSize.width, contentSize.height);
    
    NSUInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    
    
    UICollectionViewLayoutAttributes *previousAttr;
    for (int i = 0; i < cellCount; i++) {
        
        //CGFloat randX = arc4random_uniform(contentSize.width);
        //CGFloat randY = arc4random_uniform(contentSize.height);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        
        if (i == 0) {
            attr.center = (CGPoint){visibleRegion.size.width/2, visibleRegion.size.height/2};
        } else {
            //UICollectionViewLayoutAttributes *previousLayoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i-1 inSection:0]];
            NSLog(@"previous attribute: %@", previousAttr);
            NSLog(@"Previous Center: {%f, %f}", previousAttr.center.x, previousAttr.center.y);
            attr.center = (CGPoint){previousAttr.center.x+50, previousAttr.center.y};
        }
        
        
        
        //attr.center = (CGPoint){randX, randY};
        
        attr.size = (CGSize){140,129};
        
        
        previousAttr = attr;
        [self.cellAttributes addObject:attr];
    }
    
    
    [self getIndexPathOfCenterForLayoutAttributes:self.cellAttributes inVisibleRegion:visibleRegion];
    
    // Correct for the center object having more spacing
    //previousAttr = nil;
    NSIndexPath *indexPathOfCenterLayoutAttribute = [self getIndexPathOfCenterForLayoutAttributes:self.cellAttributes inVisibleRegion:visibleRegion];
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in self.cellAttributes) {
        
        if (indexPathOfCenterLayoutAttribute.item == 0) {
            // Item is at the start
            NSLog(@"Item is at the start");
            if (attributesForSingleElement.indexPath.item > indexPathOfCenterLayoutAttribute.item) {
                //NSLog(@"Item is after");
                attributesForSingleElement.center = (CGPoint){attributesForSingleElement.center.x+100, attributesForSingleElement.center.y};
            } else {
                //NSLog(@"Item is the same");
            }
        } else if (indexPathOfCenterLayoutAttribute.item == self.cellAttributes.count-1) {
            // Item is at the end
            //NSLog(@"Item is at the end");
            if (attributesForSingleElement.indexPath.item < indexPathOfCenterLayoutAttribute.item) {
                //NSLog(@"Item is before");
                attributesForSingleElement.center = (CGPoint){attributesForSingleElement.center.x-100, attributesForSingleElement.center.y};
            } else {
               // NSLog(@"Item is the same");
            }
        } else {
            // Item is inbetween
            //NSLog(@"Item is inbetween");
            if (attributesForSingleElement.indexPath.item > indexPathOfCenterLayoutAttribute.item) {
                NSLog(@"Item is after");
                attributesForSingleElement.center = (CGPoint){attributesForSingleElement.center.x+100, attributesForSingleElement.center.y};
            } else if (attributesForSingleElement.indexPath.item < indexPathOfCenterLayoutAttribute.item) {
                NSLog(@"Item is before");
                attributesForSingleElement.center = (CGPoint){attributesForSingleElement.center.x-100, attributesForSingleElement.center.y};
            } else {
                NSLog(@"Item is the same");
            }
            
        }
        
        //previousAttr = attributesForSingleElement;
        
        // If we are one behind the index path of the center object
        // AND this isn't the first object
            // Add
        
            // if the center item is zero, add to the right
            // if the center item is
        
        // attributesForSingleElement.indexPath.item == 0
//        if () {
//            
//        } else {
//            
//        }
        
        // if the center object is zero
        
        
        
    }
    
    
    
    NSArray *attributesForAllRectElements = [NSArray arrayWithArray:self.cellAttributes];
    
    
    
    //self.testCellAttributes = [super layoutAttributesForElementsInRect:rect];
    
    
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

            //attributesForSingleElement.center = (CGPoint){previousLayoutAttributes.center.x+100, attributesForSingleElement.center.y};
            
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
    
//    if (!self.hasInitialLayout) {
//        self.hasInitialLayout = YES;
//        [self invalidateLayout];
//    } else {
//        self.hasInitialLayout = NO;
//    }
    
    
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
    
    NSLog(@"------------FINAL SCROLL VIEW WIDTH: %f", newWidth);
    
    self.totalWidth = newWidth;
    
//    CGPoint origin = CGPointMake(0, 0);
    //CGSize size = [super collectionViewContentSize];
//    size = (CGSize){size.width+(self.collectionView.bounds.size.width/2), size.height};
    //self.collectionView.frame = CGRectMake(0, 0, newWidth, size.height);
    

    
    
    self.cellAttributes = attributesForAllRectElements;
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGRect visibleRegion;
    visibleRegion.origin = self.collectionView.contentOffset;
    visibleRegion.size   = self.collectionView.bounds.size;
    
    NSLog(@"layoutAttributesForElementsInRect: origin{%f, %f} size{width:%f height:%f}", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    // WORKING, does not use any attributes from the above method
    //NSArray* attributesForAllRectElements = [super layoutAttributesForElementsInRect:rect];
    
    // Working
    int count = 0;
    int lastItem = 0;
    NSMutableArray *attributesForAllRectElements = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in self.cellAttributes) {
        if (CGRectIntersectsRect(rect, attributesForSingleElement.frame)) {
            [attributesForAllRectElements addObject:attributesForSingleElement];
            NSLog(@"Intersection!");
            lastItem = count;
        }
        
//        NSLog(@"last item: %i, count: %i", lastItem, count);
//        if (lastItem==count-1) {
//            // For debugging, we're going to try to add another element into the array
//            [attributesForAllRectElements addObject:attributesForSingleElement];
//        }
        
//        if (count < 4) {
//            [attributesForAllRectElements addObject:attributesForSingleElement];
//        }
        
        
        count++;
    }
    
    NSLog(@"Number of attributes: %lu!", attributesForAllRectElements.count);

    
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
        
        // TODO: Make all of these instance methods
        CGFloat distanceFromCenterInPoints = fabs(attributesForSingleElement.center.x-(visibleRegion.origin.x+(visibleRegion.size.width/2)));
        CGFloat distanceFromCenterInPointsWithNegativeNums = attributesForSingleElement.center.x-(visibleRegion.origin.x+(visibleRegion.size.width/2));
        
        CGFloat distanceFromCenterInRangeZeroToOne = (visibleRegion.size.width - distanceFromCenterInPoints)/visibleRegion.size.width;
        CGFloat distanceFromCenterInRangeZeroToOneWithNegativeNums = (visibleRegion.size.width - distanceFromCenterInPointsWithNegativeNums)/visibleRegion.size.width;
        
        
        NSLog(@"The element at index: {%ld-%ld} is %f points from the center of the visible region.", attributesForSingleElement.indexPath.section, attributesForSingleElement.indexPath.item, distanceFromCenterInPoints );
        
        // Currently have opacity adjustment turned off (looks better when using the old cover flow style)
        //attributesForSingleElement.alpha =  distanceFromCenterInRangeZeroToOne;
        
        CGFloat itemScaleFactor = 1;  // Only for debugging, if you want to experiment with different sizes
        // Normally, it should be 1
        itemScaleFactor = itemScaleFactor + distanceFromCenterInRangeZeroToOne*0.45; // The center item should get bigger
        
        attributesForSingleElement.zIndex = distanceFromCenterInRangeZeroToOne*500; // So that the center element is always on top
        
        attributesForSingleElement.transform3D = CATransform3DScale(attributesForSingleElement.transform3D, itemScaleFactor, itemScaleFactor, 0);
        
        
        CGFloat degreesToRotate = (distanceFromCenterInRangeZeroToOneWithNegativeNums-1) * 400;
        
        if (degreesToRotate < -60.0) {
            degreesToRotate = -60.0;
        } else if (degreesToRotate > 60.0) {
            degreesToRotate = 60.0;
        }
        
        NSLog(@"Degrees to rotate: %f", degreesToRotate);
        
        
        CATransform3D t = attributesForSingleElement.transform3D;
        t.m34 = 1.0/ -500;
        t = CATransform3DRotate(t, DegreesToRadians(degreesToRotate), 0, 1, 0);
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
    
    
//    i = 0;
//    for (UICollectionViewLayoutAttributes *attributesForSingleElement in attributesForAllRectElements) {
//        if (i == 0) {
//            
//        } else if (i < centerObjectPosition) {
//            
//        } else if (i == centerObjectPosition) {
//            
//        } else if (i > centerObjectPosition) {
//            
//        }
//        i++;
//    }
    
    
    
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


-(NSIndexPath *)getIndexPathOfCenterForLayoutAttributes:(NSArray *)layoutAttributes inVisibleRegion:(CGRect)visibleRegion {
    
    NSMutableArray *attributesForAllRectElements = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributesForSingleElement in layoutAttributes) {
        if (CGRectIntersectsRect(visibleRegion, attributesForSingleElement.frame)) {
            [attributesForAllRectElements addObject:attributesForSingleElement];
        }
    }
    
    UICollectionViewLayoutAttributes *centerObject;
    int bestZIndex = 0; // Init at lowest possible value
    //UICollectionViewLayoutAttributes *centerAttribute;

    for (UICollectionViewLayoutAttributes *attributesForSingleElement in attributesForAllRectElements) {
        
        // TODO: Use the instance method versions of these, once they are made
        CGFloat distanceFromCenterInPoints = fabs(attributesForSingleElement.center.x-(visibleRegion.origin.x+(visibleRegion.size.width/2.00)));
        CGFloat distanceFromCenterInRangeZeroToOne = (visibleRegion.size.width - distanceFromCenterInPoints)/visibleRegion.size.width;
        int zIndex = (int)(distanceFromCenterInRangeZeroToOne*500);
        
        if (zIndex >= bestZIndex) {
            centerObject = attributesForSingleElement;
            bestZIndex = zIndex;
            NSLog(@"new best!");
        }

        NSLog(@"checking float: %f", distanceFromCenterInPoints);
        NSLog(@"most centered zIndex: %i", bestZIndex);
        NSLog(@"zIndex: %i", zIndex);
    }
    
    //NSLog(@"*************mostCenteredDistanceFromCenterInRangeZeroToOne is: %f", mostCenteredDistanceFromCenterInRangeZeroToOne);
    
    NSLog(@"--------------------IndexPath:, %@", centerObject.indexPath);
    
    return centerObject.indexPath;
}

@end
