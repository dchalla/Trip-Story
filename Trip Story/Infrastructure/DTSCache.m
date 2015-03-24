//
//  DTSCache.m
//  Anypic
//
//

#import "DTSCache.h"

@interface DTSCache()

@property (nonatomic, strong) NSCache *cache;
- (void)setAttributes:(NSDictionary *)attributes forTrip:(DTSTrip *)trip;
@end

@implementation DTSCache
@synthesize cache;

#pragma mark - Initialization

+ (id)sharedCache {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

#pragma mark - DTSCache

- (void)clear {
    [self.cache removeAllObjects];
}

- (void)setAttributesForTrip:(DTSTrip *)trip likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithBool:likedByCurrentUser],kDTSTripAttributesIsLikedByCurrentUserKey,
                                      @([likers count]),kDTSTripAttributesLikeCountKey,
                                      likers,kDTSTripAttributesLikersKey,
                                      @([commenters count]),kDTSTripAttributesCommentCountKey,
                                      commenters,kDTSTripAttributesCommentersKey,
                                      nil];
    [self setAttributes:attributes forTrip:trip];
}

- (void)setAttributesForTripObjectID:(NSString *)tripObjectID likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser {
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithBool:likedByCurrentUser],kDTSTripAttributesIsLikedByCurrentUserKey,
								@([likers count]),kDTSTripAttributesLikeCountKey,
								likers,kDTSTripAttributesLikersKey,
								@([commenters count]),kDTSTripAttributesCommentCountKey,
								commenters,kDTSTripAttributesCommentersKey,
								nil];
	[self setAttributes:attributes forTripObjectID:tripObjectID];
}

- (NSDictionary *)attributesForTrip:(DTSTrip *)trip {
    NSString *key = [self keyForTrip:trip];
    return [self.cache objectForKey:key];
}

- (NSNumber *)likeCountForTrip:(DTSTrip *)trip {
    NSDictionary *attributes = [self attributesForTrip:trip];
    if (attributes) {
        return [attributes objectForKey:kDTSTripAttributesLikeCountKey];
    }

    return [NSNumber numberWithInt:0];
}

- (NSNumber *)commentCountForTrip:(DTSTrip *)trip {
    NSDictionary *attributes = [self attributesForTrip:trip];
    if (attributes) {
        return [attributes objectForKey:kDTSTripAttributesCommentCountKey];
    }
    
    return [NSNumber numberWithInt:0];
}

- (NSArray *)likersForTrip:(DTSTrip *)trip {
    NSDictionary *attributes = [self attributesForTrip:trip];
    if (attributes) {
        return [attributes objectForKey:kDTSTripAttributesLikersKey];
    }
    
    return [NSArray array];
}

- (NSArray *)commentersForTrip:(DTSTrip *)trip {
    NSDictionary *attributes = [self attributesForTrip:trip];
    if (attributes) {
        return [attributes objectForKey:kDTSTripAttributesCommentersKey];
    }
    
    return [NSArray array];
}

- (void)setTripIsLikedByCurrentUser:(DTSTrip *)trip liked:(BOOL)liked {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForTrip:trip]];
    [attributes setObject:[NSNumber numberWithBool:liked] forKey:kDTSTripAttributesIsLikedByCurrentUserKey];
    [self setAttributes:attributes forTrip:trip];
}

- (BOOL)isTripLikedByCurrentUser:(DTSTrip *)trip {
    NSDictionary *attributes = [self attributesForTrip:trip];
    if (attributes) {
        return [[attributes objectForKey:kDTSTripAttributesIsLikedByCurrentUserKey] boolValue];
    }
    
    return NO;
}

- (void)incrementLikerCountForTrip:(DTSTrip *)trip {
    NSNumber *likerCount = [NSNumber numberWithInt:[[self likeCountForTrip:trip] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForTrip:trip]];
    [attributes setObject:likerCount forKey:kDTSTripAttributesLikeCountKey];
    [self setAttributes:attributes forTrip:trip];
}

- (void)decrementLikerCountForTrip:(DTSTrip *)trip {
    NSNumber *likerCount = [NSNumber numberWithInt:[[self likeCountForTrip:trip] intValue] - 1];
    if ([likerCount intValue] < 0) {
        return;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForTrip:trip]];
    [attributes setObject:likerCount forKey:kDTSTripAttributesLikeCountKey];
    [self setAttributes:attributes forTrip:trip];
}

- (void)incrementCommentCountForTrip:(DTSTrip *)trip {
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForTrip:trip] intValue] + 1];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForTrip:trip]];
    [attributes setObject:commentCount forKey:kDTSTripAttributesCommentCountKey];
    [self setAttributes:attributes forTrip:trip];
}

- (void)decrementCommentCountForTrip:(DTSTrip *)trip {
    NSNumber *commentCount = [NSNumber numberWithInt:[[self commentCountForTrip:trip] intValue] - 1];
    if ([commentCount intValue] < 0) {
        return;
    }
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForTrip:trip]];
    [attributes setObject:commentCount forKey:kDTSTripAttributesCommentCountKey];
    [self setAttributes:attributes forTrip:trip];
}

- (void)setAttributesForUser:(PFUser *)user tripCount:(NSNumber *)count followedByCurrentUser:(BOOL)following {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                count,kDTSUserAttributesTripCountKey,
                                [NSNumber numberWithBool:following],kDTSUserAttributesIsFollowedByCurrentUserKey,
                                nil];
    [self setAttributes:attributes forUser:user];
}

- (NSDictionary *)attributesForUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    return [self.cache objectForKey:key];
}

- (NSNumber *)tripCountForUser:(PFUser *)user {
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *tripCount = [attributes objectForKey:kDTSUserAttributesTripCountKey];
        if (tripCount) {
            return tripCount;
        }
    }
    
    return [NSNumber numberWithInt:0];
}

- (BOOL)followStatusForUser:(PFUser *)user {
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *followStatus = [attributes objectForKey:kDTSUserAttributesIsFollowedByCurrentUserKey];
        if (followStatus) {
            return [followStatus boolValue];
        }
    }

    return NO;
}

- (void)setTripCount:(NSNumber *)count user:(PFUser *)user {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:count forKey:kDTSUserAttributesTripCountKey];
    [self setAttributes:attributes forUser:user];
}

- (void)setFollowStatus:(BOOL)following user:(PFUser *)user {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:[NSNumber numberWithBool:following] forKey:kDTSUserAttributesIsFollowedByCurrentUserKey];
    [self setAttributes:attributes forUser:user];
}

- (void)setFacebookFriends:(NSArray *)friends {
    NSString *key = kDTSUserDefaultsCacheFacebookFriendsKey;
    [self.cache setObject:friends forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:friends forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)facebookFriends {
    NSString *key = kDTSUserDefaultsCacheFacebookFriendsKey;
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    }
    
    NSArray *friends = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (friends) {
        [self.cache setObject:friends forKey:key];
    }

    return friends;
}


#pragma mark - ()

- (void)setAttributes:(NSDictionary *)attributes forTrip:(DTSTrip *)trip {
    NSString *key = [self keyForTrip:trip];
    [self.cache setObject:attributes forKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forTripObjectID:(NSString *)tripObjectID {
	 NSString *key = [self keyForTripObjectId:tripObjectID];
	[self.cache setObject:attributes forKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    [self.cache setObject:attributes forKey:key];    
}

- (NSString *)keyForTrip:(DTSTrip *)trip {
    return [NSString stringWithFormat:@"trip_%@", [trip objectId]];
}

- (NSString *)keyForTripObjectId:(NSString *)tripObjectID
{
	return [NSString stringWithFormat:@"trip_%@", tripObjectID];
}

- (NSString *)keyForUser:(PFUser *)user {
    return [NSString stringWithFormat:@"user_%@", [user objectId]];
}

@end
