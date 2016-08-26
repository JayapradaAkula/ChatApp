//
//  FSCell.m
//  iBelong
//
//  Created by Jayaprada on 05/04/16.
//  Copyright © 2016 Jayaprada. All rights reserved.
//

#import "UserCell.h"
#import "WTGlyphFontSet.h"

@implementation UserCell

- (void)awakeFromNib {
    // Initialization code
    
    [WTGlyphFontSet setDefaultFontSetName:@"fontawesome"];

    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIView *imgView = (UIView*)[self viewWithTag:1];
    imgView.layer.cornerRadius = imgView.frame.size.width/2.0f;
    imgView.layer.masksToBounds = YES;
//    imgView.backgroundColor = [UIColor lightGrayColor];
    
    _profilePic.layer.cornerRadius = _profilePic.frame.size.width/2.0f;
    _profilePic.layer.masksToBounds = YES;
    
    _profilePic.image = [UIImage imageGlyphNamed:@"user" height:_profilePic.frame.size.height/2.0 color:[UIColor lightGrayColor]];
    
    
    [_profilePic setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTapRecogniser =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onProfilePicture:)];
    [singleTapRecogniser setDelegate:self];
    singleTapRecogniser.numberOfTouchesRequired = 1;
    singleTapRecogniser.numberOfTapsRequired = 1;
    [_profilePic addGestureRecognizer:singleTapRecogniser];
    
}

-(void)onProfilePicture:(UITapGestureRecognizer *)tapGesture
{
    if( _delegate)
    {
        [_delegate onProfileImage:self];
    }
}




@end
