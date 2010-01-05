//
//  Session.h
//  Conference
//
//  Created by Steve Baker on 1/4/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Track;

@interface Session :  NSManagedObject {
}

@property (nonatomic, retain) NSString * sessionID;
@property (nonatomic, retain) NSString * sessionAbstract;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Track * track;

@end



