//
//  AddBookViewController.h
//  BookClub
//
//  Created by tim on 4/1/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FriendSubclass.h"
#import "Book.h"

@interface AddBookViewController : UIViewController
@property NSManagedObjectContext *managedObjectContext;
@property FriendSubclass *friend;


@end
