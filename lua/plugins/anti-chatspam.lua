

PLUGIN.Name = "Anti Chat-Spam"
PLUGIN.Category = "Core"
PLUGIN.Info = "Stops Chat people chat-spamming"
PLUGIN.Usage = "Don't spam"

local hook = hook

PLUGIN.Max = 3

function PLUGIN.Speak( pl, text )
	if !pl.ChatSpam then pl.ChatSpam = { } end
	if !pl.ChatSpam.Phrase then pl.ChatSpam.Phrase = "" end
	if !pl.ChatSpam.Times then pl.ChatSpam.Times = 0 end
	
	local phrase = pl.ChatSpam.Phrase
	local times = pl.ChatSpam.Times
	
	if text == phrase then
		times = times + 1
		if times == PLUGIN.Max then
			pl:Kick( "He Spammed " .. phrase )
			print( pl:Nick() .. " spammed " .. phrase .." " .. PLUGIN.Max .. " times and got kicked" )
		end
	else
		times = 0
		phrase = text
	end
	
	pl.ChatSpam.Phrase = phrase
	pl.ChatSpam.Times = times
end
	

function PLUGIN.Init()

	hook.Add( "PlayerSay", "Plugins.AntiChatSpam", PLUGIN.Speak )

end

function PLUGIN.Shared()
end

function PLUGIN.Cl_init()
end