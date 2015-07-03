//
//  ManualViewController.m
//  KJ_MetroAlram
//
//  Created by NoodleKim on 2014. 11. 8..
//  Copyright (c) 2014년 KimGiBong. All rights reserved.
//

#import "ManualViewController.h"

#define IS_4_INCH_LESS (CGRectGetHeight([[UIScreen mainScreen] bounds]) < 568)?YES:NO

@interface ManualViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIImageView *manualImage;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation ManualViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    {
        CGRect f = self.manualImage.frame;
        f.size.height = [UIImage imageNamed:@"Manual.png"].size.height;
        self.manualImage.frame = f;
        
        self.scrollview.contentSize = self.manualImage.frame.size;
        self.scrollview.scrollEnabled = YES;
        
        NSLog(@"scrollview > %f", self.scrollview.frame.size.height);
        NSLog(@"self.scrollview.contentSize > %f", self.self.scrollview.contentSize.height);
        
    }
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if (IS_4_INCH_LESS) {

        CGRect f = self.bottomView.frame;
        f.origin.y = [UIScreen mainScreen].bounds.size.height - CGRectGetHeight(f);
        self.bottomView.frame = f;
        
        f = self.scrollview.frame;
        f.size.height = CGRectGetHeight([UIScreen mainScreen].bounds);
        self.scrollview.frame = f;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)tappedCloseButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
