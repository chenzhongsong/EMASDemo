//
//  MtopCustomCell.m
//  EMASDemo
//
//  Created by jiangpan on 2018/5/9.
//  Copyright © 2018年 zhishui.lcq. All rights reserved.
//

#import "MtopCustomCell.h"

@implementation MtopCustomCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
            _textFiled = [[UITextField alloc] init];
            [_textFiled setTranslatesAutoresizingMaskIntoConstraints:NO];// 为防止自动布局冲突设置为NO
            [self.contentView addSubview:_textFiled];
            [self setupUI];
        }
    return self;
}

- (void)setupUI{
    
    NSLayoutConstraint *requestTextConstraint1 = [NSLayoutConstraint constraintWithItem:self.textFiled
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:0];
    
    
    NSLayoutConstraint *requestTextConstraint2 = [NSLayoutConstraint constraintWithItem:self.textFiled
                                                                              attribute:NSLayoutAttributeLeft
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeLeft
                                                                             multiplier:1.0
                                                                               constant:+18.0];

    
    
    NSLayoutConstraint *requestTextConstraint3 = [NSLayoutConstraint constraintWithItem:self.textFiled
                                                                              attribute:NSLayoutAttributeRight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeRight
                                                                             multiplier:1.0
                                                                               constant:0];
    
    NSLayoutConstraint *requestTextConstraint4 = [NSLayoutConstraint constraintWithItem:_textFiled
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeBottom
                                                                             multiplier:1.0
                                                                               constant:0];
    

    
    [self.contentView addConstraints:@[requestTextConstraint1,requestTextConstraint2,requestTextConstraint3,requestTextConstraint4]];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
