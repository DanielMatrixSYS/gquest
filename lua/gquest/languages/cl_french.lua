--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
 *  Translation by Cedi :D
--]]------------------------------------------------------------------------------

gQuest.Languages["fr"] = 
{
    -- Main
        thisLanguage = "French",
    --

    -- UI
        uiName = "Nom",
        uiModel = "Modèle",
        uiPosition = "Position",
        uiAngle = "Angle",
        uiQuests = "Quêtes",
        uiUseIcons = "Icons à utiliser",
        uiIcons = "Icons",
        uiCreate = "Créer",
        uiEntity = "Entitité",
        uiID = "ID",
        uiFilledOut = "Une ou plusieurs des entrées ci-dessus doivent être remplies.",
        uiNameLengthReached = "Le nom ne peux pas contenir plus de 75 caractères.\nNombre de caractères actuel : %s",
        uiGeneralInformation = "Informations générale",
        uiQuestCreation = "Création de quêtes",
        uiQuestInformation = "Informations de la quêtes",
        uiError = "ERREUR",
        uiNPCS = "PNJS",
        uiCreateNewNPC = "Créer un nouveau PNJ",
        uiCreateNewNPCDesc = "Créez un nouveau PNJ qui tiendra des quêtes.",
        uiEditNPCS = "Edité un PNJ existant",
        uiEditNPCSDesc = "Éditez à quoi ressemble le PNJ",
        uiDeleteNPC = "Supprimer le PNJ",
        uiDeleteNPCDesc = "Supprimer un ou plusieurs PNJS, <!> attention permanent.",
        uiSaveChanges = "Savegarder les changements sur les PNJS?",
        uiSaveChangesDesc = "Sauvegarder les PNJS et les faire respawn avec les changements.\nAucun retour en arriere une fois sauvegarder.",
        uiSaveAllNPCS = "Sauvegarder TOUT les PNJS",
        uiSaveAllNPCSDesc = "Sauvegarder la position actuelle ainsi que l'angle .",
        uiSaveAllHeader = "Sauvegarder tout les PNJS?",
        uiSaveAllHeaderDesc = "Si vous avez beaucoup de pnjs alors il y a une chance qu'il y ait un léger décalage pendant l'enregistrement, lag, cela ne durera que quelques secondes.\nTout les pnjs seront sauvegardé avec les changements que vous avez fait.\nAssurez vous d'avoir mit les bonnes positions.",
        uiSaveAllAccept = "Sauvegarder",
        uiRespawnAllNPCS = "Faire réapparaître tout les pnjs",
        uiRespawnAllNPCSDesc = "Faire réapparaître tout les pnjs.",
        uiRespawnNPCSHeader = "Faire réapparaître tout les pnjs?",
        uiRespawnNPCSHeaderDesc = "Cela enlèvera tous les PNJS sur la carte puis les réapparaîtra.\nSi il y a des lags cela ne prendra que normalement quelques secondes.",
        uiDespawnNPCS = "Faire disparaître tout les pnjs",
        uiDespawnNPCSDesc = "Faire disparaître tout les pnjs.",
        uiDespawnNPCSHeaderDesc = "Cela supprimera tout les pnjs. Ils apparaîtront à nouveau sur le changement de carte / le redémarrage du serveur ou lorsque vous les réapparaissez manuellement.",
        uiCreateNewQuest = "Créer une nouvelle quêtes",
        uiCreateNewQuestDesc = "Créer des quêtes pour les joueurs!",
        uiStats = "Stats",
        uiSettings = "Paramètres",
        uiQuestsDesc = "Créer, modifier ou supprimer des quêtes.",
        uiNPCSDesc = "Créer, modifier ou supprimer des pnjs.",
        uiItems = "Objets",
        uiItemsDesc = "Créer, modifier ou supprimer des objets.",
        uiPlayerStats = "Stats du joueur",
        uiPlayerStatsDesc = "Afficher les quêtes du joueur, combien ont été complétées, etc...",
        uiHelp = "Aides",
        uiHelpDesc = "Explique comment les choses fonctionnent.",
        uiAdmin = "Paramètres (admin)",
        uiAdminDesc = "Activer / Désactiver les choses Admin ici.",
        uiConfig = "Configurer",
        uiConfigDesc = "Modifier les nombres et les booléens ici.",
        uiContinue = "Continuer",
        uiDecline = "Decliner",
        uiQuestNPCDeletion = "Suppression de PNJ de quête.",
        uiQuestDeleteDesc = "Quel NPCS souhaitez-vous supprimer définitivement de votre serveur? Séparer avec des virgules, ex : \n1,2,3",
        uiQuestDelete = "Supprimer",
        uiSuccess = "Succès",
        uiBanned = "Le nom de l'entité contient des caractères interdits.",
        uiSuccessCreated = "Créé avec succès: %s",

        -- Help Page
            uiHelpHelp = "Page d'aides",
            uiHelpUnderstand = "Comprendre comment les quêtes marchent.",
            uiHelpObjectives = "Objectifs",
            uiHelpUnderstandObjectives = "Comprendre comment les objectifs de quêtes marchent.",
            uiHelpQuestNPCS = "PNJS de quêtes",
            uiHelpUnderstandNPCS = "Comprendre comment les pnjs de quêtes marchent.",
            uiHelpYOutube = "Youtube Videos",
            uiHelpVisual = "Vous voulez une présention visuel (anglais)?",
            uiHelpInfo = "Informations",
            uiHelpPageQuests = "Si vous regardez pour créer des recherches alors vous devriez regarder ma vidéo youtube comme cela explique comment. \n\n Cet article vous expliquera comment les recherches marchent. \n\n Une fois qu'un joueur accepte une recherche alors, selon la recherche, nous engendrerons les objectifs pour la recherche, la recherche qu'il accepte est automatiquement suivi à la trace par notre traqueur de recherche et il peut alors courir vers les objectifs et les faire. \n\n Une fois que le joueur a fait la recherche alors il peut le livrer aux même PNJS qui lui à donné la quête. \n\n Les Joueurs peuvent abandonner la recherche une fois qu'ils l'ont accepté.",
            uiHelpPageObjectives = "Une fois qu'un joueur accepte une recherche alors nous engendrerons les objectifs de recherche pour cette recherche et cette recherche seulement. \n\n les Objectifs de Recherche respawn après 60 secondes ou après qu'ils ont été ou enlevés ou tuées. \n\n Les Objectifs de Recherche sont seulement engendrés s'ils n'ont pas été engendrés auparavant. \n\n Maintenant je vous expliquerai ce que les variables signifient quand vous créez des objectifs. \n\n Entité: Quelle entité devrions-nous engendrer? Cela a besoin d'une entité valable comme, npc_zombie. Ceci peut seulement contenir une entité et pas plusieurs comme dans la variable de recherches. \n Recherches: Pour quelles quêtes ses objectifs devraient-ils être utilisés? Vous pouvez avoir un choix multiple. Seperarer par une virgules, par exemple 1,2,3\n Position: la position de l'objectif de la quête.",
            uiHelpPageNPCS = "Vous pouvez rechercher des pnjs et les créer par notre menu qui peut être accèssible avec la commande !gquest, \n\n Il vous faudras trouver un model à lui appliquer, le nom sera afficher au dessus de sa tête vous pouvez à tout moment modifier le pnj avec la commande !gquest (dans le chat).",
            uiHelpPageYoutube = "Toutes les vidéos YouTube peuvent être trouvées sur la page gQuest GmodStore ou dans le fichier README.txt qui est inclus dans l'achat.",
        --

        -- Notifications
            uiNotificationCreated = "Créer un PNJ:",
            uiNotificationRespawn = "Faire réapparaître tout les pnjs",
            uiNotificationDespawned = "Faire disparaître tout les pnjs",
            uiNotificationSaveNPCS = "Sauvegarder tout les pnjs",
            uiNotificationChangesSaved = "Enregistrer les changements",
            uiNotificationDeleteNPCS = "Supprimer les PNJS selectionnés",
            uiNotificationQuestFailed = "Echec de la quête:",
            uiNotificationAbandoned = "Quête Abandonnée:",
            uiNotificationAccepted = "Quête acceptée:",
            uiNotificationCompleted = "Quête terminée:",
            uiNotificationDelivered = "Quête livrée:",
            uiNotificationAbandonedDueToJob = "Quest Abandoned Due To Incorrect Job:",
        --

        -- Objectives
            objObjectives = "Objectifs",
            objCreate = "Créer un objectif.",
            objCreateDesc = "Créer un ou plusieurs objectifs pour nos quêtes.",
            objEdit = "Editer les objectifs",
            objEditDesc = "editer les objectifs existants.",
            objDelete = "Supprimer les objectifs",
            objDeleteDesc = "Supprimer les objectifs de quête ici.",
            objDeleteHeader = "Suppression de l'objectif.",
            objDeleteHeaderDesc = "Quels objectifs aimeriez-vous supprimer définitivement de votre serveur? Séparer par des virgules, par exemple \n 1,2,3",
            objQuest = "Quest Objectives",
            objPlace = "Place or remove quest objectives here.",
        --
        
        -- NPC
            npcAbandon = "Abandonner la Quête",
            npcHeaderAbandon = "Abandonner la Quête?",
            npcDesc = "Tous les progrès que vous avez réalisés pour cette quête seront perdus si vous l'abandonnez.\nVous êtes sure de vouloir abandonner la quête %s?",
            npcAbandonIt = "Abandonner",
            npcNever = "Ça ne fait rien",
            npcQuest = "Description de la Quête",
            npcObj = "Objectif de la quête",
            npcRewards = "Récompenses",
            npcDeliver = "Livrer la quête",
            npcCompleted = "Quête terminée",
            npcCooldown = "Quest is on cooldown: %s remaining",
            npcAccept = "Accepter la Quête",
        --

        -- Log
            logNoQuests = "Vous n'avez pas de quête",
            logTrack = "Traquer la quête.",
            logUnTrack = "Lacher la traque de la quête.",
            logNoLonger = "Vous ne traquer plus la quête:",
            LogTracking = "Vous traquer la quête:",
        --

        -- DB
            dbQuest = "Base de données des quêtes",
            dbQuestDesc = "Faire des modifs sur la BDD ici.",
            dbDatabase = "Base de donné du joueur",
            dbDatabase2 = "Base de donné de la quête",
            dbRemoveAcceptedQuests = "Supprimper les quêtes acceptées",
            dbRemoveAcceptedQuestsDesc = "Supprimer les quêtes pour le joueur.",
            dbPlayers = "Sélectionnez un joueur",
            dbSearch = "Rechercher un joueur",
            dbSearchDesc = "Rechercher un joueur par son nom de jeu ou steamid.",
            dbSearchText = "Rechercher",
            dbSearchResult = "Résultat de la recherche",
            dbSearchResultError = "Impossible de trouver quelqu'un avec les paramètres donnés.",
            dbSearchOk = "Ok",
            dbSearchResultErrorPlayers = "Il y avait trop de résultats avec les paramètres donnés, s'il vous plaît soyez plus précis.",
            dbRemove = "Supprimer les quêtes",
            dbRemoveDesc = "Quelles quêtes souhaitez-vous supprimer de %s? Séparer avec des virgules.",
            dbRemoveButton = "Retirer",
            dbRemoveNotifyHeader = "Un administrateur a supprimé votre quête:",
            dbNotAccepted = "Ce joueur n'a pas de quête:",
            dbRemoved = "Quête supprimée avec succès:",
            dbClear = "Supprimer la base de données de quêtes",
            dbClearDesc = "Supprime toutes les données concernant les quêtes.",
            dbClearNotify = "Suprimmer les données?",
            dbClearNotifyDesc = "La suppression de toutes les données de quête nécessitera un changement rapide de la carte, ce qui supprimera également les progrès vers toute quête. Ceci est une solution permanente.",
            dbClearNPCS = "Supprimer la base de données des pnjs",
            dbClearNPCSDesc = "Supprime tous nos pnjs enregistrés.",
            dbClearNPCSHeaderDsec = "La suppression de toutes les requêtes npcs est une solution permanente. Ça ne peut pas être annulé. Cela nécessite un changement de carte/reboot.",
            dbClearObj = "Supprimer la base de données objective",
            dbClearObjDesc = "Supprime tous nos objectifs enregistrés.",
            dbClearObjNotifyDesc = "La suppression de tous les objectifs de la base de données est une solution permanente. Cela nécessite un changement de carte/reboot.",
        --

        -- Other
            otherText = "Rappelez-vous, vous pouvez appuyer sur L pour garder une trace de vos quêtes actuelles et de leur progression.",
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

                uiVisualAid = "Visual Aid",
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
                uiNotificationTimeLimit = "This quest needs to be complete within a time limit, press L to learn more.",
                uiNotificationQuestFailedDueToTime = "Quest failed due to time limit reached.",
            --

            -- 280119
                uiNotificationAutoComplete = "Quest Completed & Delivered. Your Reward: ",
            --
        --
    --
}