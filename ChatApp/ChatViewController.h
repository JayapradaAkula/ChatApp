//
//  ViewController.h
//  ChatApp
//
//  Created by Jayaprada on 17/08/16.
//  Copyright © 2016 Jayaprada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface ChatViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSMutableArray *pageTitles;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewTopConstraint;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *textFeild;
- (IBAction)onSumbit:(id)sender;

@end

