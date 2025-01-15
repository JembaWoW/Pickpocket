if PickpocketDisabled then return end

local Pickpocketed = {}

function Pickpocket_OnTooltipShown()

    local _,GUID = UnitExists("mouseover")

    -- Make sure the unit is not another player, and we can attack it
    if GUID then
        if UnitIsPlayer("mouseover") or not UnitCanAttack("player", "mouseover") or (UnitCreatureType("mouseover") ~= "Humanoid" and UnitCreatureType("mouseover") ~= "Undead") then
            return
        end

        if Pickpocketed[GUID] then
            GameTooltip:AddLine(" ");
            GameTooltip:AddLine("Pickpocketed",1,0,0);
            -- Force refresh GameTooltip size
            GameTooltip:Show()
        else
            GameTooltip:AddLine(" ");
            GameTooltip:AddLine("Not Pickpocketed",0,1,0);
            -- Force refresh GameTooltip size
            GameTooltip:Show()
        end
    end
end

local pickpocketTooltip = CreateFrame("Frame", nil, GameTooltip)
pickpocketTooltip:SetScript("OnShow", Pickpocket_OnTooltipShown)

local CastSpellByNameOriginal = CastSpellByName

function CastSpellByName(name,onself)
    if name == "Pick Pocket" then
        local unit = nil
        if UnitExists("target") then unit = "target" end

        local _,GUID = UnitExists(unit)

        if GUID then
            Pickpocketed[GUID] = true
        end

    end
    CastSpellByNameOriginal(name,onself)
end

UseActionOriginal = UseAction
function UseAction(slot,checkCursor,onSelf)

    local texture = GetActionTexture(slot)
    if texture == "Interface\\Icons\\INV_Misc_Bag_11" and not GetActionText(slot) and IsActionInRange(slot) == 1 then
        local unit = nil
        if UnitExists("target") then unit = "target" end

        local _,GUID = UnitExists(unit)

        if GUID then
            Pickpocketed[GUID] = true
        end

    end

    UseActionOriginal(slot,checkCursor,onSelf)
end


if not GetPlayerBuffID or not CombatLogAdd or not SpellInfo then
    local notify = CreateFrame("Frame", nil, UIParent)
    notify:SetScript("OnUpdate", function()
        DEFAULT_CHAT_FRAME:AddMessage("|cffff4d70Pickpocket: Could not detect SuperWoW.")
        this:Hide()
    end)

  PickpocketDisabled = true
end

SLASH_PICKPOCKET1, SLASH_PICKPOCKET2 = "/pp", "/pickpocket"
SlashCmdList["PICKPOCKET"] = function(msg)
    if msg == "reset" then
        Pickpocketed = {}
        DEFAULT_CHAT_FRAME:AddMessage("|cffff4d70Pickpocket: All pickpocket information has been reset.")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cffff4d70Pickpocket")
        DEFAULT_CHAT_FRAME:AddMessage("|cffff4d70/pp reset")
        DEFAULT_CHAT_FRAME:AddMessage("|cffff4d70/pickpocket reset")
    end
end
