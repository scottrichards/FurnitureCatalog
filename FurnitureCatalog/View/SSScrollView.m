//
//  SSScrollView.m
//  FurnitureCatalog
//
//  Created by Scott Richards on 11/14/13.
//  Copyright (c) 2013 Scott Richards. All rights reserved.
//

#import "SSScrollView.h"

@implementation SSScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
