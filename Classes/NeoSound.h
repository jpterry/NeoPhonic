//
//  Sound.h
//  NeoPhonic
//
//  Created by John Terry on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
//#import "SoundPlayer.h"

@interface NeoSound :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * fileName;


- (NSString*)fullPath;

@end



