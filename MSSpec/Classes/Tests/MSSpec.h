//
//  MSSpec.h
//  MSSpec
//
//  Created by Nacho Soto on 10/24/13.
//  Copyright (c) 2013 MindSnacks. All rights reserved.
//

#import <Kiwi/Kiwi.h>

@interface MSSpec : KWSpec

+ (void)prepareMocksForClasses:(NSArray *)mockedClasses
                     protocols:(NSArray *)mockedProtocols;
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
        NSMutableArray *_protocolsToMock = [NSMutableArray array];\
    \
    describe(nil, ^{\
    \
        beforeAll(^{\
            [self prepareMocksForClasses:_classesToMock protocols:_protocolsToMock];\
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
#define MSMockProtocol(PROTOCOL) [_protocolsToMock addObject:@protocol(PROTOCOL)]