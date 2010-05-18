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
@synthesize soundPlayer;


- (id)init{
	if (self = [super init]) {
		self.soundPlayer = [[SoundPlayer alloc] init];
		self.quarterNotes = 4; // 4/4 @ 120bp
		self.quarterNoteLength = [NSNumber numberWithFloat:.25];
		self.bpm = 120;
	}
	return self;
}

- (void)startRecording:(id)sender{
	// Not implemented
}

- (void)startRecordingWithPlaybackLoop:(id)sender{
	[self clearNoteArray];
	NSTimeInterval nextFire = ((double)self.quarterNotes * [self.quarterNoteLength doubleValue] * (((float)60 / self.bpm) / kSubBeatsPerMeasure));
	SEL timerFireMethod = @selector(timerFireMethod:);
	self.loopTimer = [NSTimer scheduledTimerWithTimeInterval:nextFire target:self selector:timerFireMethod userInfo:nil repeats:YES];	
}

- (void)reset:(id)sender{
	self.position = 0;
	[self clearNoteArray];
}

- (void)clearNoteArray{
	[self.noteArray release];
	NSUInteger numberOfSubBeats = kSubBeatsPerMeasure * self.quarterNotes;
	self.noteArray = [[NSMutableArray alloc] initWithCapacity:numberOfSubBeats];
	//populate with empty sets of notes
	for (int i = 0; i<=numberOfSubBeats; i++) {
		NSMutableSet *subBeatNotes = [[NSMutableSet alloc] init];
		[self.noteArray addObject:subBeatNotes];
		[subBeatNotes release];
	}	
	
}
- (void)play{
	
}

- (void)stop{
	[self.loopTimer invalidate];
}

- (void)tick{
	NSLog(@"Tick %d",self.position);
	if(self.position % (kSubBeatsPerMeasure * self.quarterNotes)==0) self.position = 0;
	self.position++;
	@try {
		[self playNotesAtSubBeat:self.position];
	}
	@catch (NSException * e) {
		// We're cool, just rest.
	}
	@finally {
		// Nothing to do here
	}
	
}

- (void)playNotesAtSubBeat:(NSUInteger)subBeat{
	NSMutableSet *notes = [self.noteArray objectAtIndex:subBeat];
	for (NSString *soundKey in notes){
		[self.soundPlayer playSound:soundKey];
	}
}

- (void)recordSoundAtCurrentSubBeat:(NSString*)note{
	NSLog(@"recording: %@",note);
	NSMutableSet *notes = [self.noteArray objectAtIndex:self.position];
	[notes addObject:note]; // a soundKey from player
}

#pragma mark timer
- (void)timerFireMethod:(NSTimer*)theTimer{
	[self tick];
}

@end
