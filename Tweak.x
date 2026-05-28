#import <Foundation/Foundation.h>

// =======================================================
// VPN 加速器本地 VIP 属性强开组合拳
// =======================================================

// 1. 强开最常见的通用用户类属性
%hook UserModel
- (BOOL)isVIP { return YES; }
- (BOOL)isVip { return YES; }
- (BOOL)isPremium { return YES; }
- (NSInteger)vipType { return 1; }
- (double)vipExpiredTime { return 4070880000; } // 强行把过期时间改成 2099 年
%end

%hook UserInfo
- (BOOL)isVIP { return YES; }
- (BOOL)isVip { return YES; }
- (double)expireTime { return 4070880000; }
- (NSInteger)memberType { return 1; }
%end

// 2. 强开加速器常用的配置/节点解锁类
%hook AppConfig
- (BOOL)isVIP { return YES; }
- (BOOL)isVipUser { return YES; }
- (BOOL)isVIPUser { return YES; }
%end

%hook VPNNodeModel // 尝试让所有节点都变成“已解锁”状态
- (BOOL)isVIPOnly { return NO; } // 让 VIP 节点变成普通节点
- (BOOL)isVip { return NO; }
%end
