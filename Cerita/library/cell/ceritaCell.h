//
//  ceritaCell.h
//  Cerita
//
//  Created by Yazid Bustomi on 10/12/13.
//  Copyright (c) 2013 netra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ceritaCell : UITableViewCell

@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *excerpt;
@property (nonatomic,strong) UILabel *tag_label;
@property (nonatomic,strong) UILabel *relative_time;
@property (nonatomic,strong) UIImageView *thumbnail;
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UIView *container;
@property (nonatomic,strong) UIButton *share;


@end
