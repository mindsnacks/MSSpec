MSSpec
======

## What is it?
MSSpec is a Kiwi Spec with support to inject mocks using Objection.
Using mocks in your specs is now as easy as this:
```objc
MSSPEC_BEGIN(MSCarSpec)

MSMockClass(MSEngine);

__block MSCar *car;
__block MSEngine *engine;

beforeEach(^{
	// this instance will be created using the default injector
	car = MSInjectionCreateObject(MSCar);
	
	// this will be the same mock injected to car
	engine = MSInjectionCreateObject(MSEngine);
});

it(@"has a configured engine", ^{
	NSString *name = @"name";
	[engine stub:@selector(name) andReturn:name];

	[[car.engine.name should] equal:name];
});

MSSPEC_END
```

## Using Objection is much easier
[```<MSSpec/MSInjection.h>```](https://github.com/mindsnacks/MSSpec/blob/master/MSSpec/Classes/App/MSInjection.h) also includes a series of macros to make working with ```Objection``` much easier:

- ```MSInjectionRequireProperties```: defines a list of properties to be injected into the class.
Example:
```MSInjectionRequireProperties(car, engine)```
- ```MSInjectionDesignatedInitializer```: defines the designated initializer for the class (default is ```init```).
- ```MSInjectionCreateObject```: instantiates an object of the specified class and injects it all its dependencies. This object is initialized with ```init:``` unless ```MSInjectionDesignatedInitializer``` has been used.
- ```MSInjectionInjectDependencies```: if the object has declared its dependencies using ```MSInjectionRequireProperties```, but was allocated outside of the injector's life cycle, use this to immediately inject dependencies.

Dependencies can then be injected in one of two ways:
- Instantiate the object using ```MSInjectionCreateObject(ClassName)```.
- Calling ```MSInjectionInjectDependencies()``` somewhere in the initialization.

## Installation:
Using CocoaPods:
```ruby
target :App do
	pod 'MSSpec' # this gives you access to the MSInjection.h macros in your app.

	target :Tests do
		pod 'MSSpec/Tests' # MSSPEC macros for your tests.
	end
end
```
You don't need to add Objection or Kiwi.

Then simply ```#import <MSSpec/MSInjection.h>``` in your main target's pch file, and ```#import <MSSpec/MSSpec.h>``` to your test's target pch file.

