

#import <UIKit/UIKit.h>

@class RPSlidingMenuLayout;

extern const CGFloat RPSlidingCellDragInterval;

@protocol RPSlidingMenuLayoutDelegate <NSObject>

- (CGFloat)heightForFeatureCell;
- (CGFloat)heightForCollapsedCell;

@end

/**
 RPSlidingMenuLayout is a subclass of UICollectionViewLayout that is used to determine the current layout of the RPSlidingMenu. It calculates the frames necessary to make the sliding/growing cell effect.
 */
@interface RPSlidingMenuLayout : UICollectionViewFlowLayout

- (instancetype)initWithDelegate:(id<RPSlidingMenuLayoutDelegate>)delegate;

@property (nonatomic, assign) id <RPSlidingMenuLayoutDelegate> delegate;

@end
