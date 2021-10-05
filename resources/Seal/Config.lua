DiscordWebhookSystemInfos = 'https://discordapp.com/api/webhooks/631945745032806409/OCGUg4MDFYhcCx1sjarO2VwV1dhZfmSJk0SUAoopOFK8NShGVtpfAwbjUcQMEw-aJWHC'
DiscordWebhookKillinglogs = 'https://discordapp.com/api/webhooks/631945071519989792/7wt-QhU5WH2TBA8NJsmS8VPzoX-GMD82lDC7B6Zh6CxNH0rMTm19SHPUv5Y8QMQflJIe'
DiscordWebhookChat = 'https://discordapp.com/api/webhooks/631945618566152236/smce_UjsmuKDkUDcrdEBiNlJ8q1xFa6rKEQxqnTZqfK5Z3KQCx8XGBgQgYp1CA3zTiOD'
DiscordWebhookMeh = 'https://discordapp.com/api/webhooks/638872002760802304/O-N9YBbfNmotJPMBIlF3ujzSmlk2YuanMeS3lWjplNuzf18BPqV8bUGBOz-glPt5bby7'

SystemAvatar = 'https://purepng.com/public/uploads/large/purepng.com-sealanimalssealsea-lion-981524671319vlofh.png'

UserAvatar = 'https://purepng.com/public/uploads/large/purepng.com-sealanimalssealsea-lion-981524671319vlofh.png'

SystemName = 'SEAL'


--[[ Special Commands formatting
		 *YOUR_TEXT*			--> Make Text Italics in Discord
		**YOUR_TEXT**			--> Make Text Bold in Discord
	   ***YOUR_TEXT***			--> Make Text Italics & Bold in Discord
		__YOUR_TEXT__			--> Underline Text in Discord
	   __*YOUR_TEXT*__			--> Underline Text and make it Italics in Discord
	  __**YOUR_TEXT**__			--> Underline Text and make it Bold in Discord
	 __***YOUR_TEXT***__		--> Underline Text and make it Italics & Bold in Discord
		~~YOUR_TEXT~~			--> Strikethrough Text in Discord
]]
-- Use 'USERNAME_NEEDED_HERE' without the quotes if you need a Users Name in a special command
-- Use 'USERID_NEEDED_HERE' without the quotes if you need a Users ID in a special command


-- These special commands will be printed differently in discord, depending on what you set it to
SpecialCommands = {
				   {'/ooc', '**[OOC]:**'},
				   {'/911', '**[911]: (CALLER ID: [ USERNAME_NEEDED_HERE | USERID_NEEDED_HERE ])**'},
				  }

						
-- These blacklisted commands will not be printed in discord
BlacklistedCommands = {
					   '/AnyCommand',
					   '/AnyCommand2',
					  }

-- These Commands will use their own webhook
OwnWebhookCommands = {
					  {'/AnotherCommand', 'WEBHOOK_LINK_HERE'},
					  {'/AnotherCommand2', 'WEBHOOK_LINK_HERE'},
					 }

-- These Commands will be sent as TTS messages
TTSCommands = {
			   '/Whatever',
			   '/Whatever2',
			  }

