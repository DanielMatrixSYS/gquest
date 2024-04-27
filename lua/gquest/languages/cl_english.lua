--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

gQuest.Languages["en"] = 
{
    -- Main
        thisLanguage = "English",
    --

    -- UI
        uiName = "Name",
        uiModel = "Model",
        uiPosition = "Position",
        uiAngle = "Angle",
        uiQuests = "Quests",
        uiUseIcons = "Use Icons",
        uiIcons = "Icons",
        uiCreate = "Create NPC",
        uiEntity = "Entity",
        uiID = "ID",
        uiFilledOut = "One or more of the entries above needs to be filled out.",
        uiNameLengthReached = "Name can not contain more than 75 characters.\nCurrent Character Count: %s",
        uiGeneralInformation = "General Information",
        uiQuestCreation = "Quest Creation",
        uiQuestInformation = "Quest Information",
        uiError = "ERROR",
        uiNPCS = "Quest NPC Editor",
        uiCreateNewNPC = "Create A New NPC",
        uiCreateNewNPCDesc = "Create a new NPC that will hold quests.",
        uiEditNPCS = "Edit An Existing NPC",
        uiEditNPCSDesc = "Edit what the NPC looks like, its header, colors, etc!",
        uiDeleteNPC = "Delete An NPC",
        uiDeleteNPCDesc = "Delete one or more NPCS, this is a permanent solution.",
        uiSaveChanges = "Save All NPC Changes?",
        uiSaveChangesDesc = "Saves the NPCS and respawns them with the saved values.\nYou can not undo this once you save.",
        uiSaveAllNPCS = "Save All NPCS",
        uiSaveAllNPCSDesc = "Saves their current position, angles and whatnot.",
        uiSaveAllHeader = "Save all NPCS?",
        uiSaveAllHeaderDesc = "If you have a lot of npcs then there is a chance that there will be some minor lag while saving, lag, if any, will only last for a couple of seconds.\nAll NPCS will be saved in their current state.\nMake sure all the NPCS are where they're suppose to be.",
        uiSaveAllAccept = "Save",
        uiRespawnAllNPCS = "Reload NPCS",
        uiRespawnAllNPCSDesc = "Respawns all NPCS.",
        uiRespawnNPCSHeader = "Respawn NPCS?",
        uiRespawnNPCSHeaderDesc = "This will remove all NPCS on the map then respawn them. Having a lot of npcs can cause some server lag while spawning them.\nLag, if any, will only occur for a couple seconds.",
        uiDespawnNPCS = "Remove NPCS From Map",
        uiDespawnNPCSDesc = "Despawns all NPCS.",
        uiDespawnNPCSHeaderDesc = "This will remove all NPCS on the map. They will appear again on map change/server restart or when you respawn them manually.",
        uiCreateNewQuest = "Create New Quest",
        uiCreateNewQuestDesc = "Create quests for people to do!",
        uiStats = "Stats",
        uiSettings = "Settings",
        uiQuestsDesc = "Create, edit or remove quests.",
        uiNPCSDesc = "Create, edit or remove npcs.",
        uiItems = "Items",
        uiItemsDesc = "Create, edit or remove items.",
        uiPlayerStats = "Player Stats",
        uiPlayerStatsDesc = "Display player quests, how many completed, etc",
        uiHelp = "Quest Guidance",
        uiHelpDesc = "Explains how things work.",
        uiAdmin = "Admin Settings",
        uiAdminDesc = "Enable/Disable Admin things in here.",
        uiConfig = "Config",
        uiConfigDesc = "Edit numbers and booleans in here.",
        uiContinue = "Continue",
        uiDecline = "Decline",
        uiQuestNPCDeletion = "Quest NPC Deletion.",
        uiQuestDeleteDesc = "What NPCS would you like to permanently remove from your server? Seperate with commas, e.g\n1,2,3",
        uiQuestDelete = "Delete",
        uiSuccess = "Success",
        uiBanned = "Entity name contains banned characters.",
        uiSuccessCreated = "Successfully created: %s",

        -- Help Page
            uiHelpHelp = "Help Page",
            uiHelpUnderstand = "Understand how quests work.",
            uiHelpObjectives = "Objectives",
            uiHelpUnderstandObjectives = "Understand how quest objectives work.",
            uiHelpQuestNPCS = "Quest NPCS",
            uiHelpUnderstandNPCS = "Understand how quest npcs work.",
            uiHelpYOutube = "Youtube Videos",
            uiHelpVisual = "Want a visual representation?",
            uiHelpInfo = "Information",
            uiHelpPageQuests = "If you're looking to create quests then you should look at my youtube video as that explains how.\n\nIn this article I will explain to you how quests work.\n\nOnce a player accepts a quest then, depending on the quest, we'll spawn the objectives for the quest, the quest he accepts gets automatically tracked by our quest tracker and he can then run towards the objectives and do them.\n\nOnce the player has done the quest then he can deliver it to the same NPC he got it from.\n\nPlayers are able to abandon the quest once they've accepted it, through the quest log or npc.",
            uiHelpPageObjectives = "Once a player accepts a quest then we'll spawn the quest objectives for that quest, and that quest only.\n\nQuest Objectives respawn after 60 seconds after they've been either removed or killed.\n\nQuest Objectives will not respawn if there are no players with the quest online.\n\nQuest Objectives are only spawned if they have not been spawned before.\n\nNow I will explain to you what the variables means when you're creating objectives.\n\nEntity: What entity should we spawn? This needs to a valid entity like, npc_zombie. This can only contain one entity and not several like in the quests variable.\nQuests: What quests should these objectives be used for? You can have multiple but it is adviced to have 1 quest. Seperate by commas, e.g 1,2,3\nPosition: The position the quest objective will spawn, this is where you are currently standing.\nAngle: The angle the quest objective will spawn at.",
            uiHelpPageNPCS = "You're able to create quest npcs through our menu which can be accessed with the command !gquest, however, since you're reading this then you probably know this.\n\nHere is what the variables mean when you create a quest npc.\n\nName: The name of the NPC which will be displayed above them.\nModel: The model the npc will have.\nPosition: The position the npc will hold.\nAngle: The angles the npc will hold.\n\nOnce you have created an npc you can then type !gquest again to bring up the menu, then select the edit tool and then you'll be able to find the NPC ID which is crucial when you're creating quests.\n\nNPCS can be edited, deleted and whatever else, whoever has access to this menu can do everything.",
            uiHelpPageYoutube = "All youtube videos can be found on either the gQuest GmodStore page or in the README.txt file which is included within the purchase.",
        --

        -- Notifications
            uiNotificationCreated = "Created NPC:",
            uiNotificationRespawn = "Respawned All NPCS",
            uiNotificationDespawned = "Despawned All NPCS",
            uiNotificationSaveNPCS = "Saved All NPCS",
            uiNotificationChangesSaved = "Changes Saved",
            uiNotificationDeleteNPCS = "Deleted Selected NPCS",
            uiNotificationQuestFailed = "Quest Failed:",
            uiNotificationAbandoned = "Quest Abandoned:",
            uiNotificationAccepted = "Quest Accepted:",
            uiNotificationCompleted = "Quest Completed:",
            uiNotificationDelivered = "Quest Delivered:",
            uiNotificationAbandonedDueToJob = "Quest Abandoned Due To Incorrect Job:",
        --

        -- Objectives
            objObjectives = "Objectives",
            objCreate = "Create Objectives",
            objCreateDesc = "Create new objective(s) for our quests.",
            objEdit = "Edit Objectives",
            objEditDesc = "Edit existing objective(s).",
            objDelete = "Delete Objectives",
            objDeleteDesc = "Delete quest objectives here.",
            objDeleteHeader = "Objective Deletion.",
            objDeleteHeaderDesc = "What objectives would you like to permanently remove from your server? Seperate with commas, e.g\n1,2,3",
            objQuest = "Quest Objectives Editor",
            objPlace = "Place or remove quest objectives here.",
        --
        
        -- NPC
            npcAbandon = "Abandon Quest",
            npcHeaderAbandon = "Abandon Quest?",
            npcDesc = "All progress you've made for this quest will be lost if you abandon it.\nAre you sure you want to abandon %s?",
            npcAbandonIt = "Abandon it",
            npcNever = "Nevermind",
            npcQuest = "Quest Description",
            npcObj = "Quest Objective",
            npcRewards = "Quest Rewards",
            npcDeliver = "Deliver Quest",
            npcCompleted = "Quest Completed",
            npcCooldown = "Quest is on cooldown: %s remaining",
            npcAccept = "Accept Quest",
        --

        -- Log
            logNoQuests = "you have no quests",
            logTrack = "Track Quest.",
            logUnTrack = "Untrack Quest.",
            logNoLonger = "No Longer Tracking:",
            LogTracking = "Now Tracking:",
        --

        -- DB
            dbQuest = "View the Quest Database",
            dbQuestDesc = "Do database things in here.",
            dbDatabase = "Player Database",
            dbDatabase2 = "Quest Database",
            dbRemoveAcceptedQuests = "Remove Accepted Quests",
            dbRemoveAcceptedQuestsDesc = "Remove Quests From Player.",
            dbViewQuests = "View Quests",
            dbViewQuestsDesc = "View all of the quests any user has completed/taken",
            dbRefreshQuests = "Quest Refresh",
            dbRefreshQuestsDesc = "Force a quest refresh on all players.",
            dbRefreshQuestsDescExtra = "Forcing a quest refresh on all players can cost a lot of server resources, this should only be used by a developer developing quests.\n\nYou need superadmin privileges to use this.",
            dbPlayers = "Select A Player",
            dbSearch = "Player Search",
            dbSearchDesc = "Search for a player by their in-game name or steamid.",
            dbSearchText = "Search",
            dbSearchResult = "Search Result",
            dbSearchResultError = "Couldn't find anyone with the given parameters.",
            dbSearchOk = "Ok",
            dbSearchResultErrorPlayers = "There were too many results with the given parameters, please be more specific.",
            dbRemove = "Remove Quests",
            dbRemoveDesc = "What quests would you like to remove from %s? Seperate with commas.",
            dbRemoveButton = "Remove",
            dbRemoveNotifyHeader = "An Administrator Has Removed Your Quest:",
            dbNotAccepted = "This Player Does Not Have Quest:",
            dbRemoved = "Successfully Removed Quest:",
            dbClear = "Delete Quest Database",
            dbClearDesc = "Deletes all data regarding quests.",
            dbClearNotify = "Delete Data?",
            dbClearNotifyDesc = "Deleting all quest data will require a quick map change, this will also delete progress towards any quest. This is a permanent solution.",
            dbClearNPCS = "Delete NPC Database",
            dbClearNPCSDesc = "Deletes all of our saved npcs.",
            dbClearNPCSHeaderDsec = "Deleting all of the questing npcs is a permanent solution. This can not be undone. This requires a map change.",
            dbClearObj = "Delete Objective Database",
            dbClearObjDesc = "Deletes all of our saved objectives.",
            dbClearObjNotifyDesc = "Deleting all of the objectives from the the database is a permanent solution. This requires a map change.",
        
            dbClearAll = "Delete All Quest Data?",
            dbClearAllDesc = "Deletes all of gQuest data.",
            dbClearAllNotifyDesc = "Deleting all of the data from the the database is a permanent solution. This requires a map change.",
        --

        -- Other
            otherText = "Remember, you can press L to keep track of your current quests and its progression.",
        --

        -- Update 030818 or >
            uiNotificationPlayerNotValidHeader = "Player Is Invalid!",
            uiNotificationPlayerNotValidDesc = "It would seem that your selected player has left the server.",

            CurrentQuests = "Quests taken.",
            QuestObjectives = "Quest objectives.",
            QuestCooldowns = "Quests that are completed but on cooldown.",
            CompletedQuests = "Quests that are completed.",
            QuestsForDeliver = "Quests ready to be delivered.",

            -- Update 060818
                questObjectiveStats = "This user has gathered %i objectives out of %i for this quest.",
                questAcceptedStats  = "This user has accepted this quest.",
                questCompletedStats = "This quest has been completed & delivered.",
                questsDeliverStats = "This quest has been completed but not delivered.",
                questsCooldownStats = "This quest has been completed and set on cooldown. Unlocked again in %s",
            --

            -- Update 070818
                uiNotificationForcedComplete = "An administrator has force completed your quest:",
                uiNotificationForcedRemoved = "An administrator has force removed your quest:",
                uiNotificationForcedRemovedCD = "An administrator has force removed your CD'd quest:",
            --

            -- Update 100818
                uiHeader = "Header",
                uiSubHeader = "Sub Header",
            --

            -- 110818
                dbSelectNPC = "Select An NPC To Edit",
                dbDeleteNPC = "NPC Deletion",
                dbDeleteNPCS = "Delete Selected NPCS",
            --

            -- 120818
                dbConvertHeader = "Convert Old Data",
                dbConvertDesc = "An update is required for the NPC database.\nPlease update or errors will occur.",
                dbConvertAccept = "Update",

                npcHeaderColor = "Header Color",
                npcSubHeaderColor = "Sub Header Color",

                editSearch = "Search...",
            --

            -- 140818
                editNPCID = "NPC ID",
            --

            -- 170818
                uiUIDenied = "You don't have access to this command:",
                npcEditRoutes = "Edit NPC Routes",
                npcEditRoutsDesc = "Edit walking route the npc should take.",
                npcEditRouteCreate = "Add Current Position As Point",
                npcEditRouteHeader = "Add or Remove Patrol Points",
                npcEditRouteRemove = "Remove All Current Points",
            --
            
            -- 180818
                npcEditRouteNAVHeader = "Missing Requirements",
                npcEditRouteNAVDesc = "This server does not have the correct NAV file for this map.\nWe will be unable to use this part of the system.",
                npcEditRouteNAVOk = "Ok",

                npcDisablePatrol = "Disable Patrol System",
                npcEnablePatrol = "Enable Patrol System",
                npcDisablePatrolDesc = "Should we disable the walking mechanism for npcs?",
                npcEnablePatrolDesc = "Should we enable the walking mechanism for npcs?",

                npcEditBeforeHeader = "Please Read",
                npcEditBeforeDesc = "Please disable the Patroling System before you edit or create new npc's",

                uiVisualAid = "Developer Tools",
                uiVisualAidDesc = "Let's you see things in-game like, npc patrol route, etc.",
            --
            
            -- 190818
                helpPagePatrol = "Patrol System",
                helpPagePatrolDesc = "Not sure how it works? Click me!",
                helpPagePatrolHelp = "Open up the menu and find the 'Edit NPC Routes' option, then, select the npc you want to make walk.\n\nOnce you've made it this far then all you have to do is click on the 'Add Current Position As Point' Button, this will mark your current location as a point the NPC needs to walk to.\n\nYou can have as many points as you want, but a minimum of 2.\n\nIf you want a visual representation then please look at the youtube video.\n\nLink to the youtube video can be found in one of the text files which are provided within the zip file of the purchase.",
            
                visualAidPatrol = "Patrol Marker",
                visualAidPatrolDesc = "Creates a visual representation of the npcs route.",

                visualAidNPC = "NPC Helper",
                visualAidNPCDesc = "Shows you relevant information about the NPC.",
            --

            -- 280818
                routeRemoveSelected = "Remove %i Selected Points",
            --

            -- 290818
                routeNotificationHeader = "Are you sure?",
                routeNotificationDesc = "Are you sure you want to delete these points?",
            --

            -- 220918
                uiNotificationTimeLimit = "This quest needs to be completed within a time limit\nPress L to show time left.",
                uiNotificationQuestFailedDueToTime = "Failed due to time limit reached.",
            --
            
            -- 280119
                uiNotificationAutoComplete = "Quest Completed & Delivered.",
            --

            -- 300119
                dbImportExport = "Import/Export Data",
                dbImportExportDesc = "Import or Export data for multiple servers.",
                dbImportExportNotificationHeader = "Import or Export",
                dbImportExportNotificationDesc = "Are we importing or exporting data?\nThis does not include player data.",
                dbImportExportNotificationImport = "Import",
                dbImportExportNotificationExport = "Export",

                dbExportNotificationHeader = "Success",
                dbExportNotificationDesc = "We've now started to export the gQuest data. You'll receive another notification when it is done. Please do not leave the server in the meanwhile.",
                dbExportNotificationFinished = "Export Completed.\nData can be found inside: /data/gquest_export/\nThis is the servers data folder, not your clients",
            
                dbImportHeader = "Hey!",
                dbImportDesc = "The system will now try to find data inside of /data/gquest_import/ folder.\n\nIf there is nothing in there then nothing will happen, else you will receive another notification.",
            
                dbImportExportHelpHeader = "Import and Export",
                dbImportExportHelpDesc = "Don't know how this works? Click me!",
                dbImportExportHelpClarification = "Once you've successfully exported the gQuest data then there will be one or two text documents in /data/gquest_export folder\n\nYou will need to move all of the text documents inside of the folder into the /data/gquest_import folder\n\nOnce the file(s) are inside of the gquest_import folder then you can click on the import button.\nA server restart might be required after moving files.\n\nAll of the folders and files are located in the data directory in their respective folders, which are on the server. If you're an administrator looking for these then contact the server owner.",
            
                dbImportNotificationFinished = "We've successfully imported the data, no restart is required! Simply respawn all of the npcs and it'll work!"
            --
        --
    --
}