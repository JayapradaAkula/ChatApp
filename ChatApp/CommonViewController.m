//
//  ViewController.m
//  ChatApp
//
//  Created by Jayaprada on 22/08/16.
//  Copyright © 2016 Jayaprada. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()
{

}

@end

@implementation CommonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.navigationController.navigationBar.hidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:YES];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(Logout:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Logout:(id)sender
{
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popToRootViewControllerAnimated:NO];
}


@end
