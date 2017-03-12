//
//  NSArray+Extension.m
//  PlayerDemo
//
//  Created by 杨晴贺 on 2017/3/12.
//  Copyright © 2017年 Silence. All rights reserved.
//

#import "Extension.h"
#import <objc/runtime.h>

@implementation UIView (Frame)

-(void)setX:(CGFloat)x {
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
}

-(CGFloat)x {
    return self.frame.origin.x;
}

-(void)setY:(CGFloat)y {
    CGFloat x = self.frame.origin.x;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
}

-(CGFloat)y {
    return self.frame.origin.y;
}

-(void)setWidth:(CGFloat)width {
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
}

-(CGFloat)width {
    return self.frame.size.width;
}

-(void)setHeight:(CGFloat)height{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    self.frame = CGRectMake(x, y, width, height);
}

-(CGFloat)height {
    return self.frame.size.height;
}

@end

@implementation UISlider (Touch)


static char *gestureKey ;
static char *targetKey ;
static char *actionStringKey ;
- (void)addTapGestureWithTarget:(id)target action:(SEL)action{
    id gesture = objc_getAssociatedObject(self, &gesture) ;
    if(!gesture){
        objc_setAssociatedObject(self, &target, target, OBJC_ASSOCIATION_ASSIGN) ;
        objc_setAssociatedObject(self, &actionStringKey, NSStringFromSelector(action), OBJC_ASSOCIATION_RETAIN) ;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:) ];
        tap.numberOfTapsRequired = 1 ;
        tap.numberOfTouchesRequired  = 1 ;
        [self addGestureRecognizer:tap] ;
        objc_setAssociatedObject(self, &gestureKey, tap, OBJC_ASSOCIATION_RETAIN) ;
    }
}


- (void)tap:(UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint loaction = [tap locationInView:self] ;
        CGFloat x = loaction.x ;
        CGFloat r = x / self.frame.size.width ;
        CGFloat value = (self.maximumValue - self.minimumValue) * r ;
        [self setValue:value animated:YES] ;
        id obj = objc_getAssociatedObject(self, &targetKey) ;
        if(obj){
            NSString *actionStr = objc_getAssociatedObject(self, &actionStringKey) ;
            SEL action = NSSelectorFromString(actionStr) ;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [obj performSelector:action withObject:self] ;
#pragma clang diagnostic pop
        }
    }
}

- (void)dealloc{
    UITapGestureRecognizer *tap;
    id gesture =  objc_getAssociatedObject(self, &gestureKey);
    if (gesture) {
        tap = (UITapGestureRecognizer*)gesture;
        [self removeGestureRecognizer:tap];
    }
}
@end
