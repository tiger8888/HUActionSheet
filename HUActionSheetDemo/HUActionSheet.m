//
//  HUActionSheet.m
//  HUActionSheet
//
//  Created by Nova on 14-11-2.
//  Copyright (c) 2014年 huhuTec. All rights reserved.
//

#import "HUActionSheet.h"
@interface HUActionSheet()
@property(nonatomic,strong) UIView* backgroundView;
@property(nonatomic,strong) UIView* contentView;
@property(nonatomic,strong) UIButton* cancelBtn;
@end

static HUActionSheet* sheet=nil;
#define CANCELBUTTONHEIGHT (35.0)
#define BOTTOMMARGIN (10.0)
#define BUTTONHEIGHT (35.0)
#define BUTTONWIDTH (110.0)
#define BUTTONGAP (5.0)
@implementation HUActionSheet
- (id)initWithData:(NSArray*)array
{
    self = [super init];
    if (self) {
        self.frame=[UIScreen mainScreen].bounds;
        //用来对外输出选定项的信号
        self.indexSignal=[RACSubject subject];
        //白色的背景
        self.backgroundView=[[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.backgroundColor=[UIColor blackColor];
        self.backgroundView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.backgroundView.alpha=0;
        self.windowLevel = UIWindowLevelAlert;
        [self addSubview:self.backgroundView];
        CGRect r=CGRectMake(0,CGRectGetHeight(self.bounds) , CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        //加上contentView
        self.contentView=[[UIView alloc] initWithFrame:r];
        self.contentView.backgroundColor=[UIColor grayColor];
        self.contentView.alpha=0.9;
        self.contentView.layer.cornerRadius=3;
        self.contentView.clipsToBounds=YES;
        self.contentView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.contentView];
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)];
        [self.backgroundView addGestureRecognizer:tap];
        float certerX=self.contentView.bounds.size.width/2.0;
        NSArray* buttonX=[NSArray arrayWithObjects:[NSNumber numberWithFloat:certerX-BUTTONWIDTH-BUTTONGAP],[NSNumber numberWithFloat:certerX+BUTTONGAP],nil];
        float buttonY=0;
        int linenum=0;
        UIButton* lastButton=nil;
        //添加选项
        for(int i=0;i<array.count;i++)
        {
            float x=[[buttonX objectAtIndex:i%2] floatValue];
            if(i%2==0){
                buttonY=5+5*linenum+(BUTTONHEIGHT*linenum);
                linenum++;
            }
            CGRect rect=CGRectMake(x,buttonY, BUTTONWIDTH, BUTTONHEIGHT);
            UIButton* btn=[self insertButton:rect Title:[array objectAtIndex:i]];
            btn.tag=i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            if(i%2==0)
            {
                btn.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
                btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
                btn.contentEdgeInsets=UIEdgeInsetsMake(0,0, 0,10);
            }
            else{
                btn.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
                btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                btn.contentEdgeInsets=UIEdgeInsetsMake(0,10, 0,0);
            }
            [self.contentView addSubview:btn];
            lastButton=btn;
        }
        //如果是奇数个按钮,则最后一个按钮放大
        if(array.count%2!=0){
            CGRect rect=lastButton.frame;
            rect.size.width=BUTTONWIDTH*2+2*BUTTONGAP;
            lastButton.frame=rect;
            lastButton.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            lastButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
            lastButton.contentEdgeInsets=UIEdgeInsetsMake(0,0, 0,0);
        }
         buttonY=5+5*linenum+(BUTTONHEIGHT*linenum);
        self.cancelBtn=[[UIButton alloc]  initWithFrame:CGRectMake(0,buttonY, CGRectGetWidth(self.contentView.bounds),CANCELBUTTONHEIGHT)];
        self.cancelBtn.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.cancelBtn.backgroundColor=[UIColor whiteColor];
        [self.cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.cancelBtn.layer.cornerRadius=1.0;
        self.cancelBtn.clipsToBounds=YES;
        [self.cancelBtn addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cancelBtn];
        float spareY=self.contentView.bounds.size.height-buttonY-self.cancelBtn.bounds.size.height;
        CGRect currect=self.contentView.bounds;
        currect= CGRectInset(currect,5,spareY/2.0);
        currect.origin.y=CGRectGetHeight(self.bounds);
        //让contentView刚好包裹住按钮
        self.contentView.frame=currect;
    }
    return self;
}

//按钮点击
-(void)btnClick:(id)sender{
    [self.indexSignal sendNext:@(((UIButton*)sender).tag)];
    [self dissmiss];
}

//插入单个按钮
-(UIButton*) insertButton:(CGRect)rect Title:(NSString*) title{
    UIButton* button=[[UIButton alloc] initWithFrame:rect];
    button.backgroundColor=[UIColor whiteColor];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.cornerRadius=3;
    button.clipsToBounds=YES;
    return button;
}

//显示
-(void)show{
    sheet=self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        sheet.hidden=NO;
        sheet.backgroundView.alpha=0.1;
            CGRect r=self.contentView.frame;
            r.origin.y=self.bounds.size.height-r.size.height;
            [self.contentView setFrame:r];
    } completion:^(BOOL finished){}];
}


//取消
-(void)dissmiss{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        sheet.backgroundView.alpha=0;
            CGRect r=self.contentView.frame;
            r.origin.y=CGRectGetHeight(self.bounds);
            [self.contentView setFrame:r];
    } completion:^(BOOL b){
        sheet.hidden=YES;
        [sheet removeFromSuperview];
        sheet=nil;
    }];
}



@end
