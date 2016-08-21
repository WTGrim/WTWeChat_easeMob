//
//  WTMeController.m
//  环信demo
//
//  Created by GRIM on 16/8/6.
//  Copyright © 2016年 董文涛. All rights reserved.
//

#import "WTMeController.h"

@interface WTMeController ()

@property (weak, nonatomic) IBOutlet UILabel *username;

@end

@implementation WTMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUsername];

}

- (void)setupUsername{
    
    self.username.text = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    
}

@end
