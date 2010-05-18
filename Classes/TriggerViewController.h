//
//  TriggerViewController.h
//  NeoPhonic
//
//  Created by John Terry on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundPickerViewController.h"
#import "EditTapsViewController.h"
#import "Loop.h"

@interface TriggerViewController : UIViewController <EditTapsViewControllerDelegate>{
	SoundPlayer *soundPlayer;
	UIButton *selectedTrigger;
	UILabel *tempoLabel;
	NSArray *triggers;
	NSMutableArray *soundKeys;
	NSMutableDictionary *triggerMap;
	BOOL editMode, recording;
	
	// Loop Controls
	Loop *currentLoop, *loop1, *loop2, *loop3, *loop4;
	UISlider *tempoSlider;
	UISegmentedControl *loopLengthControl;
	UIButton *loopButton1, *loopButton2, *loopButton3, *loopButton4;
}
@property (nonatomic, retain) SoundPlayer *soundPlayer;
@property (nonatomic, retain) NSArray *triggers;
@property (nonatomic, retain) NSMutableArray *soundKeys;
@property (nonatomic, retain) NSMutableDictionary *triggerMap;
@property (nonatomic, retain) UIButton *selectedTrigger;
@property (nonatomic, retain) Loop *currentLoop, *loop1, *loop2, *loop3, *loop4;
@property (nonatomic, retain) IBOutlet UISlider *tempoSlider;
@property (nonatomic, retain) IBOutlet UILabel *tempoLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *loopLengthControl;
@property (nonatomic, retain) IBOutlet UIButton *loopButton1, *loopButton2, *loopButton3, *loopButton4;
@property (assign) BOOL editMode, recording;
-(IBAction)recordPressed:(id)sender;
-(IBAction)tapPressed:(id)sender;
-(IBAction)editPressed:(id)sender;


@end
