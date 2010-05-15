//
//  Loop.m
//  NeoPhonic
//
//  Created by John Terry on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Loop.h"

#define kSubBeatsPerMeasure 16

// A single measure
@implementation Loop
@synthesize quarterNotes, bpm;
@synthesize quarterNoteLength;
@synthesize loopTimer;
@synthesize noteArray;
@synthesize position;


- (id)init{
	if (self = [super init]) {
//		NSUInteger beats = 4;
		self.quarterNotes = 4; // 4/4 @ 120bp
		self.quarterNoteLength = [NSNumber numberWithDouble:((float)1/(float)4)];
		self.bpm = 120;
		self.noteArray = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)startRecordingWithPlaybackLoop:(id)sender{	
	self.position = 0;
	NSUInteger arraySize = kSubBeatsPerMeasure * self.quarterNotes;
	NSTimeInterval nextFire = ((double)self.quarterNotes * [self.quarterNoteLength doubleValue] * ((float)60 / self.bpm) / kSubBeatsPerMeasure);

	SEL timerFireMethod = @selector(timerFireMethod:);
	self.loopTimer = [NSTimer scheduledTimerWithTimeInterval:nextFire target:self selector:timerFireMethod userInfo:nil repeats:YES];
}

- (void)startRecording:(id)sender{
	
}
- (void)play{
	
}

- (void)tick{
	self.position++;
	if (self.position % (self.quarterNotes * kSubBeatsPerMeasure) == 1) self.position = 0;
	id note;
	note = [self.noteArray objectAtIndex:self.position];
	
	
	if (note) {
		NSLog(@"Play a note");
	}else {
		NSLog(@"be slient");
	}

	
	
/*	currentPos++;
	NSSet 
	 = [self.noteArray objectAtIndex:currentPos];
	[self playNotesAtSubBeat:
*/
}

- (void)playNotesAtSubBeat:(NSUInteger)subBeat{
	
}

#pragma mark timer
- (void)timerFireMethod:(NSTimer*)theTimer{
	[self tick];
}

@end
