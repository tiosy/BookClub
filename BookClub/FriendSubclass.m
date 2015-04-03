//
//  FriendSubclass.m
//  BookClub
//
//  Created by tim on 4/2/15.
//  Copyright (c) 2015 Timothy Yeh. All rights reserved.
//

#import "FriendSubclass.h"

@implementation FriendSubclass



-(instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self =[super init];

    if(self)
    {
        self.name =        [dictionary objectForKey:@"name"];
        self.photo =       [dictionary objectForKey:@"photo"];

    }
    return self;
}

-(instancetype) initWithString:(NSString *)string
{
    self =[super init];

    if(self)
    {
        self.name =  string;
    }
    return self;
}



+(void)retrieveListWithCompletion:(NSManagedObjectContext *) managedObjectContext allList:(BOOL) allList  completionHandler:(void (^)(NSArray *))complete
{

    //check if core data is not empty
    //if not empty , load from core data
    //if crashed...reset Simulator to clean previous appdelegate

    NSError *error =nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Friend"];

    NSArray *resultAllArray = [NSArray new];
    NSMutableArray *resultArray = [NSMutableArray new];

    resultAllArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error){
        NSLog(@"%@, %@", error, error.localizedDescription);
    } else {


        //write ALL or (isFriend) only into result array
        if(allList){

            resultArray = [resultAllArray mutableCopy];

        } else {

            for (NSManagedObject *mo in resultAllArray) {
                if([[mo valueForKey:@"isFriend"] boolValue]){
                    NSLog(@"%@, %@", [mo valueForKey:@"name"], [mo valueForKey:@"isFriend"]);
                    [resultArray addObject:mo];
                }
            }
        }
        
        complete(resultArray);
    } // core data is not empty


    /////

    //core data is empty ....load default from JSON
    if(resultArray == nil || resultArray.count ==0)
    {

        NSURL *url = [NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/18/friends.json"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];

        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
         ^(NSURLResponse *response, NSData *data, NSError *connectionError) {

             NSArray *jsonArray  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

             NSLog(@"json count == %ld",jsonArray.count);
             NSError *error = nil;
             for (NSString *string in jsonArray) {
                 NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:managedObjectContext];
                 [newObject setValue:string forKey:@"name"];


                 if (![managedObjectContext save:&error]) {
                     NSLog(@"Unable to save managed object context.");
                     NSLog(@"%@, %@", error, error.localizedDescription);
                 }
             }

             //Now fetch again after saving list into CORE DATA
             NSArray *resultAllArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
             NSLog(@"after saving list....CORE DATA: size %ld", resultArray.count);
             for (NSManagedObject *mo in resultArray) {
                 NSLog(@"===%@",[mo valueForKey:@"name"]);
             }

             //write ALL or (isFriend) only into result array
             NSMutableArray *resultArray = [NSMutableArray new];
             if(allList){

                 resultArray = [resultAllArray mutableCopy];

             } else {

                 for (NSManagedObject *mo in resultAllArray) {
                     if([mo valueForKey:@"isFriend"]){
                         [resultArray addObject:mo];
                     }
                 }
             }

             complete(resultArray); //in NSURLConnection block
             

         }];
        
        
    }
}



@end
