//
//  Image.h
//  Task
//
//  Created by Niu Changming on 21/8/15.
//  Copyright (c) 2015 Ekoo Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Image : NSObject

@property int entityId;

-(id) initWithJson:(NSDictionary*) dic;

@end
