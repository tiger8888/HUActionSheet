项目中需要用到多选功能,由于UIActionSheet在有多个选项时,显示效果不好,太长了...,另外还需要与reactiveCocoa相适配,就自己写了个.
用法:
```objective-C
    NSArray* arr=@[@"aaa",@"bbb",@"ccc",@"ddd",@"eee"];
    HUActionSheet* ac=[[HUActionSheet alloc] initWithData:arr];
    [ac show];
    @weakify(self);
    //注意indexSignal为热信号..
    [ac.indexSignal subscribeNext:^(NSNumber* x){
        @strongify(self);
        self.txt.text=[arr objectAtIndex:x.intValue];
    }];
```
