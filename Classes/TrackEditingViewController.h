//
//  TrackEditingViewController.h
//  Conference
//
//  Created by Steve Baker on 1/25/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//


#import <UIKit/UIKit.h>

@class Track;

@interface TrackEditingViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
    UITextField *_nameField;
    UITextView *_abstractText;
    Track *_selectedTrack;
}

@property(nonatomic, retain) IBOutlet UITextField *nameField;
@property(nonatomic, retain) IBOutlet UITextView *abstractText;
@property(nonatomic, retain) Track *selectedTrack;

@end

