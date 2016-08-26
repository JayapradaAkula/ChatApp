//
//  ViewController.m
//  ChatApp
//
//  Created by Jayaprada on 17/08/16.
//  Copyright © 2016 Jayaprada. All rights reserved.
//

#import "LoginViewController.h"
#import "WTGlyphFontSet.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(Logout:)];
    self.navigationItem.rightBarButtonItem = anotherButton;

    
    [WTGlyphFontSet setDefaultFontSetName:@"fontawesome"];

    UIView *logInView = (UIView*)[self.view viewWithTag:1];
    
    UIImageView *img = (UIImageView*)[logInView viewWithTag:11];
    img.image = [UIImage imageGlyphNamed:@"user" height:15 color:[UIColor whiteColor]];
    
    img = (UIImageView*)[logInView viewWithTag:13];
    img.image = [UIImage imageGlyphNamed:@"lock" height:15 color:[UIColor whiteColor]];
    
    UIButton *btn = (UIButton*)[logInView viewWithTag:15];
    btn.layer.cornerRadius = 15; // this value vary as per your desire
    btn.clipsToBounds = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationItem setHidesBackButton:YES animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TEXTFEILD METHODS

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [textField becomeFirstResponder];
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
   
    [textField resignFirstResponder];

    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}



- (IBAction)onLogin:(id)sender
{
}

-(void)Logout:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
@end
