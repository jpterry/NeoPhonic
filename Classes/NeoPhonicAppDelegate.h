//
//  NeoPhonicAppDelegate.h
//  NeoPhonic
//
//  Created by John Terry on 5/3/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TriggerViewController.h"

@interface NeoPhonicAppDelegate : NSObject <UIApplicationDelegate> {

	// Views
	TriggerViewController *triggerViewController;
	
	// Core Data
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
}

- (NSString *)applicationDocumentsDirectory;
- (NSString *)soundsDirectory;

- (void)installSounds;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TriggerViewController *triggerViewController;

// For Models to manage themselves acts as context manager
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

@end

