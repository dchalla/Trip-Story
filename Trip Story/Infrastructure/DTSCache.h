//
//  DTSCache.h
//  Anypic
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "DTSTrip.h"
#import "DTSConstants.h"

@interface DTSCache : NSObject

+ (id)sharedCache;

- (void)clear;
- (void)setAttributesForTrip:(DTSTrip *)trip likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser;
- (NSDictionary *)attributesForTrip:(DTSTrip *)trip;
- (NSNumber *)likeCountForTrip:(DTSTrip *)trip;
- (NSNumber *)commentCountForTrip:(DTSTrip *)trip;
- (NSArray *)likersForTrip:(DTSTrip *)trip;
- (NSArray *)commentersForTrip:(DTSTrip *)trip;
- (void)setTripIsLikedByCurrentUser:(DTSTrip *)trip liked:(BOOL)liked;
- (BOOL)isTripLikedByCurrentUser:(DTSTrip *)trip;
- (void)incrementLikerCountForTrip:(DTSTrip *)trip;
- (void)decrementLikerCountForTrip:(DTSTrip *)trip;
- (void)incrementCommentCountForTrip:(DTSTrip *)trip;
- (void)decrementCommentCountForTrip:(DTSTrip *)trip;

- (NSDictionary *)attributesForUser:(PFUser *)user;
- (NSNumber *)tripCountForUser:(PFUser *)user;
- (BOOL)followStatusForUser:(PFUser *)user;
- (void)setTripCount:(NSNumber *)count user:(PFUser *)user;
- (void)setFollowStatus:(BOOL)following user:(PFUser *)user;

- (void)setFacebookFriends:(NSArray *)friends;
- (NSArray *)facebookFriends;
@end
