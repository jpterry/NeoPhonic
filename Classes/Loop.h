//
//  Loop.h
//  NeoPhonic
//
//  Created by John Terry on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Note:
// This implementation is in Objective-C and therefore relies on message passing.
// This is slow and imperfect and all-in-all not really very good. But it works.
// TODO: Make this using function calls instead (C/C++)

#import <UIKit/UIKit.h>
#import "SoundPlayer.h"


@interface Loop : NSObject {
	NSUInteger quarterNotes, bpm;
	NSNumber *quarterNoteLength;
	NSTimer *loopTimer;
	NSMutableArray *noteArray;
	NSUInteger position;
	SoundPlayer *soundPlayer;
}

@property (assign) NSUInteger quarterNotes, bpm;
@property (nonatomic, retain) NSNumber *quarterNoteLength;
@property (nonatomic, retain) NSTimer *loopTimer;
@property (nonatomic, retain) NSMutableArray *noteArray;
@property (assign) NSUInteger position;
@property (nonatomic, retain) SoundPlayer *soundPlayer;

- (void)startRecording:(id)sender;
- (void)startRecordingWithPlaybackLoop:(id)sender;
- (void)clearNoteArray;

- (void)play;
- (void)stop;

- (void)playNotesAtSubBeat:(NSUInteger)subBeat;
- (void)recordSoundAtCurrentSubBeat:(NSString*)key;

- (void)timerFireMethod:(NSTimer*)theTimer;

@end