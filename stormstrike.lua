
local errorCount = 0;
local ErrorRotationChecker = CreateFrame("Frame")
ErrorRotationChecker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
ErrorRotationChecker:RegisterEvent("PLAYER_REGEN_ENABLED");

ErrorRotationChecker:SetScript("OnEvent",
function(self, event,...)
CheckError(event, ...)
end)

function CheckError(event, ...)
    local sourceName = select(5,...);
    if(event=="PLAYER_REGEN_ENABLED") then
      DEFAULT_CHAT_FRAME:AddMessage("You just ended the fight with " .. errorCount .. " errors");
      errorCount = 0;


    elseif(event=="COMBAT_LOG_EVENT_UNFILTERED") then

      if(sourceName ~= "Isaaclol" or select(2,...) ~= "SPELL_DAMAGE") then
        return;
      end

      local power = UnitPower("player" , 11);
      local sourceName = select(5,...);
      local spellId, spellName, spellSchool = select(12,...);

      if(spellName == "Stormstrike" or spellName == "Lava Lash") then
        local ftDuration = select(7,UnitAura("player", "Flametongue", nil, "HELPFUL"));
        local fbDuration = select(7,UnitAura("player", "Frostbrand", nil, "HELPFUL"));
        local bfDuration = select(7,UnitAura("player", "Boulderfist", nil, "HELPFUL"));
        if(ftDuration ~= nil) then
          ftDuration = ftDuration - GetTime();
        end
        if(fbDuration ~= nil) then
          fbDuration = fbDuration - GetTime();
        end
        if(bfDuration ~= nil) then
          bfDuration = bfDuration - GetTime();
        end;
        if(ftDuration == nil or ftDuration < 1.5 or fbDuration == nil or fbDuration < 1.5 or bfDuration == nil or bfDuration < 1.5) then
          errorCount = errorCount + 1;
          DEFAULT_CHAT_FRAME:AddMessage("Error! You cast " .. spellName .. " when you shouldn't have!" );

        end
      end
      if(spellName == "Lava Lash" and power < 20) then

        DEFAULT_CHAT_FRAME:AddMessage(power .. sourceName);
        errorCount = errorCount + 1;
        DEFAULT_CHAT_FRAME:AddMessage("Error! You cast Lava Lash when you didn't have more maelstrom.");
      end
    end
end
