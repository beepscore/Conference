//
//  SessionsViewController.h
//  Conference
//
//  Created by Steve Baker on 1/25/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//
//  Created by Bill Dudney on 5/11/09.
//  Copyright 2009 Gala Factory Software LLC. All rights reserved.
//
//
//  Licensed with the Apache 2.0 License
//  http://apache.org/licenses/LICENSE-2.0
//

#import <UIKit/UIKit.h>

@class Track;
@class SessionEditingViewController;

@interface SessionsViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    Track *_selectedTrack;
    NSIndexPath *_selectedIndexPath;
    SessionEditingViewController *_sessionEditingVC;
	NSFetchedResultsController *_fetchedResultsController;
    BOOL _firstInsert;
}

@property (nonatomic, retain) Track *selectedTrack;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, retain) IBOutlet SessionEditingViewController *sessionEditingVC;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell
          withSession:(NSManagedObject *)model;

@end
