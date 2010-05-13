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
	NSString *key;
//	SoundPlayer *soundPlayer;
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSString * key;
//@property (nonatomic, retain) SoundPlayer *soundPlayer;

- (id)initWithDefaults;
+ (NSArray*)soundsAll;


// Playback
/*
- (NSNumber*)loadSoundWithGain:(float)gain AndPitch:(float)pitch;

- (void)play;
- (void)stop;
*/



// Maybe move this elsewhere?
+ (void)installSounds;


@end



