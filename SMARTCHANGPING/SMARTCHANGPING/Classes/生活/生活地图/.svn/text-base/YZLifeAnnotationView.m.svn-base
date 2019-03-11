//
//  YZLifeAnnotationView.m
//  SMARTCHANGPING
//
//  Created by 韩云智 on 2017/1/13.
//  Copyright © 2017年 韩云智. All rights reserved.
//

#import "YZLifeAnnotationView.h"

#import "YZLifePointAnnotation.h"

@interface YZLifeAnnotationView()

@property (nonatomic, strong) UIImageView * calloutView;
@property (nonatomic, strong) UIImageView * imgView;

@end

@implementation YZLifeAnnotationView

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            self.calloutView = [UIImageView new];
            self.calloutView.size = CGSizeMake(58*WIDTH_RATIO/2, 76*WIDTH_RATIO/2);
            self.calloutView.center = CGPointMake(45*WIDTH_RATIO/4, -31*WIDTH_RATIO/4);
            self.calloutView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sh_%@on", @([(YZLifePointAnnotation *)self.annotation item]%8+1)]];
        }
        
        _imgView.hidden = YES;
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
        _imgView.hidden = NO;
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self){
        self.canShowCallout = NO;
        self.draggable = NO;
        self.calloutOffset = CGPointMake(0, 0);
        [self upView];
    }
    
    return self;
}

- (void)upView{
    
    self.bounds = CGRectMake(0, 0, 45*WIDTH_RATIO/2, 45*WIDTH_RATIO/2);
    _imgView = [UIImageView new];
    _imgView.frame = self.bounds;
    _imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sh_%@", @([(YZLifePointAnnotation *)self.annotation item]%8+1)]];
    [self addSubview:_imgView];
}

- (void)update{
    _imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sh_%@", @([(YZLifePointAnnotation *)self.annotation item]%8+1)]];
    _calloutView.image = [UIImage imageNamed:[NSString stringWithFormat:@"sh_%@on", @([(YZLifePointAnnotation *)self.annotation item]%8+1)]];
}

@end
