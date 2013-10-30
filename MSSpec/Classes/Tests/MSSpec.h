//
//  MSSpec.h
//  MSSpec
//
//  Created by Nacho Soto on 10/24/13.
//  Copyright (c) 2013 MindSnacks. All rights reserved.
//

#import <Kiwi/Kiwi.h>

@interface MSSpec : KWSpec

+ (void)prepareMocks:(NSArray *)mockedClasses;
+ (void)resetMocks;

@end

#define MSSPEC_BEGIN(name) \
    @interface name : MSSpec \
    \
    @end \
    \
    @implementation name \
    \
    + (NSString *)file { return @__FILE__; } \
    \
    + (void)buildExampleGroups { \
    \
    NSMutableArray *_classesToMock = [NSMutableArray array];\
    \
    describe(nil, ^{\
    \
        beforeAll(^{\
            [self prepareMocks:_classesToMock];\
        });\
        \
        afterAll(^{\
            [self resetMocks];\
        });\
        \
        context(nil, ^{\

#define MSSPEC_END \
        });\
        \
    });\
    \
    SPEC_END

#define MSMockClass(CLS) [_classesToMock addObject:[CLS class]]