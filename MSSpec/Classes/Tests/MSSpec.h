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
            classesToReturnNil:(NSArray *)classesToReturnNil
               nullMockClasses:(NSArray *)nullMockClasses
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
        NSMutableArray *_classesToMock      = [NSMutableArray array];\
        NSMutableArray *_classesToReturnNil = [NSMutableArray array];\
        NSMutableArray *_classesToNullMock  = [NSMutableArray array];\
        NSMutableArray *_protocolsToMock    = [NSMutableArray array];\
    \
    describe(nil, ^{\
    \
        beforeAll(^{\
            [self prepareMocksForClasses:_classesToMock classesToReturnNil:_classesToReturnNil nullMockClasses:_classesToNullMock protocols:_protocolsToMock];\
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

// injects a mock for `CLS`.
#define MSMockClass(CLS) [_classesToMock addObject:[CLS class]]
// injects `nil` for `CLS`.
#define MSNilClass(CLS) [_classesToReturnNil addObject:[CLS class]]
// injects a null mock for `CLS`.
#define MSNullMockClass(CLS) [_classesToNullMock addObject:[CLS class]]
// injects a mock for `PROTOCOL`.
#define MSMockProtocol(PROTOCOL) [_protocolsToMock addObject:@protocol(PROTOCOL)]