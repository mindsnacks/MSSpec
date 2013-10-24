//
//  MSCar.h
//  MSSpec
//
//  Created by Nacho Soto on 10/22/13.
//  Copyright (c) 2013 MindSnacks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSEngine, MSBrakes;

@interface MSCar : NSObject

@property (nonatomic, strong) MSEngine *engine;
@property (nonatomic, strong) MSBrakes *brakes;

@end
