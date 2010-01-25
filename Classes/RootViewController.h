//
//  RootViewController.h
//  Conference
//
//  Created by Steve Baker on 1/3/10.
//  Copyright Beepscore LLC 2010. All rights reserved.
//


@class TrackEditingViewController;
@class SessionsViewController;

@interface RootViewController : UITableViewController 
<NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
    TrackEditingViewController *_trackEditingVC;
    SessionsViewController *_sessionsVC;
    BOOL _firstInsert;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet TrackEditingViewController *trackEditingVC;
@property(nonatomic, retain) IBOutlet SessionsViewController *sessionsVC;

- (void)configureCell:(UITableViewCell *)cell 
            withTrack:(NSManagedObject *)model;

@end
