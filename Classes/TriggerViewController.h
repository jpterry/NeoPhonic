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
	NSArray *triggers;
	SoundPlayer *soundPlayer;
}
@property(nonatomic, retain) NSArray *triggers;
@property(nonatomic, retain) SoundPlayer *soundPlayer;
-(IBAction)recordPressed:(id)sender;
-(IBAction)tapPressed:(id)sender;
-(IBAction)editPressed:(id)sender;

@end
