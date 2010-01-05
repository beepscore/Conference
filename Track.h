//
//  Track.h
//  Conference
//
//  Created by Steve Baker on 1/4/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Session;

@interface Track :  NSManagedObject {
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * trackAbstract;
@property (nonatomic, retain) NSSet* sessions;

@end


@interface Track (CoreDataGeneratedAccessors)
- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet *)value;
- (void)removeSessions:(NSSet *)value;

@end

