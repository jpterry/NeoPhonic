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
@synthesize key;

#pragma mark -
#pragma mark Life cycle

- (void) awakeFromInsert{
	//self.soundPlayer = [[SoundPlayer alloc] init];
}

- (void)dealloc{
	//[self.soundPlayer release];
	[super dealloc];
}

#pragma mark -
#pragma mark Playback
/*
- (NSNumber*)loadSoundWithGain:(float)gain AndPitch:(float)pitch{
	self.fileName = [[NSBundle mainBundle] pathForResource:@"Snare" ofType:@"caf"];
	[self.soundPlayer prepBufferWithFileName:self.fileName AndGain:gain AndPitch:pitch];
	return 0;
}

- (void)play{
	self.key = @"snare";
	[self.soundPlayer playSound:self.key];
}

- (void)stop{
	
}
*/
#pragma mark -
#pragma mark poor mans ORM

- (id)initWithDefaults{
	NeoPhonicAppDelegate *myAppDelegate = [[UIApplication sharedApplication] delegate];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"NeoSound" inManagedObjectContext:myAppDelegate.managedObjectContext];
	return [self initWithEntity:entity insertIntoManagedObjectContext:myAppDelegate.managedObjectContext];
}


#pragma mark static

+ (void)initialize{
	// set up queries
}

+ (NSArray*)soundsAll{
	NeoPhonicAppDelegate *myAppDelegate = [[UIApplication sharedApplication] delegate];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:@"NeoSound" inManagedObjectContext:myAppDelegate.managedObjectContext]];
	NSError *error = nil;
	return [myAppDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

+ (void)installSounds{
	
}

@end
