//
//  FriendSubclass.h
//  BookClub
//
//  Created by tim on 4/2/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "Friend.h"

@interface FriendSubclass : Friend

-(instancetype) initWithDictionary: (NSDictionary *) dictionary;
-(instancetype) initWithString: (NSString *) string;

+(void)retrieveListWithCompletion:(NSManagedObjectContext *) managedObjectContext  allList:(BOOL) allList completionHandler:(void (^)(NSArray *))complete;



@end
