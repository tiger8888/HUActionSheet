//
//  HUViewController.m
//  HUActionSheetDemo
//
//  Created by Nova on 15-1-2.
//  Copyright (c) 2015年 huhuTec. All rights reserved.
//

#import "HUViewController.h"
#import "HUActionSheet.h"
#import <extobjc.h>
@interface HUViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txt;

@end

@implementation HUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txt.delegate=self;
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnClick:(id)sender {
    NSArray* arr=@[@"aaa",@"bbb",@"ccc",@"ddd",@"eee"];
    HUActionSheet* ac=[[HUActionSheet alloc] initWithData:arr];
    [ac show];
    @weakify(self);
    //注意indexSignal为热信号..
    [ac.indexSignal subscribeNext:^(NSNumber* x){
        @strongify(self);
        self.txt.text=[arr objectAtIndex:x.intValue];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return NO;
}
@end
