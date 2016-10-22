//
//  SwipeButton.m
//  TableSwipeCustom
//
//  Created by 杨晴贺 on 20/10/2016.
//  Copyright © 2016 silence. All rights reserved.
//

#import "SwipeButton.h"

#define NULL_STRING(string) [string isEqualToString:@""] || !string

@implementation SwipeButton

// 全能构造
+ (SwipeButton *)createSwipeButtonWithTitle:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image touchBlock:(TouchSwipeButtonBlock)block{
    SwipeButton *button = [self buttonWithType:UIButtonTypeCustom] ;
    
    [button setTitle:title forState:UIControlStateNormal] ;
    button.titleLabel.font = [UIFont systemFontOfSize:font] ;
    button.titleLabel.textAlignment = NSTextAlignmentCenter ;
    [button setTitleColor:textColor forState:UIControlStateNormal] ;
    button.backgroundColor = backgroundColor ;
    [button setImage:image forState:UIControlStateNormal] ;
    button.touchBlock = block ;
    
    // 自动适应文字的宽度
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, button.titleLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size ;
    
    // button的宽度去文字和图片两个最大宽度
    button.frame = CGRectMake(0, 0, MAX(titleSize.width+10, image.size.width+10), 0) ;
    if(!NULL_STRING(title) && !image){
        button.titleEdgeInsets = UIEdgeInsetsMake(image.size.height, -image.size.width, 0, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height, 0.5*titleSize.width, 0.5*titleSize.height, 0);
    }
    return button ;
}

// 简单构造

//只有title
+ (SwipeButton *)createSwipeButtonWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor touchBlock:(TouchSwipeButtonBlock)block{
    return [self createSwipeButtonWithTitle:title font:15 textColor:[UIColor blackColor] backgroundColor:backgroundColor  touchBlock:block];
}

+ (SwipeButton *)createSwipeButtonWithTitle:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor touchBlock:(TouchSwipeButtonBlock)block{
    return [self createSwipeButtonWithTitle:title font:font textColor:textColor backgroundColor:backgroundColor image:nil touchBlock:block];
}


//只有图片
+ (SwipeButton *)createSwipeButtonWithImage:(UIImage *)image backgroundColor:(UIColor *)color touchBlock:(TouchSwipeButtonBlock)block{
    return [self createSwipeButtonWithTitle:nil font:15 textColor:[UIColor blackColor] backgroundColor:color image:image touchBlock:block];
}

//图片、文字都有，且图片在上 文字在下
+ (SwipeButton *)createSwipeButtonWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image touchBlock:(TouchSwipeButtonBlock)block{
    return [self createSwipeButtonWithTitle:title font:15 textColor:[UIColor blackColor] backgroundColor:backgroundColor image:image touchBlock:block];
}

// 防止文字太长或图片太大,导致图片或文字的位置不在中间
- (void)layoutSubviews{
    [super layoutSubviews] ;
    
    if(self.titleLabel.text && self.imageView.image){
        CGFloat marginH = (self.frame.size.height - self.imageView.frame.size.height - self.titleLabel.frame.size.height)/3;
        // 图片
        CGPoint imagePoint = self.imageView.center ;
        imagePoint.x = self.frame.size.width / 2 ;
        imagePoint.y = self.frame.size.height / 2 + marginH;
        self.imageView.center = imagePoint ;
        // 文字
        CGRect newFrame = self.titleLabel.frame ;
        newFrame.origin.x = 0 ;
        newFrame.origin.y = self.frame.size.height - newFrame.size.height - marginH ;
        newFrame.size.width = self.frame.size.width ;
        self.titleLabel.frame = newFrame ;
        self.titleLabel.center = self.center ;
        self.titleLabel.textAlignment = NSTextAlignmentCenter ;
    }
}

@end
