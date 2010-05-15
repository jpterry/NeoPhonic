//
//  SoundPickerViewController.h
//  NeoPhonic
//
//  Created by John Terry on 5/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundPlayer.h"
#import "NeoSound.h"

@protocol SoundPickerViewControllerDelegate;

#pragma mark -
#pragma mark class interface
@interface SoundPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	id<SoundPickerViewControllerDelegate> delegate;
	SoundPlayer *player;
	NeoSound *selectedSound;
	UILabel *soundLabel;
	UIPickerView *soundPickerView;
	UISlider *gainSlider, *pitchSlider;
	NSArray *categories, *instruments;

}
@property (assign) id<SoundPickerViewControllerDelegate> delegate;
@property (nonatomic, retain) SoundPlayer *player;
@property (nonatomic, retain) NeoSound *selectedSound;
@property (nonatomic, retain) IBOutlet UILabel *soundLabel;
@property (nonatomic, retain) IBOutlet UIPickerView *soundPickerView;
@property (nonatomic, retain) IBOutlet UISlider *gainSlider, *pitchSlider;
@property (nonatomic, retain) NSArray *categories, *instruments;

- (IBAction)playPressed:(id)sender;
- (IBAction)savePressed:(id)sender;

@end

#pragma mark -
#pragma mark delegate protocol
@protocol SoundPickerViewControllerDelegate<NSObject>
-(void)soundPickerController:(SoundPickerViewController*)controller 
			  DidChooseSound:(NeoSound*)sound 
					WithGain:(float)gain 
					AndPitch:(float)pitch;
@end


