//
//  EZViewController.h
//  EZLocalizableDemo
//
//  Created by EZ on 14-1-2.
//  Copyright (c) 2014年 cactus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EZViewController : UIViewController

- (IBAction)selectLanguageAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *helloLabel;
@end
