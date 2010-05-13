//
//  SoundPlayer.m
//  NeoPhonic
//
//  Created by John Terry on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SoundPlayer.h"


@implementation SoundPlayer
@synthesize soundDictionary, bufferStorageArray;

-(id)init{
	if (self = [super init]) {
		self.soundDictionary = [[NSMutableDictionary alloc] init];
		self.bufferStorageArray = [[NSMutableArray alloc] init];
		[self initOpenAL];
	}
	return self;
}

-(void)initOpenAL{
	mDevice = alcOpenDevice(NULL);
	if (mDevice) {
		// use the device to make a context
		mContext = alcCreateContext(mDevice,NULL);
		// set the context to currently active
		alcMakeContextCurrent(mContext);
	}
}

// returns sound key
-(NSString*)prepBufferWithSound:(NeoSound*)sound AndGain:(float)gain AndPitch:(float)pitch{
	NSString *key = @"snare";
	
	AudioFileID fileID = [self openAudioFile:sound.fileName];
	
	UInt32 fileSize = [self audioFileSize:fileID];
	
	// Copy file into OpenAL buffer
	unsigned char * outData = malloc(fileSize);
	
	// this where we actually get the bytes from the file and put them
	// into the data buffer
	OSStatus result = noErr;
	result = AudioFileReadBytes(fileID, false, 0, &fileSize, outData);
	AudioFileClose(fileID); //close the file
	
	if (result != 0) NSLog(@"cannot load effect: %@",sound.fileName);
	
	NSUInteger bufferID;
	// grab a buffer ID from openAL
	alGenBuffers(1, &bufferID);
	
	// jam the audio data into the new buffer
	alBufferData(bufferID,AL_FORMAT_STEREO16,outData,fileSize,44100); 
	
	// save the buffer so I can release it later
	// TODO: set up this array so it works, we're leaking for now.
	[self.bufferStorageArray addObject:[NSNumber numberWithUnsignedInteger:bufferID]];
	
	// BUFFERS READY
	// NOW HOOK TO SOURCE
	NSUInteger sourceID;
	
	// grab a source ID from openAL
	alGenSources(1, &sourceID); 
	
	// attach the buffer to the source
	alSourcei(sourceID, AL_BUFFER, bufferID);
	// set some basic source prefs
	
	// normalize Pitch valid between .5 and 2.0
	float aPitch = pitch;
	alSourcef(sourceID, AL_PITCH, aPitch);
	
	// 
	float aGain = gain;
	alSourcef(sourceID, AL_GAIN, aGain);
	
	BOOL loops = false;
	if (loops) alSourcei(sourceID, AL_LOOPING, AL_TRUE);
	
	// store this for future use
	[self.soundDictionary setObject:[NSNumber numberWithUnsignedInt:sourceID] forKey:key];	
	
	// clean up the buffer
	if (outData)
	{
		free(outData);
		outData = NULL;
	}
	return key;
}


-(void)playSound:(NSString*)soundKey{
	NSNumber* numVal = [self.soundDictionary objectForKey:@"snare"];
	if (numVal == nil) return;
	NSUInteger sourceID = [numVal unsignedIntValue];
	alSourcePlay(sourceID);
}

-(void)stopSound:(NSString*)soundKey{
	NSNumber * numVal = [self.soundDictionary objectForKey:soundKey];
	if (numVal == nil) return;
	NSUInteger sourceID = [numVal unsignedIntValue];
	alSourceStop(sourceID);
}

-(void)cleanUpOpenAL:(id)sender
{
	// delete the sources
	for (NSNumber * sourceNumber in [self.soundDictionary allValues]) {
		NSUInteger sourceID = [sourceNumber unsignedIntegerValue];
		alDeleteSources(1, &sourceID);
	}
	[self.soundDictionary removeAllObjects];
	
	// delete the buffers
	for (NSNumber * bufferNumber in self.bufferStorageArray) {
		NSUInteger bufferID = [bufferNumber unsignedIntegerValue];
		alDeleteBuffers(1, &bufferID);
	}
	[self.bufferStorageArray removeAllObjects];
	
	// destroy the context
	alcDestroyContext(mContext);
	// close the device
	alcCloseDevice(mDevice);
}


#pragma mark -
#pragma mark Audio File Helpers

-(AudioFileID)openAudioFile:(NSString*)filePath{
	AudioFileID outAFID;
	NSURL *afUrl = [NSURL fileURLWithPath:filePath];
#if TARGET_OS_IPHONE
	OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, kAudioFileReadPermission, 0, &outAFID);
#else // TODO: This doesn't work, but maybe someday might
	OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, kAudioFileReadPermission, 0, &outAFID);
#endif
	if (result != 0) NSLog(@"cannot openf file: %@",filePath);
	return outAFID;
}

-(UInt32)audioFileSize:(AudioFileID)fileDescriptor{
	UInt64 outDataSize = 0;
	UInt32 thePropSize = sizeof(UInt64);
	OSStatus result = AudioFileGetProperty(fileDescriptor, kAudioFilePropertyAudioDataByteCount, &thePropSize, &outDataSize);
	if(result != 0) NSLog(@"cannot find file size");
	return (UInt32)outDataSize;
}

@end
