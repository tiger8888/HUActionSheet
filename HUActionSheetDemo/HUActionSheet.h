//
//  HUActionSheet.h
//  HUActionSheet
//
//  Created by Nova on 14-11-2.
//  Copyright (c) 2014年 huhuTec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa.h>
@interface HUActionSheet : UIWindow
-(void)show;
-(void)dissmiss;
- (id)initWithData:(NSArray*)array;
@property(strong,nonatomic) RACSubject* indexSignal;
@end
