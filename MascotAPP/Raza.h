//
//  Raza.h
//  mascotapp
//
//  Created by Samuel Mascarell on 27/11/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Animal;

@interface Raza : NSManagedObject

@property (nonatomic, retain) NSString * img;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) Animal *perteneceAnimal;

@end
