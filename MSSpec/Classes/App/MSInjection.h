//
//  MSInjection.h
//  MSSpec
//
//  Created by Nacho Soto on 10/24/13.
//  Copyright (c) 2013 MindSnacks. All rights reserved.
//

#import <Objection/Objection.h>
#import <libextobjc/metamacros.h>

/**
                        MSInjection
 -------------------------------------------------------
 
 Dependencies are declared in a class by using the macro
 `MSInjectionRequireProperties` in the `@implementation`.
 
 Example: MSInjectionRequireProperties(engine, lights)
 
 Dependencies can then be injected in one of two ways:
    - Instantiate the object using `MSInjectionCreateObject(ClassName)`.
    - Calling `MSInjectionInjectDependencies()` somewhere in the initialization.
 */

/**
 * Defines a list of properties to be injected into the class.
 * @example MSInjectionRequireProperties(engine, brakes)
 */
#define MSInjectionRequireProperties(...) \
    objection_requires(metamacro_foreach(_MSInjectionSelectorString,, __VA_ARGS__) nil)

/**
 * Defines the designated initializer for the class (default is init).
 */
#define MSInjectionDesignatedInitializer(SEL) objection_initializer(SEL)

/**
 * Instantiates an object of type `CLS` and injects it all its dependencies.
 * This object is initialized with `init:` unless `MSInjectionDesignatedInitializer` has been used.
 * @param CLS: class name to instantiate.
 * @see `MSInjectionInjectDependencies` if an object has been created without this initializer.
 */
#define MSInjectionCreateObject(CLS) [JSObjection defaultInjector][[CLS class]]

#define MSInjectionCreateObjectWithArgs(CLS, ...) [[JSObjection defaultInjector] getObjectWithArgs:[CLS class], __VA_ARGS__, nil]

/**
 * If the object has declared its dependencies using `MSInjectionRequireProperties`, but was allocated
 * outside of the injector's life cycle, use this to immediately inject dependencies.
 */
#define MSInjectionInjectDependencies() MSInjectionInjectDependenciesToObject(self)
#define MSInjectionInjectDependenciesToObject(OBJ) [[JSObjection defaultInjector] injectDependencies:(OBJ)]

// -- private helper macros --

#define _MSInjectionSelectorString(INDEX, STR) NSStringFromSelector(@selector(STR)),