//
//  SoundPlayer.m
//  NeoPhonic
//
//  Created by John Terry on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SoundPlayer.h"

@implementation SoundPlayer
@synthesize soundDictionary, bufferDictionary;

-(id)init{
	if (self = [super init]) {
		self.soundDictionary = [[NSMutableDictionary alloc] init];
		self.bufferDictionary = [[NSMutableDictionary alloc] init];
		[self initOpenAL];
	}
	return self;
}

-(void)dealloc{
	[self.soundDictionary release];
	[self.bufferDictionary release];
	[self cleanUpOpenAL:self];
	[super dealloc];
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
	if(!sound || !sound.fileName){
		NSLog(@"Sound doesn't have filename");
		return nil;
	}
	
	NSString *key = [NSString stringWithFormat:@"%@%g%g", sound.fileName, gain, pitch];
	NSLog(@"preparing sound: %@", key);
	
	NSUInteger bufferID;
	if ([self.bufferDictionary objectForKey:key]) {
		NSNumber *num = (NSNumber*)[bufferDictionary objectForKey:key];

		bufferID = [num unsignedIntValue];
	} else {
	
		AudioFileID fileID = [self openAudioFile:[sound fullPath]];
		
		UInt32 fileSize = [self audioFileSize:fileID];
		
		// Copy file into OpenAL buffer

		unsigned char * outData = malloc(fileSize);

		// this where we actually get the bytes from the file and put them
		// into the data buffer
		OSStatus result = noErr;
		result = AudioFileReadBytes(fileID, false, 0, &fileSize, outData);
		AudioFileClose(fileID); //close the file
		
		if (result != 0) NSLog(@"cannot load effect: %@", sound.fileName);
		
		// grab a buffer ID from openAL
		alGenBuffers(1, &bufferID);
		
		// jam the audio data into the new buffer
		alBufferData(bufferID, AL_FORMAT_STEREO16, outData, fileSize, 44100); 
		
		// save the buffer so I can release it later
		// TODO: set up this array so it works, we're leaking for now.

		[self.bufferDictionary setObject:[NSNumber numberWithUnsignedInteger:bufferID] forKey:key];
		
		// clean up the intermediate buffer 
		if (outData) {
			free(outData);
			outData = NULL;
		}
	}
	
	// BUFFERS READY
	// NOW HOOK TO SOURCE
	NSUInteger sourceID;
	if ([self.soundDictionary objectForKey:key]) {
		
		sourceID = [[self.soundDictionary objectForKey:key] unsignedIntValue];
		
	} else {
		
	
	// grab a source ID from openAL
	alGenSources(1, &sourceID); 
	
	// attach the buffer to the source
	alSourcei(sourceID, AL_BUFFER, bufferID);
		
		// store this for future use
		[self.soundDictionary setObject:[NSNumber numberWithUnsignedInt:sourceID] forKey:key];	

	}
	
	// set some basic source prefs
		
	// normalize Pitch valid between .5 and 2.0
	float aPitch = pitch;
	alSourcef(sourceID, AL_PITCH, aPitch);
	
	// 
	float aGain = gain;
	alSourcef(sourceID, AL_GAIN, aGain);
	
	BOOL loops = false;
	if (loops) alSourcei(sourceID, AL_LOOPING, AL_TRUE);
	
	return key;
}

-(void)playSound:(NSString*)soundKey{
	NSNumber* numVal = [self.soundDictionary objectForKey:soundKey];
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
	for (NSNumber * bufferNumber in [self.soundDictionary allValues]) {
		NSUInteger bufferID = [bufferNumber unsignedIntegerValue];
		alDeleteBuffers(1, &bufferID);
	}
	[self.bufferDictionary removeAllObjects];
	
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
	
    OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, kAudioFileReadPermission, 0, &outAFID);    

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
