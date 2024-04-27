--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
 *
 *  Translation by:
 *  https://steamcommunity.com/id/Dromexgame777/
--]]------------------------------------------------------------------------------

gQuest.Languages["ru"] = 
{
    -- Main
        thisLanguage = "Russian",
    --

    -- UI
        uiName = "Имя",
        uiModel = "Модель ",
        uiPosition = "Позиция",
        uiAngle = "Угол",
        uiQuests = "Квесты",
        uiUseIcons = "Использовать иконки",
        uiIcons = "Иконки",
        uiCreate = "Создать",
        uiEntity = "Энтити",
        uiID = "ID",
        uiFilledOut = "Необходимо заполнить одну или несколько вышеуказанных позиций.",
        uiNameLengthReached = "Имя не может содержать более 75 символов.\nКоличество Символов: %s",
        uiGeneralInformation = "Общая информация",
        uiQuestCreation = "Создание Квеста",
        uiQuestInformation = "Информация О Задании",
        uiError = "Ошибка",
        uiNPCS = "NPCS",
        uiCreateNewNPC = "Создать нового NPC",
        uiCreateNewNPCDesc = "Создать нового NPC для квестов",
        uiEditNPCS = "Редактирование существующих NPC",
        uiEditNPCSDesc = "Редактируйте NPC как хотите",
        uiDeleteNPC = "Удалить NPC",
        uiDeleteNPCDesc = "Удалить одного или больше NPCS, это навсегда.",
        uiSaveChanges = "Сохранить все изменения в NPC?",
        uiSaveChangesDesc = "Сохранить NPCS и спавнить их с сохраненными параметрами.\nВы не сможете отменить изменения.",
        uiSaveAllNPCS = "Сохранить всех NPC",
        uiSaveAllNPCSDesc = "Сохраняет их положение, углы и еще много чего.",
        uiSaveAllHeader = "Сохранить всех NPC?",
        uiSaveAllHeaderDesc = "Если у вас много NPC, то есть вероятность, что при сохранении будет небольшая задержка,которая продлится всего пару секунд.\nВсе NPC будут сохранены в их текущем состоянии.\nУбедитесь, что все NPC находятся там, где они должны быть.",
        uiSaveAllAccept = "Сохранить",
        uiRespawnAllNPCS = "Возродить всех NPC",
        uiRespawnAllNPCSDesc = "Возрождает всех NPC.",
        uiRespawnNPCSHeader = "Возродить NPC?",
        uiRespawnNPCSHeaderDesc = "Это удалит всех NPC на карте, а затем возродит их. Наличие большого количества NPC может вызвать некоторую задержку сервера при их появлении.\nЗадержка, если таковая имеется, будет лишь пару секунд.",
        uiDespawnNPCS = "Удалить всех NPC",
        uiDespawnNPCSDesc = "Удаляет всех NPC.",
        uiDespawnNPCSHeaderDesc = "Это приведет к удалению всех NPC на карте. TОни снова появятся при изменении карты / перезапуске сервера или при повторном запуске вручную.",
        uiCreateNewQuest = "Создать новый квест",
        uiCreateNewQuestDesc = "Создавайте квесты для людей!",
        uiStats = "Статистика",
        uiSettings = "Настройки",
        uiQuestsDesc = "Создание, редактирование и удаление квестов.",
        uiNPCSDesc = "Создать, редактировать или удалить NPC",
        uiItems = "Элементы",
        uiItemsDesc = "Создание, редактирование и удаление элементов.",
        uiPlayerStats = "Статистика Игрока",
        uiPlayerStatsDesc = "Отображение квестов игрока, сколько выполнено и т.д",
        uiHelp = "Помощь",
        uiHelpDesc = "Объясняет, как все работает.",
        uiAdmin = "Параметры Администратора",
        uiAdminDesc = "Включение / отключение администратора вещи здесь.",
        uiConfig = "Конфиг",
        uiConfigDesc = "Редактировать числа и логические значения здесь.",
        uiContinue = "Продолжить",
        uiDecline = "Отменить",
        uiQuestNPCDeletion = "Удаление NPC квеста.",
        uiQuestDeleteDesc = "Какие NPC вы хотите навсегда удалить с вашего сервера? Разделять запятыми, e.g\n1,2,3",
        uiQuestDelete = "Удалить",
        uiSuccess = "Успешно",
        uiBanned = "Имя entity содержит запрещенные символы.",
        uiSuccessCreated = "Успешно создано: %s",

        -- Help Page
            uiHelpHelp = "Страниц помощи",
            uiHelpUnderstand = "Понять как работают квесты",
            uiHelpObjectives = "Цели",
            uiHelpUnderstandObjectives = "онять, как работают задания квеста.",
            uiHelpQuestNPCS = "Квест NPC",
            uiHelpUnderstandNPCS = "Поймите, как работает квест nps.",
            uiHelpYOutube = "YouTube видео",
            uiHelpVisual = "Хотите визуальное представление?",
            uiHelpInfo = "Информация",
            uiHelpPageQuests = "Если вы хотите создать квесты, тогда вы должны посмотреть мое видео на YouTube, как это объясняет.\n\nВ этой статье я расскажу вам, как работают квесты.\n\nКак только игрок принимает квест, тогда, в зависимости от квеста, мы создадим цели для квеста, квест, который он принимает, автоматически отслеживается нашим поисковым трекером, и затем он может бежать к целям и выполнять их.\n\nКак только игрок выполнил квест, он может доставить его тому же NPC, который он получил от.\n\nИгроки могут отказаться от квеста, как только они его приняли, через журнал квестов или npc.",
            uiHelpPageObjectives = "Как только игрок принимает квест, мы создадим цели квеста для этого квеста и только квест.\n\nЦели Quest возрождаются через 60 секунд после того, как они были удалены или убиты.\n\nЦели Quest не будут возрождаться, если в онлайн-квесте нет игроков.\n\nQuest Цели порождаются только тогда, когда они еще не были порождены.\n\nТеперь я объясню вам, что означает переменные, когда вы создаете цели.\n\nEntity. Какую entity мы должны создать? Это нужно для действительного объекта вроде npc_zombie. Это может содержать только одно entity, а не несколько, как в переменной квестов.\nКвесты: для каких целей следует использовать эти цели? У вас может быть несколько, но рекомендуется иметь 1 квест. Разделяют запятыми, например 1,2,3\nПозиция: позиция, в которой будет выполняться цель поиска, - это то место, где вы сейчас находитесь.\nУгол: угол, на который будет начинаться цель поиска.",
            uiHelpPageNPCS = "Вы можете создать квест npcs через наше меню, которое можно получить с помощью команды !Gquest, однако, поскольку вы читаете это, вы, вероятно, знаете это.\n\nВот что означают переменные, когда вы создаете квест npc.\n\nИмя: имя NPC, которое будет отображаться над ними.\nМодель: Модель которую npc будет иметь.\nПозиция: позиция, для npc.\nУгол: угол под которым находится npc.\n\nПосле того, как вы создали npc, вы можете снова ввести gquest, чтобы открыть меню, затем выберите инструмент редактирования, а затем вы сможете найти NPC ID, что имеет решающее значение при создании квестов.\n\nNPC можно редактировать, удалять и все остальное, любой, кто имеет доступ к этому меню, может делать все.",
            uiHelpPageYoutube = "Все видео на YouTube можно найти либо на странице gQuest GmodStore, либо в файле README.txt, который включен в покупку.",
        --

        -- Notifications
            uiNotificationCreated = "Создан NPC:",
            uiNotificationRespawn = "Респавнены все NPCS",
            uiNotificationDespawned = "Удалены все NPCS",
            uiNotificationSaveNPCS = "Сохранены все NPCS",
            uiNotificationChangesSaved = "Изменения сохранены",
            uiNotificationDeleteNPCS = "Удалены выбранные NPCS",
            uiNotificationQuestFailed = "Квест не выполнен:",
            uiNotificationAbandoned = "Квест заброшен:",
            uiNotificationAccepted = "Квест принят:",
            uiNotificationCompleted = "Квест завершен:",
            uiNotificationDelivered = "Квест доставлен:",
            uiNotificationAbandonedDueToJob = "Задание отменено из-за неправильной работы:",
        --

        -- Objectives
            objObjectives = "Цели",
            objCreate = "Создать цели.",
            objCreateDesc = "Создайте новые цели для наших квестов.",
            objEdit = "Изменить цели",
            objEditDesc = "Измените существующие цели.",
            objDelete = "Удалить цели",
            objDeleteDesc = "Удалите цели квеста здесь.",
            objDeleteHeader = "Удаление цели",
            objDeleteHeaderDesc = "Какие цели вы бы хотели удалить на своем сервере? Отдельно запятыми, например\n1,2,3",
            objQuest = "Цели квеста",
            objPlace = "Поместите или удалите цели квеста.",
        --
        
        -- NPC
            npcAbandon = "Заброшенный квест",
            npcHeaderAbandon = "Заброить квест?",
            npcDesc = "Все успехи, которые вы сделали для этого квеста, будут потеряны, если вы оставите его.\nВы действительно хотите отказаться? %s?",
            npcAbandonIt = "Отказаться от этого",
            npcNever = "Неважно",
            npcQuest = "Описание квеста",
            npcObj = " Цель квеста",
            npcRewards = "Награда",
            npcDeliver = "Доставить квест",
            npcCompleted = "Завершенный Завершен",
            npcCooldown = "Quest is on cooldown: %s remaining",
            npcAccept = "Принять квест",
        --

        -- Log
            logNoQuests = "у вас нет квеста",
            logTrack = "Отслеживать квест.",
            logUnTrack = "Остановить слежку",
            logNoLonger = "Больше не отслеживаем:",
            LogTracking = "Теперь отслеживание:",
        --

        -- DB
            dbQuest = "База данных Quest",
            dbQuestDesc = "Делайте вещи базы данных здесь.",
            dbDatabase = "База данных игроков",
            dbDatabase2 = "База данных Квестов",
            dbRemoveAcceptedQuests = "Удалить принятые квесты",
            dbRemoveAcceptedQuestsDesc = "Удалите квесты у игрока.",
            dbViewQuests = "Просмотр квестов",
            dbViewQuestsDesc = "Посмотреть все квесты, которые любой пользователь выполнил / принял",
            dbPlayers = "Выберите игрока",
            dbSearch = "Поиск игрока",
            dbSearchDesc = "Найдите игрока по имени или SteamID в игре.",
            dbSearchText = "Поиск",
            dbSearchResult = "Результат поиска",
            dbSearchResultError = "Не удалось найти никого с заданными параметрами.",
            dbSearchOk = "Окей",
            dbSearchResultErrorPlayers = "Было слишком много результатов с заданными параметрами, пожалуйста, будьте более конкретными.",
            dbRemove = "Удалить квесты",
            dbRemoveDesc = "Какие задания вы хотели бы удалить из %s? Разделите запятыми.",
            dbRemoveButton = "Убрать",
            dbRemoveNotifyHeader = "Администратор удалил ваш квест:",
            dbNotAccepted = "У этого игрока нет заданий:",
            dbRemoved = "Успешно удален квест:",
            dbClear = "Удалить базу данных Quest",
            dbClearDesc = "Удаляет все данные относительно квестов.",
            dbClearNotify = "Удалить данные?",
            dbClearNotifyDesc = "Для удаления всех данных квеста потребуется быстрое изменение карты, это также приведет к удалению хода к любому квесту. Это постоянное решение.",
            dbClearNPCS = "Удалить базу данных NPC",
            dbClearNPCSDesc = "Удаляет все наши сохраненные npcs.",
            dbClearNPCSHeaderDsec = "Удаление всего квеста npcs является постоянным решением. Это не может быть отменено. Для этого требуется изменение карты.",
            dbClearObj = "Удалить объективную базу данных",
            dbClearObjDesc = "Удаляет все наши сохраненные цели.",
            dbClearObjNotifyDesc = "Удаление всех целей из базы данных является постоянным решением. Для этого требуется изменение карты.",
        --

        -- Other
            otherText = "Помните, вы можете нажать L, чтобы отслеживать ваши текущие квесты и их прогресс.",
        --

        -- Update 030818 or >
            uiNotificationPlayerNotValidHeader = "Игрок недопустим!",
            uiNotificationPlayerNotValidDesc = "Казалось бы, ваш выбранный игрок покинул сервер.",

            CurrentQuests = "Выполненные квесты.",
            QuestObjectives = "Задачи квеста.",
            QuestCooldowns = "Задания, которые завершены, но восстанавливаются.",
            CompletedQuests = "Завершенные задания.",
            QuestsForDeliver = "Квесты готовы к отправке.",

            -- Update 060818
                questObjectiveStats = "Этот пользователь собрал %i целей из %i для этого квеста.",
                questAcceptedStats  = "Этот пользователь принял этот квест.",
                questCompletedStats = "Этот квест завершен и доставлен.",
                questsDeliverStats = "Этот квест завершен, но не доставлен.",
                questsCooldownStats = "Этот квест завершен и установлен на время восстановления. Открывается снова в %s",
            --

            -- Update 070818
                uiNotificationForcedComplete = "Администратор запустил ваш квест:",
                uiNotificationForcedRemoved = "Администратор удалил ваш квест:",
                uiNotificationForcedRemovedCD = "Администратор удалил ваш CD-квест:",
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