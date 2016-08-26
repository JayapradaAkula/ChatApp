//  Created by Jayaprada on 05/04/16.
//  Copyright © 2016 Jayaprada. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum
//{
//    USERCELL_ADD = 0,
//    USERCELL_MINUS = 1,
//    USERCELL_FOLLOW,
//    USERCELL_TICK,
//    
//}UserCellActions;

@class UserCell;
@protocol UserCellDelegate<NSObject>
@optional
-(void)onProfileImage:(UserCell*)cell;

@end


@interface UserCell : UICollectionViewCell <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *subLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (nonatomic, weak) id<UserCellDelegate> delegate;


@end
