//
//  DBEventInformationVC.h
//  Sharinator-iPhone
//
//  Created by Dmitry Burmistrov on 10/21/13.
//  Copyright (c) 2013 Dmitry Burmistrov. All rights reserved.
//

@import UIKit;
#import "ShariEvent.h"

@interface DBEventInformationVC : UIViewController
@property (strong, nonatomic) ShariEvent *event;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;

- (IBAction)cancel:(id)sender;
@end
