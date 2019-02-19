//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

#import "TSGroupModel.h"
#import "TSAccountManager.h"
#import "FunctionalUtil.h"
#import "NSString+SSK.h"

NS_ASSUME_NONNULL_BEGIN

const int32_t kGroupIdLength = 16;

@interface TSGroupModel ()

@property (nullable, nonatomic) NSString *groupName;

@end

#pragma mark -

@implementation TSGroupModel

#if TARGET_OS_IOS
- (instancetype)initWithTitle:(nullable NSString *)title
                    memberIds:(NSArray<NSString *> *)memberIds
                        image:(nullable UIImage *)image
                      groupId:(NSData *)groupId
{
    OWSAssertDebug(memberIds);
    OWSAssertDebug(groupId.length == kGroupIdLength);

    _groupName              = title;
    _groupMemberIds         = [memberIds copy];
    _groupImage = image; // image is stored in DB
    _groupId                = groupId;
    _canOnlyWriteAdmin      = false;

    return self;
}

- (instancetype)initWithTitle:(nullable NSString *)title
                    memberIds:(NSArray<NSString *> *)memberIds
                     adminIds:(NSArray<NSString *> *)adminIds
                        image:(nullable UIImage *)image
                      groupId:(NSData *)groupId
{
    OWSAssert(memberIds);
    
    _groupName              = title;
    _groupMemberIds         = [memberIds copy];
    _groupAdminIds          = [adminIds copy];
    _groupImage = image; // image is stored in DB
    _groupId                = groupId;
    _canOnlyWriteAdmin      = false;
    
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self) {
        return self;
    }

    // Occasionally seeing this as nil in legacy data,
    // which causes crashes.
    if (_groupMemberIds == nil) {
        _groupMemberIds = [NSArray new];
    }
    if (_groupAdminIds == nil) {
        _groupAdminIds = [NSArray new];
    }
    _canOnlyWriteAdmin      = false;
    OWSAssertDebug(self.groupId.length == kGroupIdLength);

    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isEqualToGroupModel:other];
}

- (BOOL)isEqualToGroupModel:(TSGroupModel *)other {
    if (self == other)
        return YES;
    if (![_groupId isEqualToData:other.groupId]) {
        return NO;
    }
    if (![_groupName isEqual:other.groupName]) {
        return NO;
    }
    if (_canOnlyWriteAdmin == other.canOnlyWriteAdmin) {
        return NO;
    }
    if (!(_groupImage != nil && other.groupImage != nil &&
          [UIImagePNGRepresentation(_groupImage) isEqualToData:UIImagePNGRepresentation(other.groupImage)])) {
        return NO;
    }
    NSMutableArray *compareMyGroupMemberIds = [NSMutableArray arrayWithArray:_groupMemberIds];
    [compareMyGroupMemberIds removeObjectsInArray:other.groupMemberIds];
    if ([compareMyGroupMemberIds count] > 0) {
        return NO;
    }
    NSMutableArray *compareMyGroupAdminIds = [NSMutableArray arrayWithArray:_groupAdminIds];
    [compareMyGroupAdminIds removeObjectsInArray:other.groupAdminIds];
    if ([compareMyGroupAdminIds count] > 0) {
        return NO;
    }
    return YES;
}

- (NSString *)getInfoStringAboutUpdateTo:(TSGroupModel *)newModel contactsManager:(id<ContactsManagerProtocol>)contactsManager {
    NSString *updatedGroupInfoString = @"";
    if (self == newModel) {
        return NSLocalizedString(@"GROUP_UPDATED", @"");
    }
    if (![_groupName isEqual:newModel.groupName]) {
        updatedGroupInfoString = [updatedGroupInfoString
            stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"GROUP_TITLE_CHANGED", @""),
                                                               newModel.groupName]];
    }
    if (_groupImage != nil && newModel.groupImage != nil &&
        !([UIImagePNGRepresentation(_groupImage) isEqualToData:UIImagePNGRepresentation(newModel.groupImage)])) {
        updatedGroupInfoString =
            [updatedGroupInfoString stringByAppendingString:NSLocalizedString(@"GROUP_AVATAR_CHANGED", @"")];
    }
    if ([updatedGroupInfoString length] == 0) {
        updatedGroupInfoString = NSLocalizedString(@"GROUP_UPDATED", @"");
    }
    NSSet *oldMembers = [NSSet setWithArray:_groupMemberIds];
    NSSet *newMembers = [NSSet setWithArray:newModel.groupMemberIds];

    NSMutableSet *membersWhoJoined = [NSMutableSet setWithSet:newMembers];
    [membersWhoJoined minusSet:oldMembers];

    NSMutableSet *membersWhoLeft = [NSMutableSet setWithSet:oldMembers];
    [membersWhoLeft minusSet:newMembers];


    if ([membersWhoLeft count] > 0) {
        NSArray *oldMembersNames = [[membersWhoLeft allObjects] map:^NSString*(NSString* item) {
            return [contactsManager displayNameForPhoneIdentifier:item];
        }];
        updatedGroupInfoString = [updatedGroupInfoString
                                  stringByAppendingString:[NSString
                                                           stringWithFormat:NSLocalizedString(@"GROUP_MEMBER_LEFT", @""),
                                                           [oldMembersNames componentsJoinedByString:@", "]]];
        BOOL isMyNumberInMembersWhoLeft = [[membersWhoLeft allObjects] containsObject:[TSAccountManager localNumber]];
        if (isMyNumberInMembersWhoLeft){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IHaveBeenRemovedFromGroupNotification" object:nil];
        }
    }
    
    if ([membersWhoJoined count] > 0) {
        NSArray *newMembersNames = [[membersWhoJoined allObjects] map:^NSString*(NSString* item) {
            return [contactsManager displayNameForPhoneIdentifier:item];
        }];
        updatedGroupInfoString = [updatedGroupInfoString
                                  stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"GROUP_MEMBER_JOINED", @""),
                                                           [newMembersNames componentsJoinedByString:@", "]]];
    }

    return updatedGroupInfoString;
}

#endif

- (nullable NSString *)groupName
{
    return _groupName.filterStringForDisplay;
}

@end

NS_ASSUME_NONNULL_END
