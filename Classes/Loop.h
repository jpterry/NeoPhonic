//
//  Loop.h
//  NeoPhonic
//
//  Created by John Terry on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol LoopDelegate;

@interface Loop : NSObject {
	NSUInteger quarterNotes, bpm;
	NSNumber *quarterNoteLength;
	NSTimer *loopTimer;
	NSMutableArray *noteArray;
	NSUInteger position;
}

@property (assign) NSUInteger quarterNotes, bpm;
@property (nonatomic, retain) NSNumber *quarterNoteLength;
@property (nonatomic, retain) NSTimer *loopTimer;
@property (nonatomic, retain) NSMutableArray *noteArray;
@property (assign) NSUInteger position;

- (void)startRecordingWithPlaybackLoop:(id)sender;

- (void)startRecording:(id)sender;
- (void)tap:(id)sender;

- (void)play;

- (void)timerFireMethod:(NSTimer*)theTimer;

@end

@protocol LoopDelegate
@optional
-(void)measureTicked:(id)measure;
-(void)measure:(id)beatTicked:(NSUInteger)beat;

@end