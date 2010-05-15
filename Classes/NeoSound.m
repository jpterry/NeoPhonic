// 
//  Sound.m
//  NeoPhonic
//
//  Created by John Terry on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NeoSound.h"

#import "NeoPhonicAppDelegate.h"

@implementation NeoSound 

@dynamic name;
@dynamic category;
@dynamic fileName;


- (NSString*)fullPath{
	NeoPhonicAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	return [[[appDelegate soundsDirectory] stringByAppendingPathComponent:self.category] stringByAppendingPathComponent:self.fileName];	
}

#pragma mark -
#pragma mark Life cycle

- (void) awakeFromInsert{
	
}

- (void)dealloc{
	[super dealloc];
}

#pragma mark static

+ (void)initialize{
	// set up queries
}

//+ (NSArray*)soundsAll{
//	NeoPhonicAppDelegate *myAppDelegate = [[UIApplication sharedApplication] delegate];
//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//	[fetchRequest setEntity:[NSEntityDescription entityForName:@"NeoSound" inManagedObjectContext:myAppDelegate.managedObjectContext]];
//	NSError *error = nil;
//	return [myAppDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//}

+ (void)installSounds{
	
}

@end
