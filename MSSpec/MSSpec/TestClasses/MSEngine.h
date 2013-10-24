//
//  MSEngine.h
//  MSSpec
//
//  Created by Nacho Soto on 10/22/13.
//  Copyright (c) 2013 MindSnacks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSEngine : NSObject

- (instancetype)initWithName:(NSString *)name power:(CGFloat)power;

- (NSString *)name;
- (CGFloat)power;

@end
