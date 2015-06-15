####简单的弹出菜单
---
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
