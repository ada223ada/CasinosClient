CommonMethodType = {
    None = 0, -- 无效

    MsgPack = 50,

    MsgPackAccountBegin = 51,

-- Account
    AccountGatewayConnected = 52,
    AccountLoginAppRequest = 53, -- c->s, 请求登录App，连接UCenter验证
    AccountLoginAppResponse = 54, -- s->c, 响应登录App请求，连接UCenter验证
    AccountEnterWorldRequest = 55, -- c->s, 请求进入游戏世界
    AccountEnterWorldResponse = 56, -- s->c, 响应进入游戏世界请求
    AccountLogoutNotify = 57, -- s->c，登出通知
    AccountUpdateDataFromUCenterRequest = 58,-- c->s，请求从UCenter中同步AppAccountData数据，无参
    AccountUpdateDataFromUCenterNotify = 59,-- s->c，响应从UCenter中同步AppAccountData数据，AttachWechatInfo

    MsgPackAccountEnd = 65,
    MsgPackPlayerBegin = 299,

-- Player
    PlayerClientInitDoneRequest = 300, -- 客户端初始化完成
    PlayerGMInitNotify = 302, -- GM初始化通知
    PlayerUpdateClientConfigNotify = 304, -- Client配置改变通知
    PlayerOpenUrlNotify = 305, -- 打开指定网址的通知，参数：string url
    PlayerDevConsoleCmdRequest2 = 306, -- 请求发送控制台命令
    PlayerGoldAccUpdateNotify = 310, -- s->c 金币变更通知，新协议
    PlayerDiamondUpdateNotify = 311, -- s->c 钻石变更通知，新协议
    PlayerPointUpdateNotify = 312, -- 玩家积分更新通知
    PlayerMasterPointUpdateNotify = 313, -- 玩家大师分更新通知
    PlayerVipChangedNotify = 314, -- s->c VIP变更通知
    PlayerRechargePointChangedNotify = 315, -- s->c 充值点数变更通知
    PlayerIsFirstRechargeChangedNotify = 316, --  s->c 首充变更通知
    PlayerLevelupNotify = 330, -- 玩家升级通知
    PlayerLostAllSendChipsNotify = 331, -- s->c 输光后送的筹码通知
    PlayerChangeGenderRequest = 340, -- 请求改性别
    PlayerChangeGenderNotify = 341, -- 响应改性别
    PlayerChangeProfileSkinRequest = 350, -- 请求换肤
    PlayerChangeProfileSkinNotify = 351, -- 响应换肤
    PlayerChangeNickNameRequest = 360, -- 请求改昵称
    PlayerChangeNickNameNotify = 361, -- 响应改昵称
    PlayerRefreshIpAddressRequest = 370, -- 请求刷新IP所在地
    PlayerRefreshIpAddressNotify = 371, -- 响应刷新IP所在地
    PlayerChangeIndividualSignatureRequest = 380, -- 请求改签名
    PlayerChangeIndividualSignatureNotify = 381, -- 响应改签名
    PlayerChangeLanRequest = 390, -- 请求修改语言，参数：string lan
    PlayerChangeLanNotify = 391, -- 响应修改语言，参数：string lan
    MarqueeRequest = 400, -- 跑马灯，玩家请求发送跑马灯广播(可配置消耗小喇叭)
    MarqueeRequestResult = 401, -- 跑马灯，响应玩家发送跑马灯广播请求
    PlayerReportPlayerRequest = 410, -- 举报玩家
    PlayerReportPlayerNotify = 411, -- 举报玩家
    PlayerFeedbackGetListRequest = 412, -- 请求拉取反馈列表，参数：无
    PlayerFeedbackGetListNotify = 413, -- 通知拉取反馈列表，参数：List<ChatMsgClientRecv>, ulong readconfirm_msg_id
    PlayerFeedbackReadConfirmRequest = 414, -- 请求告知服务器反馈列表已读，参数：无
    PlayerFeedbackSendMsgRequest = 415, -- 发送反馈消息，参数：ChatMsg
    PlayerFeedbackRecvMsgNotify = 416, -- 收到反馈消息，参数：ChatMsgClientRecv
    PlayerGiveChipQueryRangeRequest = 420, -- 赠送玩家筹码，请求查询可赠送范围
    PlayerGiveChipQueryRangeRequestResult = 421, -- 响应赠送玩家筹码，查询可赠送范围
    PlayerGiveChipRequest = 422, -- 赠送玩家筹码
    PlayerGiveChipRequestResult = 423, -- 响应赠送玩家筹码
    PlayerBankDepositRequest = 430, -- 往银行存筹码
    PlayerBankDepositNotify = 431, -- 往银行存筹码
    PlayerBankWithdrawRequest = 432, -- 从银行取筹码
    PlayerBankWithdrawNotify = 433, -- 从银行取筹码
    PlayerDailyFirstLoginNotify = 440, -- 玩家每日首次登陆通知
    PlayerGetDailyRewardRequest = 441, -- 获取每日奖励
    PlayerGetDailyRewardNotify = 442, -- 获取每日奖励
    PlayerGetOnlineRewardRequest = 450, -- 获取在线奖励
    PlayerGetOnlineRewardRequestResult = 451, -- 获取在线奖励
    PlayerGetOnlineRewardNotify = 452, -- 在线奖励推送
    PlayerGetTimingRewardRequest = 455, -- 请求领取定时奖励，无参
    PlayerGetTimingRewardNotify = 456, -- 定时奖励通知，参数：TimingRewardData
    PlayerGetTimingRewardRequestResult = 457, -- 请求领取定时奖励结果，参数：result, long RewardGold
    PlayerGetGrowRewardRequest = 460, -- 成长奖励
    PlayerGetGrowRewardNotify = 461, -- 成长奖励
    PlayerGrowRewardSnapshotNotify = 462, -- 成长奖励快照通知
    PlayerRequestGetAddress = 470, -- 玩家请求获取收货地址，无参
    PlayerRequestGetAddressResult = 471, -- 玩家请求获取收货地址响应，result，PlayerAddress
    PlayerRequestEditAddress = 472, -- 玩家请求编辑收货地址，PlayerAddress
    PlayerRequestEditAddressResult = 473, -- 玩家请求编辑收货地址响应，result，PlayerAddress
    PlayerGetOnlinePlayerNumRequest = 476, -- 获取在线玩家数
    PlayerGetOnlinePlayerNumNotify = 477, -- 获取在线玩家数
    PlayerCreatePrivateDesktopRequest = 480, -- 请求创建私有桌子
    PlayerLeaveDesktopNotify = 481, -- 本人离开桌子通知
    PlayerPlayNowRequest = 482, -- 玩家立即玩（匹配一张合适桌子，并进入该桌子）
    PlayerInvitePlayerEnterDesktopRequest = 483, -- 邀请玩家进桌
    PlayerInvitePlayerEnterDesktopRequestResult = 484, -- 响应邀请玩家进桌
    PlayerRecvInvitePlayerEnterDesktopNotify = 485, -- 收到进桌邀请
    PlayerGetCasinosModuleDataWithFactoryNameRequest = 490, -- c->s， 请求获取玩法模块数据
    PlayerGetCasinosModuleDataWithFactoryNameNotify = 491, -- s->c， 响应获取玩法模块数据请求
    PlayerGetPlayerInfoOtherRequest = 492, -- 请求获取其他玩家信息
    PlayerGetPlayerInfoOtherNotify = 493, -- 响应获取其他玩家信息

-- Bag
    BagItemPush2ClientNotify = 570, -- c->s, 背包中所有道具推送给Client的通知
    BagGiftChangedNotify = 571, -- c->s, 背包中礼物变更通知
    BagOperateItemRequest = 572, -- c->s, 请求使用道具
    BagOperateItemNotify = 573, -- s->c, 响应使用道具
    BagDeleteItemRequest = 574, --  c->s, 请求移除道具
    BagDeleteItemNotify = 575, -- s->c, 通知删除道具
    BagAddItemNotify = 576, -- s->c, 通知添加道具
    BagUpdateItemNotify = 577, -- s->c，通知更新道具

-- Trade
    TradeBuyItemRequest = 600, -- c->s, 商店，请求购买商品
    TradeBuyItemResponse = 601, -- s->c, 商店，响应购买商品
    TradeSellItemRequest = 602, -- c->s, 商店，请求出售商品
    TradeSellItemResponse = 603, -- s->c, 商店，响应出售商品
--TradeBuyRMBItemSuccessRequest = 604, -- 购买人民币物品成功
--TradeBuyRMBItemSuccessResponse = 605, -- 购买人民币物品成功
    TradeOrderNotify = 606, -- 订单结果通知

-- Wallet
    WalletRechargeRequest = 610, -- 请求充值
    WalletRechargeNotify = 611, -- 充值通知
    WalletWithdrawRequest = 612, -- 请求提现
    WalletWithdrawNotify = 613, -- 提现通知

-- Task
    TaskRequest = 620, -- c->s, 任务请求
    TaskNotify = 621, -- s->c, 任务通知

-- Activity
    ActivityRequest = 650, -- c->s，活动拉取请求
    ActivityNotify = 651, -- s->c，活动推送通知

-- Ranking
    RankingRequest = 660, -- c->s, 获取排行榜
    RankingChipNotify = 661, -- s->c, 获取金币排行榜
    RankingGoldNotify = 662, -- s->c, 获取钻石排行榜
    RankingLevelNotify = 663, -- s->c, 获取等级排行榜
    RankingGiftNotify = 664, -- s->c, 获取礼物排行榜
    RankingWinGoldNotify = 665, -- s->c, 获取豪胜排行榜
    RankingWechatRedEnvelopesNotify = 666, -- s->c, 获取红包排行榜

-- Desktop
    DesktopUserRequest = 700, -- 桌子自定义协议
    DesktopUserNotify = 701, -- 桌子自定义协议
    DesktopSnapshotRequest = 702, -- 桌子初始化
    DesktopSnapshotNotify = 703, -- 桌子初始化
    DesktopPlayerEnterRequest = 704, -- 玩家进入桌子
    DesktopPlayerEnterNotify = 705, -- 玩家进入桌子
    DesktopPlayerLeaveRequest = 706, -- 玩家离开桌子
    DesktopPlayerLeaveNotify = 707, -- 玩家离开桌子
    DesktopPlayerSitdownRequest = 708, -- 玩家坐下
    DesktopPlayerSitdownNotify = 709, -- 玩家坐下
    DesktopPlayerObRequest = 710, -- 玩家观战
    DesktopPlayerObNotify = 711, -- 玩家观战
    DesktopPlayerWaitWhileRequest = 712, -- 玩家暂离
    DesktopPlayerWaitWhileNotify = 713, -- 玩家暂离
    DesktopPlayerReturnRequest = 714, -- 玩家继续
    DesktopPlayerReturnNotify = 715, -- 玩家继续
    DesktopPlayerGiftChangeNotify = 716, -- 通知桌内玩家礼物变更
    DesktopBuyAndSendItemNotify = 717, -- 通知普通桌内购买并赠送Item，同时支持临时礼物和魔法表情
    DesktopChatRequest = 718, -- 玩家聊天请求
    DesktopChatNotify = 719, -- 玩家聊天响应
    DesktopPlayerChangeDeskRequest = 720, -- 玩家换桌请求

-- DesktopService
    SearchDesktopListRequest = 760, -- 请求获取桌子列表
    SearchDesktopListNotify = 761, -- 响应获取桌子列表请求
    SearchDesktopByPlayerGuidRequest = 762, -- 请求获取好友所在桌
    SearchDesktopByPlayerGuidNotify = 763, -- 响应获取好友所在桌请求

-- MatchTexas
    MatchTexasRequestGetList = 800, -- 请求获取赛事信息列表，参数MatchTexasScopeType
    MatchTexasRequestGetListResult = 801, -- 响应获取赛事信息列表，返回值List<>
    MatchTexasRequestUpdatePlayerNumInList = 802, -- 请求更新赛事信息列表中的参赛人数
    MatchTexasRequestUpdatePlayerNumInListResult = 803, -- 响应更新赛事信息列表中的参赛人数
    MatchTexasRequestGetMoreInfo = 804, -- 请求获取赛事详情
    MatchTexasRequestGetMoreInfoResult = 805, -- 响应获取赛事详情，返回值BMatchTexasMoreInfo more_info
    MatchTexasRequestSignup = 806, -- 请求报名或者延迟报名
    MatchTexasRequestSignupResult = 807, -- 响应报名或者延迟报名，返回值Protocol result, string match_guid
    MatchTexasRequestCancelSignup = 808, -- 请求取消报名
    MatchTexasRequestCancelSignupResult = 809, -- 响应取消报名，返回值Protocol result, string match_guid
    MatchTexasRequestEnter = 810, -- 请求进入比赛，参数string match_guid
    MatchTexasRequestEnterResult = 811, -- 响应进入比赛，返回值Protocol result, string match_guid
    MatchTexasRequestCreate = 812, -- 请求创建比赛, 参数BMatchTexasCreateRequest
    MatchTexasRequestCreateResult = 813, -- 响应创建比赛，返回值BMatchTexasCreateResponse
    MatchTexasRequestDisband = 814, -- 请求解散比赛
    MatchTexasRequestDisbandResult = 815, -- 响应解散比赛
    MatchTexasStartNotify = 817, -- 比赛报名后开始通知
    MatchTexasRequestJoinNotPublic = 830, -- 请求加入非公开比赛，需要输入邀请码
    MatchTexasRequestJoinNotPublicResult = 831, -- 响应加入非公开比赛，返回值Protocol result, BMatchTexasMoreInfo more_info

    MatchTexasRequestRebuy = 850, -- MTT，玩家请求重购
    MatchTexasRequestRebuyResult = 851, -- MTT，玩家重购结果
    MatchTexasRequestAddon = 852, -- MTT，玩家请求增购
    MatchTexasRequestAddonResult = 853, -- MTT，玩家增购结果
    MatchTexasRequestGiveUpRebuyOrAddon = 854, -- MTT，玩家Score变为0，且有机会重购增购继续比赛期间，玩家请求放弃复活从而完成比赛。仅在结束倒计时中有效
MatchTexasPlayerFinishedNotify = 855,-- MTT，玩家比赛结束通知（紧接着玩家离桌通知后收到，用于客户端弹出比赛结束结算界面，客户端只有在该比赛的比赛桌内时才处理该消息），只通知给玩家本人
MatchTexasPlayerGameEndNotify = 856,-- MTT，比赛异常解散广播通知，同时导致玩家异常完成比赛

-- DesktopH
    DesktopHRequestEnter = 900, -- 请求进入百人桌
    DesktopHRequestLeave = 901, -- 请求离开百人桌
    DesktopHRequestSnapshot = 902, -- 请求获取百人桌快照
    DesktopHRequestBeBankerPlayer = 903, -- 请求上庄
    DesktopHRequestNotBeBankerPlayer = 904, -- 请求下庄，成为无座玩家
    DesktopHRequestSitdown = 905, -- 请求入座，只能由无座玩家发起
    DesktopHRequestStandup = 906, -- 请求站起，只能由在座玩家发起
    DesktopHRequestBet = 907, -- 请求下注
    DesktopHRequestBetRepeat = 908, -- 请求重复下注
    DesktopHRequestGetStandPlayerList = 909, -- 请求获取无座玩家列表
    DesktopHRequestSetCardsType = 910, -- 请求设置牌型
    DesktopHRequestGetWinRewardPotInfo = 911, -- 请求获取奖池开奖信息
    DesktopHRequestInitDailyBetReward = 912, -- 请求获取玩家在各个百人桌中的每日下注奖励的初始化信息
    DesktopHRequestGetDailyBetReward = 913, -- 请求获取玩家在各个百人桌中的每日下注奖励
    DesktopHRequestChat = 914, -- 请求百人桌内聊天
    DesktopHRequestBuyAndSendItem = 915, -- 请求百人桌内购买并赠送Item

    DesktopHNotifySnapshot = 950, -- 通知百人桌快照
    DesktopHNotifyIdle = 951, -- 通知切换到空闲状态广播
    DesktopHNotifyReady2 = 952, -- 通知切换到准备状态广播
    DesktopHNotifyBet = 953, -- 通知切换到下注状态广播
    DesktopHNotifyGameEnd = 954, -- 通知切换到结算状态广播
    DesktopHNotifyRest = 955, -- 通知切换到休息状态广播
    DesktopHNotifyPlayerLeave = 956, -- 通知百人桌内本人离开，20170707
    DesktopHNotifyUpdateBetPotInfo = 957, -- 通知更新各个下注池信息，１秒定时刷新广播
    DesktopHNotifyUpdateSeatPlayerGold = 958, -- 通知更新有座玩家脏数据信息，如金币，１秒定时检测并刷新广播
    DesktopHNotifyUpdateBankPlayer = 959, -- 通知庄家变更，换庄或下庄广播
    DesktopHNotifyUpdateBankPlayerStack = 960, -- 通知庄家变更，Stack变更广播
    DesktopHNotifySeatPlayerChanged = 961, -- 通知更新有座玩家变更，入座，离座，换座广播
    DesktopHNotifyBeBankerPlayerListAdd = 962, -- 通知申请上庄玩家列表Item添加广播
    DesktopHNotifyBeBankerPlayerListRemove = 963, -- 通知申请上庄玩家列表Item删除广播
    DesktopHNotifyPlayerWillStandup = 964, -- 通知玩家由于指定原因，n把后自动离座
    DesktopHNotifyPlayerWillBeNotBank = 965, -- 通知玩家由于指定原因，n把后自动下庄
    DesktopHNotifyPlayerCurrentGiftChanged = 966, -- 通知百人桌内玩家当前礼物变更广播
    DesktopHNotifyPlayerChat = 967, -- 通知百人桌内玩家聊天广播
    DesktopHNotifyBuyAndSendItem = 968, -- 通知百人桌内购买并赠送Item，同时支持临时礼物和魔法表情
    DesktopHResponsePlayerLeave = 969, -- 响应本人离桌，true表示可以立即离开，false表示会延时离开
    DesktopHResponseBetFailed = 970, -- 响应本人下注失败，返回本人当前最新在各个筹码池总下注值
    DesktopHResponseBeBankerPlayer = 971, -- 响应上庄
    DesktopHResponseNotBeBankerPlayer = 972, -- 响应下庄，成为无座玩家
    DesktopHResponseSitdown = 973, -- 响应入座，只能由无座玩家发起
    DesktopHResponseStandup = 974, -- 响应站起，只能由在座玩家发起
    DesktopHResponseGetStandPlayerList = 975, -- 响应获取无座玩家列表
    DesktopHResponseSetCardsType = 976, -- 响应设置牌型
    DesktopHResponseGetWinRewardPotInfo = 977, -- 响应获取奖池开奖信息
    DesktopHResponseInitDailyBetReward = 978, -- 响应获取玩家在各个百人桌中的每日下注奖励的初始化信息
    DesktopHResponseGetDailyBetReward = 979, -- 响应获取玩家在各个百人桌中的每日下注奖励

-- LotteryTicket
    LotteryTicketSnapshot = 1000, -- c->s, 时时彩请求获取快照
    LotteryTicketRequestBet = 1001, -- c->s, 时时彩请求下注
    LotteryTicketRequestBetRepeat = 1002, -- c->s, 时时彩请求重复下注
    LotteryTicketSetCardsType = 1003, -- c->s, 时时彩请求设置牌型
    LotteryTicketGetRewardPotPlayerInfo = 1004, -- c->s, 时时彩请求获取大奖玩家列表
    LotteryTicketChangePlayerState2Simple = 1005, -- c->s, 时时彩请求切换到简单状态

    LotteryTicketNotifyInit = 1030, -- s->c, 时时彩通知，初始化状态
    LotteryTicketNotifyClose = 1031, -- s->c, 时时彩通知，切换到关闭状态
    LotteryTicketNotifyBet = 1032, -- s->c, 时时彩通知，切换到下注状态
    LotteryTicketNotifyGameEndDetail = 1033, -- s->c, 时时彩通知，切换到结算状态
    LotteryTicketNotifyGameEndSimple = 1034, -- s->c, 时时彩通知，切换到结算状态
    LotteryTicketNotifyUpdateBetInfo = 1035, -- s->c, 时时彩通知，更新下注信息
    LotteryTicketResponseSnapshot = 1036, -- s->c, 时时彩响应，获取快照
    LotteryTicketResponseSetCardsType = 1037, -- s->c, 时时彩响应，设置牌型
    LotteryTicketResponseGetRewardPotPlayerInfo = 1038, -- s->c, 时时彩响应，获取大奖玩家列表

-- ForestParty
    ForestPartyRequestEnterDesktop = 1050, -- 请求进入森林舞会
    ForestPartyRequestLeaveDesktop = 1051, -- 请求离开森林舞会
    ForestPartyRequestSnapshot = 1052, -- 请求获取森林舞会快照
    ForestPartyRequestBeBankerPlayer = 1053, -- 请求上庄
    ForestPartyRequestNotBeBankerPlayer = 1054, -- 请求下庄
    ForestPartyRequestBet = 1055, -- 请求下注（属性：筹码Index）
    ForestPartyRequestChangeBetOperate = 1056, --请求改变下注选项
    ForestPartyRequestBetRepeat = 1057, -- 请求重复下注（续压）
    ForestPartyRequestAutoBetRepeat = 1058, --请求自动续压
    ForestPartyRequestGetPlayerList = 1059, -- 请求获取玩家列表
    ForestPartyRequestSetGameResult = 1060, -- 请求设置游戏结果（颜色，颜色的Index和动物类型）
    ForestPartyRequestChat = 1061, -- 请求森林舞会内聊天
    ForestPartyRequestBuyAndSendItem = 1062, -- 请求森林舞会内购买并赠送Item

    ForestPartyNotifySnapshot = 1100, -- 通知森林舞会快照
    ForestPartyNotifyBet = 1101, -- 通知切换到下注状态广播（时间，动物灯倍率id，方块排列）
    ForestPartyNotifyGameEnd = 1102, -- 通知切换到结算状态广播
    ForestPartyNotifyPlayerLeave = 1103, -- 通知森林舞会内本人离开
    ForestPartyNotifyUpdateBetPotInfo = 1104, -- 通知更新各个下注池信息，１秒定时刷新广播 Dictionary<byte, long>，总量
    ForestPartyNotifyUpdateBankPlayer = 1105, -- 通知庄家变更，换庄或下庄广播,内容庄家信息
    ForestPartyNotifyUpdateBankPlayerStack = 1106, -- 通知庄家变更；属性：Stack变更广播（long）
    ForestPartyNotifyBeBankerPlayerListAdd = 1107, -- 通知申请上庄玩家列表Item添加广播
    ForestPartyNotifyBeBankerPlayerListRemove = 1108, -- 通知申请上庄玩家列表Item删除广播
    ForestPartyNotifyPlayerChat = 1109, -- 通知森林舞会内玩家聊天广播
    ForestPartyNotifyBuyAndSendItem = 1110, -- 通知森林舞会内购买并赠送Item，同时支持临时礼物和魔法表情
    ForestPartyResponseEnterDesktop = 1111, --响应进入桌子
    ForestPartyResponsePlayerLeave = 1112, -- 响应本人离桌，true表示可以立即离开，false表示会延时离开
    ForestPartyResponseBetFailed = 1113, -- 响应本人下注失败，返回本人当前最新在各个筹码池总下注值
    ForestPartyResponseBeBankerPlayer = 1114, -- 响应上庄，返回ProtocolResult
    ForestPartyResponseNotBeBankerPlayer = 1115, -- 响应下庄
    ForestPartyResponseGetPlayerList = 1116, -- 响应获取无座玩家列表
    ForestPartyResponseSetGameResult = 1117, -- 响应设置游戏结果
    ForestPartyResponseAutoBetRepeat = 1118, --响应自动续压

    MsgPackPlayerEnd = 19999,
    MsgPackIMBegin = 20000,

    IMAddFriendReqRequest = 20001, -- c->s，请求添加好友
    IMAddFriendReqRequestResult = 20002, -- s->c，请求添加好友返回
    IMAddFriendResRequest = 20003, -- c->s，请求处理添加好友
    IMAddFriendResRequestResult = 20004, -- s->c，请求处理添加好友返回
    IMDeleteFriendRequest = 20005, -- c->s, 请求删除好友
    IMDeleteFriendRequestResult = 20006, -- s->c, 请求删除好友返回
    IMFriendLoginNotify = 20007, -- s->c, 好友上线通知
    IMFriendLogoutNotify = 20008, -- s->c, 好友下线通知
    IMFriendInfoCommonUpdateNotify = 20009, -- s->c, 好友通用信息更新通知
    IMFriendInfoMoreUpdateNotify = 20010, -- s->c, 好友详细信息更新通知
    IMFriendInfoRealtimeUpdateNotify = 20011, -- s->c, 好友实时信息更新通知
    IMFriendListAddNotify = 20012, -- s->c, 好友列表（详细）推送给Client的通知，每秒最多10个
    IMFriendListRemoveNotify = 20013, -- s->c, 好友列表，删好友，推送给Client的通知
    IMFriendGoldUpdateNotify = 20014, -- s->c, 好友Gold更新通知

    IMFindFriendRequest = 20100, -- c->s, 搜索好友请求
    IMFindFriendNotify = 20101, -- s->c, 搜索好友通知
    IMRecommandFriendNotify = 20102, -- s->c, 推荐好友通知

    IMEventPush2ClientNotify = 20150, -- s->c, 好友在离线事件推送给Client的通知
    IMEventClientConfirm = 20151, -- 离线事件，Client确认处理

    IMChatReadConfirmRequest = 20200, -- c->s, 好友消息已读确认
    IMChatSendMsgRequest = 20201, -- c->s, 发送私聊
    IMChatRecvMsgNotify = 20202, -- s->c, 私聊通知，两人同时收到
    IMChatRecvBatchMsgNotify = 20203, -- s->c, 私聊批量通知，两人同时收到
    IMChatRecordRequest = 20204, -- 请求拉取聊天记录，本地聊天记录可以删除，服务端永久保留
    IMChatRecordRequestResult = 20205, -- 响应拉取聊天记录，本地聊天记录可以删除，服务端永久保留

    IMMailListInitNotify = 20250, -- s->c, 邮件列表初始化，推送给Client的通知
    IMMailOperateRequest = 20251, -- c->s, 请求邮件操作，已读，领取附件，删除
    IMMailOperateRequestResult = 20252, -- s->c, 响应请求邮件操作
    IMMailAddNotify = 20253, -- s->c, 邮件新增通知
    IMMailDeleteNotify = 20254, -- s->c, 邮件删除通知
    IMMailUpdateNotify = 20255, -- s->c, 邮件更新通知

    IMMarqueeNotify = 20300, -- 跑马灯广播推送

    MsgPackIMEnd = 20999,
}

ProtocolResult = {
    Success = 0, -- 通用，成功
    Failed = 1, -- 失败
    Exist = 2, -- 已存在
    Timeout = 3, -- 超时
    DbError = 4, -- 通用，数据库内部错误

    LogoutNewLogin = 5, -- 重复登录，踢出前一帐号

    EnterWorldFailed = 6, -- 角色进入游戏，失败
    EnterWorldAccountVerifyFailed = 7, -- 角色进入游戏，帐号验证失败
    EnterWorldTokenError = 8, -- 角色进入游戏，Token错误
    EnterWorldTokenExpire = 9, -- 角色进入游戏，Token过期
    EnterWorldNotExistPlayer = 10, -- 角色进入游戏，角色不存在
    EnterWorldAlready = 11, -- 角色进入游戏，已经进入世界
    EnterWorldCreatePlayerFailed = 12, -- 角色进入游戏，创建角色失败

    BagFull = 13, -- 背包满

    FriendExistFriend = 14, -- 好友已存在，不可以重复添加
    FriendIsMe = 15, -- 不可以添加自己为好友

    GiveChipNotEnoughChip = 16, -- 本人筹码不足100W
    GiveChipMoreThanMine = 17, -- 赠送筹码超过本人拥有
    GiveChipTooSmall = 18, -- 赠送筹码值过小，不合法
    GiveChipBeyondTheLimit = 19, -- 赠送筹码超过每日10W限额
    PushStackCanntInGame = 20, -- 下注游戏不可以在游戏中进行
    PushStackChipError = 21, -- 下注游戏错误，筹码异常

    ChipNotEnough = 22, -- 筹码不足
    ChipNimiety = 23, --筹码过多
    DiamondNotEnough = 24, -- 钻石不够
    PointNotEnough = 50, -- 积分不足
    MatchTexasNotExist = 100, -- 德州赛事，不存在
    MatchTexasNotEnoughGold = 101, -- 德州赛事，金币不够（如报名费不够导致报名失败等）
    MatchTexasNotSignUp = 102, -- 德州赛事，该玩家未报名
    MatchTexasTimeOver = 103, -- 德州赛事，已超时，无法执行某件事
    MatchTexasExist = 104,-- 德州赛事，已存在，如玩家已报名
    MatchTexasNotEnoughPlayer = 105, -- 德州赛事，参赛玩家不足
    MatchTexasPlayerNumMax = 106,-- 德州赛事，比赛人数超过上限
    MatchTexasMatchEnd = 107,-- 德州赛事，比赛已经结束
}

CasinosModule = {
    Fishing = 0, -- 捕鱼
    GFlower = 1, -- 炸金花
    Texas = 2, -- 德州
    NiuNiu = 3, -- 牛牛
    ZhongFB = 4, -- 中发白
    ForestParty = 5,
}

ProjectType = {
}

MagicExpLimit = {
    NormalPlayer = 0,
    VIPPlayer = 1,
}

DesktopTypeEx = {
    Desktop = 0,
    DesktopH = 1,
    DesktopMatch = 2,
}

_eMagicExpMoveType = {
    Rotate = 0,
    Line = 1,
}

_eUiChatType = {
    Desktop = 0,
    DesktopH = 1,
}

PresetMsgType = {
    Desktop = 0,
    DesktopH = 1,
}

_eFriendStateClient =
{
    Offline = 0,
    Fishing = 1,
    GFlowerDesktopH = 2,
    GFlowerDesktopPrivate = 3,
    GFlowerDesktopNormal = 4,
    TexasDesktopClassicPrivate = 5,
    TexasDesktopClassic = 6,
    TexasDesktopMustBet = 7,
    TexasDesktopMustBetPrivate = 8,
    TexasDesktopH = 9,
    NiuNiuDesktopH = 10,
    ZhongFBDesktopH = 11,
    NotInDesktop = 12,
    DesktopMatch = 13,
}

--银行操作通知
CardData = {}
function CardData:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.suit = 0
    o.type = 0
    return o
end

function CardData:setData(data)
    self.suit = data[1]
    self.type = data[2]
end

function CardData:getData4Pack()
    local p_d = {}
    table.insert(p_d, self.suit)
    table.insert(p_d, self.type)

    return p_d
end

ShareType = {
    WeChat = 0,
    WeChatMoments = 1,
}