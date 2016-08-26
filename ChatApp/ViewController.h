//
//  ViewController.h
//  ChatApp
//
//  Created by Jayaprada on 17/08/16.
//  Copyright © 2016 Jayaprada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

typedef enum
{
    MESSAGE_TEAM = 0,
    MESSAGE_PEOPLE = 1,
    MESSAGE_ROOM,
}MessageElement;

@interface ViewController : CommonViewController
{
    MessageElement messageElement;
    BOOL            isSearchClicked;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *suggestionTbl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)onSegementChange:(id)sender;

@end

