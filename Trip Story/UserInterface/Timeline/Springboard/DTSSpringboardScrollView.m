//
//  DTSSpringboardScrollView.m
//

#import "DTSSpringboardScrollView.h"

#import "DTSSpringboardItemView.h"

#define DTSPointDistance(x1, y1, x2, y2) (sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)))
#define DTSPointDistanceSquared(x1, y1, x2, y2) ((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2))

@interface DTSSpringboardScrollView () <UIScrollViewDelegate>
{
  UIView* _touchView;
  UIView* _contentView;
  // controls how much transform we apply to the views (not used)
  float _transformFactor;
  // a few state variables
  NSUInteger _lastFocusedViewIndex;
  CGFloat _zoomScaleCache;
  CGAffineTransform _minTransform;
  // dirty when the view changes width/height
  BOOL _minimumZoomLevelIsDirty;
  BOOL _contentSizeIsDirty;
  CGSize _contentSizeUnscaled;
  CGSize _contentSizeExtra;
  
  BOOL _centerOnEndDrag;
  BOOL _centerOnEndDeccel;
}

@end

#pragma mark -

@implementation DTSSpringboardScrollView

- (void)setItemViews:(NSArray *)itemViews
{
  if(_itemViews != itemViews)
  {
    for(UIView* view in _itemViews)
      if([view isDescendantOfView:self] == YES)
        [view removeFromSuperview];
    
    _itemViews = [itemViews copy];
    
    for(UIView* view in _itemViews)
    {
      [_contentView addSubview:view];
    }
    
    [self DTS_setContentSizeIsDirty];
  }
}

- (void)setItemDiameter:(NSUInteger)itemDiameter
{
  if(_itemDiameter != itemDiameter)
  {
    _itemDiameter = itemDiameter;
    [self DTS_setContentSizeIsDirty];
  }
}

- (void)setItemPadding:(NSUInteger)itemPadding
{
  if(_itemPadding != itemPadding)
  {
    _itemPadding = itemPadding;
    [self DTS_setContentSizeIsDirty];
  }
}

- (void)setMinimumItemScaling:(double)minimumItemScaling
{
  if(_minimumItemScaling != minimumItemScaling)
  {
    _minimumItemScaling = minimumItemScaling;
    [self setNeedsLayout];
  }
}

- (void)showAllContentAnimated:(BOOL)animated
{
  CGRect contentRectInContentSpace = [self DTS_fullContentRectInContentSpace];
  _lastFocusedViewIndex = [self DTS_closestIndexToPointInContent:[self DTS_rectCenter:contentRectInContentSpace]];
  
  if(animated == YES)
  {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
      [self zoomToRect:contentRectInContentSpace animated:NO];
      [self layoutIfNeeded];
    } completion:nil];
  }
  else
    [self zoomToRect:contentRectInContentSpace animated:NO];
}

- (NSUInteger)indexOfItemClosestToPoint:(CGPoint)pointInSelf
{
  return [self DTS_closestIndexToPointInSelf:pointInSelf];
}

- (void)centerOnIndex:(NSUInteger)index zoomScale:(CGFloat)zoomScale animated:(BOOL)animated
{
  _lastFocusedViewIndex = index;
  UIView* view = [_itemViews objectAtIndex:index];
  CGPoint centerContentSpace = view.center;

  if(zoomScale != self.zoomScale)
  {
    CGRect rectInContentSpace = [self DTS_rectWithCenter:centerContentSpace size:view.bounds.size];
    // this takes the rect in content space
    [self zoomToRect:rectInContentSpace animated:animated];
  }
  else
  {
    CGSize sizeInSelfSpace = self.bounds.size;
    CGPoint centerInSelfSpace = [self DTS_pointInContentToSelf:centerContentSpace];
    CGRect rectInSelfSpace = [self DTS_rectWithCenter:centerInSelfSpace size:sizeInSelfSpace];
    // this takes the rect in self space
    [self scrollRectToVisible:rectInSelfSpace animated:animated];
  }
}

- (void)doIntroAnimation
{
  [self layoutIfNeeded];
  
  CGSize size = self.bounds.size;
  NSUInteger i = 0;
  float minScale = 0.5;
  UIView* centerView = [_itemViews objectAtIndex:_lastFocusedViewIndex];
  CGPoint centerViewCenter = centerView.center;
  for(UIView* view in _itemViews)
  {
    CGPoint viewCenter = view.center;
    view.alpha = 0;
    int dx = (viewCenter.x-centerViewCenter.x);
    int dy = (viewCenter.y-centerViewCenter.y);
    int distance = (dx*dx-dy*dy);
    float factor = MAX(MIN(MAX(size.width,size.height)/distance, 1), 0);
    float scaleFactor = ((factor)*0.8+0.2);
    float translateFactor = -0.9;
    // alt version
    //float scaleFactor = ((1-factor));
    //float translateFactor = 5*(1-factor);//1-(factor*factor*factor);
    view.transform = CGAffineTransformScale(
                                            CGAffineTransformMakeTranslation(dx*translateFactor, dy*translateFactor),
                                            minScale*scaleFactor, minScale*scaleFactor);
    i++;
  }
  
  [self setNeedsLayout];
  [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    for(UIView* view in self.itemViews)
    {
      view.alpha = 1;
    }
    [self layoutSubviews];
  } completion:nil];
}

#pragma mark - Input

- (void)DTS_didZoomGesture:(UITapGestureRecognizer*)sender
{
  CGFloat maximumZoom = 1;
  
  CGPoint positionInSelf = [sender locationInView:self];
  NSUInteger targetIndex = [self DTS_closestIndexToPointInSelf:positionInSelf];
  
  if(self.zoomScale >= _minimumZoomLevelToLaunchApp && self.zoomScale != self.minimumZoomScale)
  {
    // we should zoom out
    [self showAllContentAnimated:YES];
  }
  else
  {
    // we missed a tap or we're too small, so zoom in
    [UIView animateWithDuration:0.5 animations:^{
      [self centerOnIndex:targetIndex zoomScale:maximumZoom animated:NO];
      [self layoutIfNeeded];
    } completion:nil];
  }
}

#pragma mark - Privates

- (void)DTS_initBase
{
  NSLog(@"initbase");
  self.delaysContentTouches = NO;
  self.showsHorizontalScrollIndicator = NO;
  self.showsVerticalScrollIndicator = NO;
  self.alwaysBounceHorizontal = YES;
  self.alwaysBounceVertical = YES;
  self.bouncesZoom = YES;
  self.decelerationRate = UIScrollViewDecelerationRateFast;
  self.delegate = self;
  
  self.itemDiameter = 68;
  self.itemPadding = 48;
  self.minimumItemScaling = 0.5;
  
  _transformFactor = 1;
  _zoomScaleCache = self.zoomScale;
  _minimumZoomLevelToLaunchApp = 0.4;
  
  _touchView = [[UIView alloc] init];
  [self addSubview:_touchView];
  
  _contentView = [[UIView alloc] init];
  [self addSubview:_contentView];
  
  _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DTS_didZoomGesture:)];
  _doubleTapGesture.numberOfTapsRequired = 1;
  [_contentView addGestureRecognizer:_doubleTapGesture];
}

- (CGPoint)DTS_pointInSelfToContent:(CGPoint)point
{
  CGFloat zoomScale = self.zoomScale;
  return CGPointMake(point.x/zoomScale,
                     point.y/zoomScale);
}

- (CGPoint)DTS_pointInContentToSelf:(CGPoint)point
{
  CGFloat zoomScale = self.zoomScale;
  return CGPointMake(point.x*zoomScale,
                     point.y*zoomScale);
}

- (CGSize)DTS_sizeInSelfToContent:(CGSize)size
{
  CGFloat zoomScale = self.zoomScale;
  return CGSizeMake(size.width/zoomScale,
                    size.height/zoomScale);
}

- (CGSize)DTS_sizeInContentToSelf:(CGSize)size
{
  CGFloat zoomScale = self.zoomScale;
  return CGSizeMake(size.width*zoomScale,
                    size.height*zoomScale);
}

- (CGPoint)DTS_rectCenter:(CGRect)rect
{
  return CGPointMake(rect.origin.x+rect.size.width*0.5, rect.origin.y+rect.size.height*0.5);
}

- (CGRect)DTS_rectWithCenter:(CGPoint)center size:(CGSize)size
{
  return CGRectMake(center.x-size.width*0.5, center.y-size.height*0.5, size.width, size.height);
}

- (void)DTS_transformView:(DTSSpringboardItemView*)view
{
  CGSize size = self.bounds.size;
  CGFloat zoomScale = _zoomScaleCache;
  UIEdgeInsets insets = self.contentInset;
  
  CGPoint center = view.center;
  CGRect frame = [self convertRect:CGRectMake(view.center.x-_itemDiameter/2, view.center.y-_itemDiameter/2, _itemDiameter, _itemDiameter) fromView:view.superview];
  CGPoint contentOffset = self.contentOffset;
  frame.origin.x -= contentOffset.x;
  frame.origin.y -= contentOffset.y;
  center = CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
  NSUInteger padding = _itemPadding*zoomScale*0.4;
  double distanceToBorder = size.width;
  float xOffset = 0;
  float yOffset = 0;
  
  double distanceToBeOffset = _itemDiameter*zoomScale*(MIN(size.width, size.height)/320);
  float leftDistance = center.x-padding-insets.left;
  if(leftDistance < distanceToBeOffset)
  {
    if(leftDistance < distanceToBorder)
      distanceToBorder = leftDistance;
    xOffset = 1-leftDistance/distanceToBeOffset;
  }
  float topDistance = center.y-padding-insets.top;
  if(topDistance < distanceToBeOffset)
  {
    if(topDistance < distanceToBorder)
      distanceToBorder = topDistance;
    yOffset = 1-topDistance/distanceToBeOffset;
  }
  float rightDistance = size.width-padding-center.x-insets.right;
  if(rightDistance < distanceToBeOffset)
  {
    if(rightDistance < distanceToBorder)
      distanceToBorder = rightDistance;
    xOffset = -(1-rightDistance/distanceToBeOffset);
  }
  float bottomDistance = size.height-padding-center.y-insets.bottom;
  if(bottomDistance < distanceToBeOffset)
  {
    if(bottomDistance < distanceToBorder)
      distanceToBorder = bottomDistance;
    yOffset = -(1-bottomDistance/distanceToBeOffset);
  }
  
  distanceToBorder *= 2;
  double usedScale;
  if(distanceToBorder < distanceToBeOffset*2)
  {
    if(distanceToBorder < -(NSInteger)_itemDiameter*2.5)
    {
      view.transform = _minTransform;
      usedScale = _minimumItemScaling*zoomScale;
    }
    else
    {
      double rawScale = MAX(distanceToBorder/(distanceToBeOffset*2), 0);
      rawScale = MIN(rawScale, 1);
      rawScale = 1-pow(1-rawScale, 2);
      double scale = rawScale*(1-_minimumItemScaling)+_minimumItemScaling;

      xOffset = frame.size.width*0.8*(1-rawScale)*xOffset;
      yOffset = frame.size.width*0.5*(1-rawScale)*yOffset;

      float translationModifier = MIN(distanceToBorder/_itemDiameter+2.5, 1);
      
      scale = MAX(MIN(scale*_transformFactor+(1-_transformFactor), 1), 0);
      translationModifier = MIN(translationModifier*_transformFactor, 1);
      view.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(scale, scale), xOffset*translationModifier, yOffset*translationModifier);
      
      usedScale = scale*zoomScale;
    }
  }
  else
  {
    view.transform = CGAffineTransformIdentity;
    usedScale = zoomScale;
  }
  if(self.isDragging == YES || self.isZooming == YES)
    [view setScale:usedScale animated:YES];
  else
    view.scale = usedScale;
}

- (void)DTS_setContentSizeIsDirty
{
  _contentSizeIsDirty = YES;
  [self DTS_setMinimumZoomLevelIsDirty];
}

- (void)DTS_setMinimumZoomLevelIsDirty
{
  _minimumZoomLevelIsDirty = YES;
  _contentSizeIsDirty = YES;
  [self setNeedsLayout];
}

- (NSUInteger)DTS_closestIndexToPointInSelf:(CGPoint)pointInSelf
{
  CGPoint pointInContent = [self DTS_pointInSelfToContent:pointInSelf];
  return [self DTS_closestIndexToPointInContent:pointInContent];
}

- (NSUInteger)DTS_closestIndexToPointInContent:(CGPoint)pointInContent
{
  BOOL hasItem = NO;
  double distance = 0;
  NSUInteger index = _lastFocusedViewIndex;
  NSUInteger i = 0;
  for(UIView* potentialView in _itemViews)
  {
    CGPoint center = potentialView.center;
    double potentialDistance = DTSPointDistance(center.x, center.y, pointInContent.x, pointInContent.y);
    
    if(potentialDistance < distance || hasItem == NO)
    {
      hasItem = YES;
      distance = potentialDistance;
      index = i;
    }
    i++;
  }
  return index;
}

- (void)DTS_centerOnClosestToScreenCenterAnimated:(BOOL)animated
{
  CGSize sizeInSelf = self.bounds.size;
  CGPoint centerInSelf = CGPointMake(sizeInSelf.width*0.5, sizeInSelf.height*0.5);
  NSUInteger closestIndex = [self DTS_closestIndexToPointInSelf:centerInSelf];
  [self centerOnIndex:closestIndex zoomScale:self.zoomScale animated:animated];
}

- (CGRect)DTS_fullContentRectInContentSpace
{
  CGRect rect = CGRectMake(_contentSizeExtra.width*0.5,
                           _contentSizeExtra.height*0.5,
                           _contentSizeUnscaled.width-_contentSizeExtra.width,
                           _contentSizeUnscaled.height-_contentSizeExtra.height);
  //_debugRectInContent.frame = rect;
  return rect;
}

- (CGRect)DTS_insetRectInSelf
{
  UIEdgeInsets insets = self.contentInset;
  CGSize size = self.bounds.size;
  return CGRectMake(insets.left, insets.top, size.width-insets.left-insets.right, size.height-insets.top-insets.bottom);
}

- (void)DTS_centerViewIfSmaller
{
  /*CGRect frameToCenter = _contentView.frame;
  
  CGRect rect = [self DTS_insetRect];
  // center horizontally
  if (frameToCenter.size.width < rect.size.width)
    frameToCenter.origin.x = (rect.size.width - frameToCenter.size.width) / 2;
  else
    frameToCenter.origin.x = 0;
  
  // center vertically
  if (frameToCenter.size.height < rect.size.height)
    frameToCenter.origin.y = (rect.size.height - frameToCenter.size.height) / 2;
  else
    frameToCenter.origin.y = 0;
  
  _contentView.frame = frameToCenter;*/
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
  // TODO: refactor to make functions use converter and helper functions
  CGSize size = self.bounds.size;
  CGFloat zoomScale = self.zoomScale;
  
  // targetContentOffset is in coordinates relative to self;
  
  // putting proposedTargetCenter in coordinates relative to _contentView
  CGPoint proposedTargetCenter = CGPointMake(targetContentOffset->x+size.width/2, targetContentOffset->y+size.height/2);
  proposedTargetCenter.x /= zoomScale;
  proposedTargetCenter.y /= zoomScale;
  //_debugRectInContent.frame = CGRectMake(proposedTargetCenter.x-40, proposedTargetCenter.y-40, 80, 80);
  
  // finding out the idealTargetCenter in coordinates relative to _contentView
  _lastFocusedViewIndex = [self DTS_closestIndexToPointInContent:proposedTargetCenter];
  UIView* view = [_itemViews objectAtIndex:_lastFocusedViewIndex];
  CGPoint idealTargetCenter = view.center;
  //_debugRectInContent.frame = CGRectMake(idealTargetCenter.x-40, idealTargetCenter.y-40, 80, 80);

  // finding out the idealTargetOffset in coordinates relative to _contentView
  CGPoint idealTargetOffset = CGPointMake(idealTargetCenter.x-size.width/2/zoomScale, idealTargetCenter.y-size.height/2/zoomScale);
  //_debugRectInContent.frame = CGRectMake(idealTargetOffset.x-40, idealTargetOffset.y-40, 80, 80);
  
  // finding out the correctedTargetOffset in coordinates relative to self
  CGPoint correctedTargetOffset = CGPointMake(idealTargetOffset.x*zoomScale,
                                              idealTargetOffset.y*zoomScale);
  //_debugRectInScroll.frame = CGRectMake(correctedTargetOffset.x-40, correctedTargetOffset.y-40, 80, 80);
  
  // finding out currentCenter in coordinates relative to _contentView;
  CGPoint currentCenter = CGPointMake(self.contentOffset.x+size.width/2, self.contentOffset.y+size.height/2);
  currentCenter.x /= zoomScale;
  currentCenter.y /= zoomScale;
  //_debugRectInContent.frame = CGRectMake(currentCenter.x-40, currentCenter.y-40, 80, 80);
  
  // finding out the frame of actual icons in relation to _contentView
  CGPoint contentCenter = _contentView.center;
  contentCenter.x /= zoomScale;
  contentCenter.y /= zoomScale;
  CGSize contentSizeNoExtras = CGSizeMake(_contentSizeUnscaled.width-_contentSizeExtra.width, _contentSizeUnscaled.height-_contentSizeExtra.height);
  CGRect contentFrame = CGRectMake(contentCenter.x-contentSizeNoExtras.width*0.5, contentCenter.y-contentSizeNoExtras.height*0.5, contentSizeNoExtras.width, contentSizeNoExtras.height);
  //_debugRectInContent.frame = contentFrame;
  
  if(CGRectContainsPoint(contentFrame, proposedTargetCenter) == NO)
  {
    // we're going to end outside
    if(CGRectContainsPoint(contentFrame, currentCenter) == NO)
    {
      // we're already outside. stop roll and snap back on end drag
      *targetContentOffset = self.contentOffset;
      _centerOnEndDrag = YES;
      return;
    }
    else
    {
      // we're still in, ending out. Wait for the animation to end, THEN snap back.
      float ourPriority = 0.8;
      *targetContentOffset = CGPointMake(
                                         targetContentOffset->x*(1-ourPriority)+correctedTargetOffset.x*ourPriority,
                                         targetContentOffset->y*(1-ourPriority)+correctedTargetOffset.y*ourPriority);
      _centerOnEndDeccel = YES;
      return;
    }
  }
  // we're going to end in. snap to closest icon
  *targetContentOffset = correctedTargetOffset;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  if(_centerOnEndDrag == YES)
  {
    _centerOnEndDrag = NO;
    [self centerOnIndex:_lastFocusedViewIndex zoomScale:self.zoomScale animated:YES];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  if(_centerOnEndDeccel == YES)
  {
    _centerOnEndDeccel = NO;
    [self centerOnIndex:_lastFocusedViewIndex zoomScale:self.zoomScale animated:YES];
  }
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return _contentView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
  _zoomScaleCache = self.zoomScale;
  [self DTS_centerViewIfSmaller];
}

#pragma mark - UIView

- (void)layoutSubviews
{
  [super layoutSubviews];

  CGSize size = self.bounds.size;
  
  UIEdgeInsets insets = self.contentInset;

  NSUInteger itemsPerLine = ceil(MIN(size.width,size.height)/MAX(size.width,size.height)*sqrt([_itemViews count]));
  if(itemsPerLine % 2 == 0)
    itemsPerLine++;
  NSUInteger lines = ceil([_itemViews count]/(double)itemsPerLine);
  CGFloat newMinimumZoomScale = 0;
  if(_contentSizeIsDirty == YES)
  {
    NSUInteger padding = _itemPadding;
    _contentSizeUnscaled = CGSizeMake(itemsPerLine*_itemDiameter+(itemsPerLine+1)*padding+(_itemDiameter+padding)/2,
                                      lines*_itemDiameter+(2)*padding);
    newMinimumZoomScale = MIN((size.width-insets.left-insets.right)/_contentSizeUnscaled.width, (size.height-insets.top-insets.bottom)/_contentSizeUnscaled.height);

    _contentSizeExtra = CGSizeMake((size.width-_itemDiameter*0.5)/newMinimumZoomScale, (size.height-_itemDiameter*0.5)/newMinimumZoomScale);

    _contentSizeUnscaled.width += _contentSizeExtra.width;
    _contentSizeUnscaled.height += _contentSizeExtra.height;
    _contentView.bounds = CGRectMake(0, 0, _contentSizeUnscaled.width, _contentSizeUnscaled.height);
  }
  if(_minimumZoomLevelIsDirty == YES)
  {
    self.minimumZoomScale = newMinimumZoomScale;
    CGFloat newZoom = MAX(self.zoomScale, newMinimumZoomScale);
    if(newZoom != _zoomScaleCache || YES)
    {
      self.zoomScale = newZoom;
      _zoomScaleCache = newZoom;
    
      _contentView.center = CGPointMake(_contentSizeUnscaled.width*0.5*newZoom, _contentSizeUnscaled.height*0.5*newZoom);
      self.contentSize = CGSizeMake(_contentSizeUnscaled.width*newZoom, _contentSizeUnscaled.height*newZoom);
    }
  }
  if(_contentSizeIsDirty == YES)
  {
    NSInteger i = 0;
    for(UIView* view in _itemViews)
    {
      view.bounds = CGRectMake(0, 0, _itemDiameter, _itemDiameter);
      
      NSInteger posX,posY;
      
      NSUInteger line = i/itemsPerLine;
      NSUInteger indexInLine = i%itemsPerLine;
      if(i == 0)
      {
        // place item 0 at the center of the grid
        line = [_itemViews count]/itemsPerLine/2;
        indexInLine = itemsPerLine/2;
      }
      else
      {
        // switch item at center of grid to position 0
        if(line == [_itemViews count]/itemsPerLine/2
           && indexInLine == itemsPerLine/2)
        {
          line = 0;
          indexInLine = 0;
        }
      }

      NSUInteger lineOffset = 0;
      if(line%2 == 1)
        lineOffset = (_itemDiameter+_itemPadding)/2;
      posX = _contentSizeExtra.width*0.5+_itemPadding+lineOffset+indexInLine*(_itemDiameter+_itemPadding)+_itemDiameter/2,
      posY = _contentSizeExtra.height*0.5+_itemPadding+line*(_itemDiameter)+_itemDiameter/2;
      view.center = CGPointMake(posX, posY);

      i++;
    }
    
    _contentSizeIsDirty = NO;
  }
  if(_minimumZoomLevelIsDirty == YES)
  {
    if(_lastFocusedViewIndex <= [_itemViews count])
    {
      [self centerOnIndex:_lastFocusedViewIndex zoomScale:_zoomScaleCache animated:NO];
    }
    
    _minimumZoomLevelIsDirty = NO;
  }
  
  _zoomScaleCache = self.zoomScale;
  
  _touchView.bounds = CGRectMake(0, 0, (_contentSizeUnscaled.width-_contentSizeExtra.width)*_zoomScaleCache, (_contentSizeUnscaled.height-_contentSizeExtra.height)*_zoomScaleCache);
  _touchView.center = CGPointMake(_contentSizeUnscaled.width*0.5*_zoomScaleCache, _contentSizeUnscaled.height*0.5*_zoomScaleCache);
  
  [self DTS_centerViewIfSmaller];
  
  double scale = MIN(_minimumItemScaling*_transformFactor+(1-_transformFactor), 1);
  _minTransform = CGAffineTransformMakeScale(scale, scale);
  for(DTSSpringboardItemView* view in _itemViews)
  {
    [self DTS_transformView:view];
  }
}

- (void)setBounds:(CGRect)bounds
{
  if(CGSizeEqualToSize(bounds.size, self.bounds.size) == NO)
    [self DTS_setMinimumZoomLevelIsDirty];
  [super setBounds:bounds];
}

- (void)setFrame:(CGRect)frame
{
  if(CGSizeEqualToSize(frame.size, self.bounds.size) == NO)
    [self DTS_setMinimumZoomLevelIsDirty];
  [super setFrame:frame];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if(self)
  {
    [self DTS_initBase];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if(self)
  {
    [self DTS_initBase];
  }
  return self;
}

- (instancetype)init
{
  self = [super init];
  if(self)
  {
    [self DTS_initBase];
  }
  return self;
}

@end
