//
//  PlayerView.m
//  Video
//
//  Created by maquanhong on 12-11-2.
//  
//

#import "PlayerView.h"

@implementation PlayerView
@synthesize player;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer *)player
{
    return [(AVPlayerLayer *) [self layer] player ];
}

- (void)setPlayer:(AVPlayer *)tplayer
{
    [(AVPlayerLayer *)[self layer] setPlayer:tplayer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (delegate && [delegate respondsToSelector:@selector(touch:)]) {
        [delegate touch:self];
    }
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
