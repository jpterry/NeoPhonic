//
//  SoundPlayer.h
//  NeoPhonic
//
//  Created by John Terry on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/alc.h>
#import <OpenAL/al.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NeoSound.h"

@interface SoundPlayer : NSObject {
	ALCcontext* mContext;
	ALCdevice* mDevice;
	NSMutableArray *bufferStorageArray;
	NSMutableDictionary *soundDictionary;
}
@property (nonatomic, retain) NSMutableArray *bufferStorageArray;
@property (nonatomic, retain) NSMutableDictionary *soundDictionary;

-(void)initOpenAL;

-(void)playSound:(NSString*)soundKey;
-(AudioFileID)openAudioFile:(NSString*)filePath;
-(UInt32)audioFileSize:(AudioFileID)fileDescriptor;

-(NSString*)prepBufferWithSound:(NeoSound*)fileName AndGain:(float)gain AndPitch:(float)pitch;





@end
