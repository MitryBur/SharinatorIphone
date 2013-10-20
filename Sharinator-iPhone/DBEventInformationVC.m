//
//  DBEventInformationVC.m
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 10/21/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

#import "DBEventInformationVC.h"

@interface DBEventInformationVC ()

@end

@implementation DBEventInformationVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
