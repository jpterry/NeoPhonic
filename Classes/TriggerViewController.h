//
//  TriggerViewController.h
//  NeoPhonic
//
//  Created by John Terry on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundPickerViewController.h"

@interface TriggerViewController : UIViewController <SoundPickerViewControllerDelegate>{
	SoundPlayer *soundPlayer;
	UIButton *selectedTrigger;
	UILabel *tempoLabel;
	NSArray *triggers;
	NSMutableArray *soundKeys;
	BOOL editMode;
	
	// Loop Controls
	UISlider *tempoSlider;
	UISegmentedControl *loopLengthControl;
}
@property (nonatomic, retain) SoundPlayer *soundPlayer;
@property (nonatomic, retain) NSArray *triggers;
@property (nonatomic, retain) NSMutableArray *soundKeys;
@property (nonatomic, retain) UIButton *selectedTrigger;
@property (nonatomic, retain) IBOutlet UISlider *tempoSlider;
@property (nonatomic, retain) IBOutlet UILabel *tempoLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *loopLengthControl;
@property (assign) BOOL editMode;
-(IBAction)recordPressed:(id)sender;
-(IBAction)tapPressed:(id)sender;
-(IBAction)editPressed:(id)sender;


// Loop control
-(IBAction)tempoChanged:(id)sender;
-(IBAction)measureLengthChanged:(id)sender;

@end
