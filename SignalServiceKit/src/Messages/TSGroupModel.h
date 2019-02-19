//
//  Copyright (c) 2018 Open Whisper Systems. All rights reserved.
//

#import "ContactsManagerProtocol.h"
#import "TSYapDatabaseObject.h"

NS_ASSUME_NONNULL_BEGIN

extern const int32_t kGroupIdLength;

@interface TSGroupModel : TSYapDatabaseObject

@property (nonatomic) NSArray<NSString *> *groupMemberIds;
@property (nonatomic) NSArray<NSString *> *groupAdminIds;
@property (nullable, readonly, nonatomic) NSString *groupName;
@property (readonly, nonatomic) NSData *groupId;
@property (nonatomic) BOOL canOnlyWriteAdmin;

#if TARGET_OS_IOS
@property (nullable, nonatomic, strong) UIImage *groupImage;

- (instancetype)initWithTitle:(nullable NSString *)title
                    memberIds:(NSArray<NSString *> *)memberIds
                        image:(nullable UIImage *)image
                      groupId:(NSData *)groupId;

- (instancetype)initWithTitle:(nullable NSString *)title
                    memberIds:(NSArray<NSString *> *)memberIds
                     adminIds:(NSArray<NSString *> *)adminIds
                        image:(nullable UIImage *)image
                      groupId:(NSData *)groupId;

- (BOOL)isEqual:(id)other;
- (BOOL)isEqualToGroupModel:(TSGroupModel *)model;
- (NSString *)getInfoStringAboutUpdateTo:(TSGroupModel *)model contactsManager:(id<ContactsManagerProtocol>)contactsManager;
#endif

@end

NS_ASSUME_NONNULL_END
