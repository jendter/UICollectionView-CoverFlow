//
//  Photo.h
//  InstaKilo
//
//  Created by Josh Endter on 6/25/15.
//  Copyright (c) 2015 Josh Endter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *location;

@end
