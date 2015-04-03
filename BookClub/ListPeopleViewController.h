//
//  PeopleViewController.h
//  BookClub
//
//  Created by tim on 4/1/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListPeopleViewController : UIViewController

//App's ManagedObjectContext (RootVC will pass it to it)
@property NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSMutableArray *myFriendsArray;

@end
