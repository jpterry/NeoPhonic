//
//  EditTapsViewController.h
//  NeoPhonic
//
//  Created by John Terry on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundPlayer.h"
#import "SoundPickerViewController.h"
@protocol EditTapsViewControllerDelegate;

@interface EditTapsViewController : UIViewController <SoundPickerViewControllerDelegate> {
	id<EditTapsViewControllerDelegate> delegate;
	UILabel *bpmLabel;
	NSUInteger selectedTag;
	NSArray *triggers;
}
@property (nonatomic, retain) id<EditTapsViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *bpmLabel;
@property (nonatomic, retain) NSArray *triggers;
@property (assign) NSUInteger selectedTag;

-(IBAction)donePressed:(id)sender;
-(IBAction)tapPressed:(id)sender;

-(IBAction)sliderChanged:(id)sender;
-(IBAction)measureLengthChanged:(id)sender;


@end

@protocol EditTapsViewControllerDelegate<SoundPickerViewControllerDelegate>

-(NSMutableArray*)soundKeys;
-(NSArray*)triggers;
-(SoundPlayer*)soundPlayer;

-(void)editTapsViewControllerDidFinish:(EditTapsViewController*)controller;

@end
