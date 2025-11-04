//
//  CategoryCellFont.m
//  Eat Here
//
//  Created by Silstone on 10/07/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "CategoryCellFont.h"

@implementation CategoryCellFont

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ){
        [self layoutIfNeeded];
        [self configurefont];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if( (self = [super initWithFrame:frame]) ){
        [self layoutIfNeeded];
        [self configurefont];
    }
    return self;
}

- (void) configurefont {
    // CGFloat newFontSize = (self.font.pointSize * SCALE_FACTOR_H);
    //    self.font = [UIFont fontWithName:@"ProximaNova-Regular" size:24];
    //
    //    CGFloat newFontSize = (self.font.pointSize * SCALE_FACTOR_H);
    
    // self.font = [UIFont fontWithName:@"SegoeUI" size:17];
    
    self.textColor =  [UIColor darkGrayColor];;
    
    CGFloat newFontSize;
    if([[UIScreen mainScreen] bounds].size.height == 568.0)
    {
        //iphone 5
        newFontSize = 11;;
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667.0)
    {
        //iphone 6
        newFontSize = 12;
    }
    else {
        newFontSize = 14;
    }
    
    [self setFont:[UIFont fontWithName:@"SegoeUI-Light" size:newFontSize]];
    
}
@end
