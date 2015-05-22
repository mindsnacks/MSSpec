//
//  MSSpec.m
//  MSSpec
//
//  Created by Nacho Soto on 10/24/13.
//  Copyright (c) 2013 MindSnacks. All rights reserved.
//

#import "MSSpec.h"

#import "JSObjection+MSAddModule.h"

static NSMutableArray *_addedModules;

@interface _MSInjectionModule : JSObjectionModule

@end

@implementation _MSInjectionModule {
    NSArray *_mockedClasses;
    NSArray *_classesToReturnNil;
    NSArray *_nullMockClasses;
    NSArray *_mockedProtocols;
    NSArray *_nullMockProtocols;
    NSDictionary *_mockedObjects;
    
    // this contains mocks for both classes and protocols
    // which might produce colisions.
    NSMutableDictionary *_mocks;
}

- (id)init {
    return [self initWithMockedClasses:nil classesToReturnNil:nil nullMockClasses:nil protocols:nil nullMockProtocols:nil objects:nil];
}

- (id)initWithMockedClasses:(NSArray *)mockedClasses
         classesToReturnNil:(NSArray *)classesToReturnNil
            nullMockClasses:(NSArray *)nullMockClasses
                  protocols:(NSArray *)mockedProtocols
          nullMockProtocols:(NSArray *)nullMockProtocols
                    objects:(NSDictionary *)objects {
    NSParameterAssert(mockedClasses);
    NSParameterAssert(classesToReturnNil);
    NSParameterAssert(nullMockClasses);
    NSParameterAssert(mockedProtocols);
    NSParameterAssert(nullMockProtocols);
    NSParameterAssert(objects);
    
    if ((self = [super init])) {
        _mockedClasses = mockedClasses.copy;
        _classesToReturnNil = classesToReturnNil.copy;
        _nullMockClasses = nullMockClasses.copy;
        _mockedProtocols = mockedProtocols.copy;
        _nullMockProtocols = nullMockProtocols.copy;
        _mockedObjects = objects.copy;
        
        _mocks = NSMutableDictionary.new;
    }
    
    return self;
}

- (void)configure {
    [super configure];
    
    for (Class cls in _mockedClasses) {
        [self bindBlock:^id(__unused JSObjectionInjector *context) {
            NSString *const key = NSStringFromClass(cls);
            
            if (_mocks[key] == nil) {
                _mocks[key] = [cls mock];
            }
            
            return _mocks[key];
        } toClass:cls];
    }
    
    for (Class cls in _classesToReturnNil) {
        [self bindBlock:^id(__unused JSObjectionInjector *context) {
            return nil;
        } toClass:cls];
    }
    
    for (Class cls in _nullMockClasses) {
        [self bindBlock:^id(__unused JSObjectionInjector *context) {
            NSString *const key = NSStringFromClass(cls);
            
            if (_mocks[key] == nil) {
                _mocks[key] = [cls nullMock];
            }
            
            return _mocks[key];
        } toClass:cls];
    }
    
    for (Protocol *protocol in _mockedProtocols) {
        [self bindBlock:^id(__unused JSObjectionInjector *context) {
            NSString *const key = NSStringFromProtocol(protocol);
            
            if (_mocks[key] == nil) {
                _mocks[key] = [KWMock mockForProtocol:protocol];
            }
            
            return _mocks[key];
        } toProtocol:protocol];
    }
    
    for (Protocol *protocol in _nullMockProtocols) {
        [self bindBlock:^id(JSObjectionInjector *context) {
            NSString *const key = NSStringFromProtocol(protocol);
            
            if (_mocks[key] == nil) {
                _mocks[key] = [KWMock nullMockForProtocol:protocol];
            }
            
            return _mocks[key];
        } toProtocol:protocol];
    }
    
    [_mockedObjects enumerateKeysAndObjectsUsingBlock:^(Class class,
                                                        id obj,
                                                        BOOL *stop) {
        [self bind:obj toClass:class];
    }];
}

@end

@implementation MSSpec

static JSObjectionInjector *_lastUsedInjector;

+ (void)prepareMocksForClasses:(NSArray *)mockedClasses
            classesToReturnNil:(NSArray *)classesToReturnNil
               nullMockClasses:(NSArray *)nullMockClasses
                     protocols:(NSArray *)mockedProtocols
             nullMockProtocols:(NSArray *)nullMockProtocols
                       objects:(NSDictionary *)objects {
    NSAssert(_lastUsedInjector == nil, @"Mocks weren't reset before calling this method again.");
    
    _lastUsedInjector = JSObjection.defaultInjector;
    
    [JSObjection ms_addModule:[[_MSInjectionModule alloc] initWithMockedClasses:mockedClasses
                                                             classesToReturnNil:classesToReturnNil
                                                                nullMockClasses:nullMockClasses
                                                                      protocols:mockedProtocols
                                                              nullMockProtocols:nullMockProtocols
                                                                        objects:objects]];
}

+ (void)resetMocks {
    [JSObjection setDefaultInjector:_lastUsedInjector];
    
    _lastUsedInjector = nil;
}

@end
