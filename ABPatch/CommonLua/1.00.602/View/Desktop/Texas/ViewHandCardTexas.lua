ViewHandCardTexas = ViewBase:new()

function ViewHandCardTexas:new(o, com_card, guid, index)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.Guid = guid
    o.Index = index
    o.GComCard = com_card
    o.CardData = nil
    o.CancelShowCard = false
    o.ShowBack = false
    local loader_card = o.GComCard:GetChild("LoaderCard")
    if (loader_card ~= nil)
    then
        o.GLoaderCard = CS.Casinos.LuaHelper.GLoaderCastToGLoaderEx(loader_card.asLoader)
        o.GImageCardBack = o.GComCard:GetChild("CardBack").asImage
    end
    local card_highlight = o.GComCard:GetChild("ImageCardHighLight")
    if (card_highlight ~= nil)
    then
        o.GImageCardHighLight = card_highlight.asImage
    end
    o.TweenerScale = nil
    o.LoaderTicket = nil

    return o
end

function ViewHandCardTexas:setCardData(card_data)
    if (self.GLoaderCard == nil)
    then
        return
    end
    if self.CardData ~= nil and card_data == nil then
        self.CancelShowCard = true
    elseif self.CardData == nil and card_data ~= nil then
        self.CancelShowCard = false
    elseif self.CardData == nil and card_data == nil then
        self.ShowBack = true
    end
    self.CardData = card_data
end

function ViewHandCardTexas:setShowCardData(card_data)
    if (self.GLoaderCard == nil)
    then
        return
    end
    self.ShowCardData = card_data
end

function ViewHandCardTexas:showCard(delay_tm)
    if self.CancelShowCard then
        ViewHelper:setGObjectVisible(true, self.GComCard)
        ViewHelper:setGObjectVisible(false, self.GImageCardBack)
        self.TweenerRotate = CS.Casinos.UiDoTweenHelper.TweenRotateY(self.GLoaderCard, 0, 90, UiCardCommonEx.RotateTime):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(
                function()
                    ViewHelper:setGObjectVisible(true, self.GImageCardBack)
                    ViewHelper:setGObjectVisible(false, self.GLoaderCard)
                    self.GImageCardBack.rotationY = 90
                    self.GLoaderCard.rotationY = 90
                    self.TweenerRotate = CS.Casinos.UiDoTweenHelper.TweenRotateY(self.GImageCardBack, 90, 180, UiCardCommonEx.RotateTime):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(
                            function()
                                self.GImageCardBack.rotationY = 180
                            end
                    )
                end
        )
    else
        if self.ShowBack then
            ViewHelper:setGObjectVisible(true, self.GComCard)
            ViewHelper:setGObjectVisible(true, self.GImageCardBack)
            ViewHelper:setGObjectVisible(false, self.GLoaderCard)
        else
            if (self.CardData == nil)
            then
                return
            end

            local card_resouce_name = self.CardData.suit .. "_" .. self.CardData.type

            local l_card_resouce_name = string.lower(card_resouce_name)
            if (CS.System.String.IsNullOrEmpty(card_resouce_name) == false)
            then
                self.LoaderTicket = CS.Casinos.CasinosContext.Instance.TextureMgr:getTexture(l_card_resouce_name, CS.Casinos.CasinosContext.Instance.PathMgr:combinePersistentDataPath(CS.Casinos.UiHelperCasinos.getABCardResourceTitlePath() .. l_card_resouce_name .. ".ab"),
                        function(ticket, t)
                            if (self.GComCard == nil or self.GComCard.displayObject.gameObject == nil)
                            then
                                return
                            end

                            if (self.LoaderTicket ~= ticket)
                            then
                                return
                            end
                            self.LoaderTicket = nil

                            self.GLoaderCard.texture = CS.FairyGUI.NTexture(t)
                            ViewHelper:setGObjectVisible(true, self.GComCard)
                            ViewHelper:setGObjectVisible(true, self.GImageCardBack)

                            self.TweenerRotate = CS.Casinos.UiDoTweenHelper.TweenRotateY(self.GImageCardBack, 180, 90, UiCardCommonEx.RotateTime):SetDelay(delay_tm):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(
                                    function()
                                        ViewHelper:setGObjectVisible(false, self.GImageCardBack)
                                        ViewHelper:setGObjectVisible(true, self.GLoaderCard)
                                        self.GImageCardBack.rotationY = 180
                                        self.GLoaderCard.rotationY = 90
                                        self.TweenerRotate = CS.Casinos.UiDoTweenHelper.TweenRotateY(self.GLoaderCard, 90, 0, UiCardCommonEx.RotateTime):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(
                                                function()
                                                    self.GLoaderCard.rotationY = 0
                                                end
                                        )
                                    end
                            )
                        end
                )
            end
        end
    end
end

function ViewHandCardTexas:hideCard()
    self.GLoaderCard.icon = nil
    ViewHelper:setGObjectVisible(false, self.GComCard)
end

function ViewHandCardTexas:resetCard(with_ani)
    self.GLoaderCard.icon = nil
    self.GLoaderCard.color = CS.UnityEngine.Color.white
    self.GImageCardBack.rotationY = 180
    self.GLoaderCard.rotationY = 0
    self.CardData = nil
    self.CancelShowCard = false
    self.ShowBack = false
    ViewHelper:setGObjectVisible(false, self.GLoaderCard)
    ViewHelper:setGObjectVisible(false, self.GImageCardBack)
    ViewHelper:setGObjectVisible(false, self.GImageCardHighLight)
end

function ViewHandCardTexas:showHighLight(show_highlight,not_dark)
    ViewHelper:setGObjectVisible(show_highlight, self.GImageCardHighLight)
    if (not_dark == false)
    then
        self.GLoaderCard.color = CS.UnityEngine.Color.gray
    else
        self.GLoaderCard.color = CS.UnityEngine.Color.white
    end
end

function ViewHandCardTexas:hideHighLight()
    ViewHelper:setGObjectVisible(false, self.GImageCardHighLight)
    self.GLoaderCard.color = CS.UnityEngine.Color.white
end

function ViewHandCardTexas:killTween(tweener, is_complete)
    if (tweener ~= nil)
    then
        tweener:Kill(is_complete)
        tweener = nil
    end
end