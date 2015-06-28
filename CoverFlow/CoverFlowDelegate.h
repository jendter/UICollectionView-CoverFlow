//
//  CoverFlowDelegate.h
//  CoverFlow
//
//  Created by Josh Endter on 6/28/15.
//  Copyright (c) 2015 Josh Endter. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CoverFlowDelegate <NSObject>

-(void)cellIsCenteredAtIndexPath:(NSIndexPath *)indexPath;

@end
