//
//  Image.h
//  QFirst
//
//  Created by ChangmingNiu on 19/6/16.
//  Copyright © 2016 EKOO LAB PTE. LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Image : NSObject

@property int entityId;

-(id) initWithJson:(NSDictionary*) dic;

@end
