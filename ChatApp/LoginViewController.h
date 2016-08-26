//
//  ViewController.h
//  ChatApp
//
//  Created by Jayaprada on 17/08/16.
//  Copyright © 2016 Jayaprada. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController
{
}
@property (weak, nonatomic) IBOutlet UITextField *userTextFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFld;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)onLogin:(id)sender;


@end

