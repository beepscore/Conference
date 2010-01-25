//
//  SessionEditingViewController.h
//  Conference
//
//  Created by Steve Baker on 1/25/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//
//  Created by Bill Dudney on 5/12/09.
//  Copyright 2009 Gala Factory Software LLC. All rights reserved.
//
//
//  Licensed with the Apache 2.0 License
//  http://apache.org/licenses/LICENSE-2.0
//

#import <UIKit/UIKit.h>

@class Session;

@interface SessionEditingViewController : UIViewController {
    Session *_selectedSession;
    UITextField *_nameField;
    UITextView *_sessionAbstractText;
}

@property(nonatomic, retain) Session *selectedSession;
@property(nonatomic, retain) IBOutlet UITextField *nameField;
@property(nonatomic, retain) IBOutlet UITextView *sessionAbstractText;

@end
