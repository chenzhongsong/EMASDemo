//
//  ListCell.h
//  mPaasiOSDemo
//
//  Created by 时苒 on 2020/8/5.
//  Copyright © 2020 ShiRaner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *miniprogramId;
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (weak, nonatomic) IBOutlet UILabel *descrip;
 


@end

NS_ASSUME_NONNULL_END
