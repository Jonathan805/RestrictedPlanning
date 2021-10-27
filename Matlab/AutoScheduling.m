close all; clear all; clc;

% restraints/constraints that users will need to handle on their own
% hotseats - 30 min
% Each carrier can accommodate 2x hotseats at a time in any combination of jet or helo


% Target Info Setup
[IndProbKillsIfTgtIdxStrk, TgtToIdxToKill, DestroyOrDisableFlags, sortieTimesAgainstTarget, ...
    percentOfJetsThatGetKilledIfAttacked] = targetInfoSetup();

% Determine Target Striking Order
[TgtStrikeOrder, OrderedDestroyOrDisableFlags, OrderedSortieTimesAgainstTarget, OrderedChanceGetKilledIfStriked] = ...
    determineTargetStrikingOrder(IndProbKillsIfTgtIdxStrk, TgtToIdxToKill, DestroyOrDisableFlags, ...
    sortieTimesAgainstTarget);

% Determine Number of Missiles Needed for Targets
[numMissilesPerTarget, numMissilesNeededForTgt] = missileInfoSetup(OrderedDestroyOrDisableFlags);

%%%%%%%%%%%%%
% Timeline  %
%%%%%%%%%%%%%
NumSorties = length(TgtStrikeOrder);

[NumJets, NumPilots, NumHelos, NumHours, jetRestTime, heloRestTime, pilotRestTime, ...
    jetRepositionTime, pilotRepositionTime, heloRepositionTime, missileRepositionTime, jetMissileStorage, ...
    JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, MissilesCarrierInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    heloConsecFlyTime, maxJetSortiesPerDay, jetFlyTimePerDay, jetPilotFlyTimePerDay, ...
    HeloMaxPilotsMoved, JetSortiesInfo, JetMaintenanceHrsAfterHrsInFlight, ...
    JetDownTimeInfo, HeloDownTimeInfo, data] = setUp(NumSorties);

% flags (simulating mission execution when receive extra info)
TurnOnPilotJetKill = 1; % flag to turn on removing pilots/jets if they get killed
TurnOnSortieRemove = 1; % flag to turn on removing sorties if missiles disable or destroy a target
TurnOnPossibleJetHeloDownTime = 1; % flag to turn on removing jets/helos after landing for down time

startTimeHr = 1;
numberOfJetsPilotsKilled = 0;
JetSortieData = [];
PilotSortieData = [];
HeloSortieData = [];
for kk = 1:length(TgtStrikeOrder)

    % max sortie time
    maxSortieTimeHrs = OrderedSortieTimesAgainstTarget(kk, 2);
    % chance get x% jets/pilots get killed if attacked by this target's
    % protectors
    chanceGetKilled = OrderedChanceGetKilledIfStriked(kk);
    
    if startTimeHr <= 1 
        startTimeHr = 2;
    end

    if TurnOnSortieRemove
        numMissilesNeeded = numMissilesNeededForTgt(kk);
    else
        numMissilesNeeded = numMissilesPerTarget(kk);
    end

    rerunAndIncrementStartTime = 1;

    while (rerunAndIncrementStartTime)
        [JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
            PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
            MissilesCarrierInfo, JetSortiesInfo, rerunAndIncrementStartTime, numberOfJetsPilotsKilled, ...
            data, JetSortieData, PilotSortieData, HeloSortieData] = AddToSchedule(...
            kk, TgtStrikeOrder(kk), startTimeHr, maxSortieTimeHrs, NumJets, NumPilots, NumHelos, NumHours, ...
            JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, MissilesCarrierInfo, ...
            PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
            jetRestTime, heloRestTime, pilotRestTime, jetRepositionTime, pilotRepositionTime, heloRepositionTime, ...
            missileRepositionTime, heloConsecFlyTime, maxJetSortiesPerDay, jetFlyTimePerDay, jetPilotFlyTimePerDay, ...
            numMissilesNeeded, jetMissileStorage, HeloMaxPilotsMoved, JetSortiesInfo, numberOfJetsPilotsKilled, ...
            JetMaintenanceHrsAfterHrsInFlight, chanceGetKilled, percentOfJetsThatGetKilledIfAttacked, ...
            TurnOnPilotJetKill, JetDownTimeInfo, HeloDownTimeInfo, TurnOnPossibleJetHeloDownTime, data, ...
            JetSortieData, PilotSortieData, HeloSortieData);
        
        if (rerunAndIncrementStartTime)
            startTimeHr = startTimeHr + 1;
            fprintf('Re-running for target %d and start time %d hrs...\n', kk, startTimeHr);
        end
    end

    startTimeHr = startTimeHr + maxSortieTimeHrs; % separate sorties by the sortie time at least
end

disp(' ');
disp(['Number of Casualities: ' num2str(numberOfJetsPilotsKilled)]);

JetSortieData, PilotSortieData, HeloSortieData


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 function [JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    MissilesCarrierInfo, JetSortiesInfo, rerunAndIncrementStartTime, numberOfJetsPilotsKilled, data, ...
    JetSortieData, PilotSortieData, HeloSortieData] = ...
    AddToSchedule(sortieNumber, targetNumber, startTimeHr, maxSortieTimeHrs, NumJets, NumPilots, NumHelos, NumHours, ...
    JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, MissilesCarrierInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    jetRestTime, heloRestTime, pilotRestTime, jetRepositionTime, pilotRepositionTime, heloRepositionTime, ...
    missileRepositionTime, heloConsecFlyTime, maxJetSortiesPerDay, jetFlyTimePerDay, jetPilotFlyTimePerDay, ...
    numMissilesNeeded, jetMissileStorage, HeloMaxPilotsMoved, JetSortiesInfo, numberOfJetsPilotsKilled, ...
    JetMaintenanceHrsAfterHrsInFlight, chanceGetKilled, percentOfJetsThatGetKilledIfAttacked, ...
    TurnOnPilotJetKill, JetDownTimeInfo, HeloDownTimeInfo, TurnOnPossibleJetHeloDownTime, data, ...
    JetSortieData, PilotSortieData, HeloSortieData)

    % choose jets, helo, pilots for a sortie
    tempData = data;

    [chosenJets, chosenHelo, chosenPilots, jetPilotMapping, missionStartTimeHr, extraJetsToMoveMissiles, ...
        extraPilotsToMoveMissiles, JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
        PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
        pilotsRepositionedByJet, jetsRepositioned, pilotsRepositionedByHelo, helosRepositioned, ...
        MissilesCarrierInfo, JetSortiesInfo, jetDownTime, heloDownTime, rerunAndIncrementStartTime, ...
        JetSortieData, PilotSortieData, HeloSortieData] = chooseJetsHeloPilots( ...
        targetNumber, startTimeHr, maxSortieTimeHrs, NumJets, NumPilots, NumHelos, NumHours, ...
        JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, MissilesCarrierInfo, ...
        PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
        jetRestTime, heloRestTime, pilotRestTime, jetRepositionTime, pilotRepositionTime, heloRepositionTime, ...
        missileRepositionTime, heloConsecFlyTime, maxJetSortiesPerDay, jetFlyTimePerDay, jetPilotFlyTimePerDay, ...
        numMissilesNeeded, jetMissileStorage, HeloMaxPilotsMoved, JetSortiesInfo, ...
        JetMaintenanceHrsAfterHrsInFlight, JetDownTimeInfo, HeloDownTimeInfo, TurnOnPossibleJetHeloDownTime, ...
        sortieNumber, tempData, JetSortieData, PilotSortieData, HeloSortieData);

    if ~rerunAndIncrementStartTime
        % plot schedule
        [data] = plotSchedule(chosenJets, chosenHelo, chosenPilots, extraJetsToMoveMissiles, ...
            extraPilotsToMoveMissiles, pilotsRepositionedByJet, jetsRepositioned, pilotsRepositionedByHelo, helosRepositioned, ...
            startTimeHr, missionStartTimeHr, maxSortieTimeHrs, jetRestTime, heloRestTime, pilotRestTime, ...
            jetRepositionTime, pilotRepositionTime, heloRepositionTime, missileRepositionTime, jetDownTime, heloDownTime, ...
            data, NumJets, NumHelos, NumPilots);

        if TurnOnPilotJetKill
            % remove jets/pilots that get killed
            numJetsTotalInSortie = nnz(chosenJets);
            numJetsThatMightGetKilled = ceil(percentOfJetsThatGetKilledIfAttacked * numJetsTotalInSortie);
            % roll a dice to see if each jet that might get killed gets killed
            for yy = 1:numJetsThatMightGetKilled
                randomJetIdx = randi([1 numJetsThatMightGetKilled]);
                if (rand <= chanceGetKilled)
                    % jet is killed
                    JetsHoursInfo(chosenJets(randomJetIdx), :) = 0;
                    fprintf('Jet %d is killed!!!', chosenJets(randomJetIdx));
    
                    % get pilot in the jet because the pilot is killed too
                    pilotMapIdx = find(jetPilotMapping(:, 1) == chosenJets(randomJetIdx));
                    pilotForJet = jetPilotMapping(pilotMapIdx, 2);
                    PilotsHoursInfo(pilotForJet, :) = 0;
                    fprintf('\nPilot %d is killed!!!\n', pilotForJet);

                    numberOfJetsPilotsKilled = numberOfJetsPilotsKilled + 1;
                end
            end
        end
    end
end

function [NumJets, NumPilots, NumHelos, NumHours, jetRestTime, heloRestTime, pilotRestTime, ...
    jetRepositionTime, pilotRepositionTime, heloRepositionTime, missileRepositionTime, jetMissileStorage, ...
    JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, MissilesCarrierInfo, ...
    PilotsHoursInfo,PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    heloConsecFlyTime, maxJetSortiesPerDay, jetFlyTimePerDay, jetPilotFlyTimePerDay, ...
    HeloMaxPilotsMoved, JetSortiesInfo, JetMaintenanceHrsAfterHrsInFlight, ....
    JetDownTimeInfo, HeloDownTimeInfo, data] = setUp(NumSorties)

    NumJets = 19;
    NumPilots = 21;
    NumHelos = 4;
    NumDays = 7;
    NumHours = NumDays * 24;

    jetRestTime = 8; % hrs
    heloRestTime = 12; % hrs
    pilotRestTime = 16; %hrs
    jetRepositionTime = 4; %hrs
    pilotRepositionTime = 24; %hrs
    heloRepositionTime = 6; % hrs
    missileRepositionTime = 18; % hrs (12 hrs roundtrip from same carrier, but worst case is from a different carrier)

    heloConsecFlyTime = 8; %hrs
    maxJetSortiesPerDay = 3;
    jetFlyTimePerDay = 16; % hrs
    jetPilotFlyTimePerDay = 16; % hrs

    HeloMaxPilotsMoved = 2;
    
    % JetsInfo
    % 1st: Each Jet
    % 2nd: Flags of all Jets that the Jet can fly with
    JetsInfo = ones(NumJets, NumJets);
    for ii = 1:NumJets
        % jets cannot fly with themselves
        JetsInfo(ii,ii) = 0;
    end
    % jet 10 and 11 cannot fly together
    JetsInfo(10,11) = 0;
    JetsInfo(11,10) = 0;
    
    % JetsHoursInfo
    % 1st: Each Jet
    % 2nd: Flags of Hrs that the Jet can fly on
    JetsHoursInfo = ones(NumJets, NumHours);
    % jet 7 is not available after day 5
    JetsHoursInfo(7, 1:5*24+1) = 0;
    % jet 1 is not available until 1400z on Day 3
    JetsHoursInfo(1, 1:2*24+13) = 0;

    % Jet Missile Storage
    jetMissileStorage = 2 * ones(1, NumJets);
    jetMissileStorage([4 8 9 17]) = 1;

    % Jet Sorties per Day
    JetSortiesInfo = zeros(NumJets, NumDays);

    % Jet Maintenance
    % 1st: Each Jet
    % 2nd: Column 1 = Hrs Flight Before Maintenance
    % 2nd: Column 2 = Hrs of Maintenance
    JetMaintenanceHrsAfterHrsInFlight = zeros(NumJets, 2);
    JetMaintenanceHrsAfterHrsInFlight(5, :) = [10 40];

    % Jet Down Time
    % 1st: Each Jet
    % 2nd: Column 1 = % of needing down time when return from sortie
    % 2nd: Column 2 = Hrs of Down Time
    JetDownTimeInfo = repmat([.2 24], NumJets, 1);
    
    % Carrier/Squadron Info
    % 1st: Each Jet
    % 2nd: Number for what carrier the Jet is in
    JetsCarrierInfo = zeros(NumJets, 1);
    JetsCarrierInfo(1:11) = 1;
    JetsCarrierInfo(12:19) = 2;
    
    % PilotsInfo
    % 1st: Each pilot
    % 2nd: Flags of all pilots that the pilot can fly with
    PilotsInfo = ones(NumPilots, NumPilots);
    for ii = 1:NumPilots
        % pilot cannot fly with themselves
        PilotsInfo(ii,ii,:,:) = 0;
    end
    % pilot 1 and 2 cannot fly together
    PilotsInfo(1,2) = 0;
    PilotsInfo(2,1) = 0;
    % pilot 11 and 12 cannot fly together
    PilotsInfo(11,12) = 0;
    PilotsInfo(12,11) = 0;
    % pilot 20 and 21 cannot fly together
    PilotsInfo(20,21) = 0;
    PilotsInfo(21,20) = 0;
    % pilot 3 can only fly with pilots 4 or 9
    PilotsInfo(3,setdiff(1:NumPilots,[4,9])) = 0;
    % pilot 18 can only fly with pilots 21 or 19
    PilotsInfo(18,setdiff(1:NumPilots,[21,19])) = 0;
    
    % PilotsJetsInfo
    % 1st: Each pilot
    % 2nd: Flags of all Jets that the pilot can fly with
    PilotJetsInfo = ones(NumPilots, NumJets);
    % pilot 5 cannot fly with Jet 8
    PilotJetsInfo(5,8) = 0;
    % pilot 17 cannot fly with Jet 12
    PilotJetsInfo(17,12) = 0;
    
    % PilotsHoursInfo
    % 1st: Each pilot
    % 2nd: Flags of all Hrs that the pilot can fly on
    PilotsHoursInfo = ones(NumPilots, NumHours);
    % pilot 4 cannot fly any missions on Day 5
    PilotsHoursInfo(4, 4*24+1:5*24) = 0;
    % pilot 13 cannot fly any missions on Day 6 and 7
    PilotsHoursInfo(13,5*24+1:7*24) = 0;
    
    % Carrier/Squadron Info
    % 1st: Each Pilot
    % 2nd: Number for what carrier the Pilot is in
    PilotsCarrierInfo = zeros(NumPilots, 1);
    PilotsCarrierInfo(1:14) = 1;
    PilotsCarrierInfo(15:21) = 2;
    
    % HelosHoursInfo
    % 1st: Each Helo
    % 2nd: Flags of Hrs that the Jet can fly on
    HelosHoursInfo = ones(NumHelos, NumHours);

    % Helo Down Time
    % 1st: Each Helo
    % 2nd: Column 1 = % of needing down time when return from sortie
    % 2nd: Column 2 = Hrs of Down Time
    HeloDownTimeInfo = repmat([.3 16], NumHelos, 1);
    
    % Carrier/Squadron Info
    % 1st: Each Helo
    % 2nd: Number for what carrier the Helo is in
    HelosCarrierInfo = zeros(NumHelos, 1);
    HelosCarrierInfo(1:2) = 1;
    HelosCarrierInfo(3:4) = 2;
    
    % Carrier/Squadron Info
    % 1st: Each Helo Crew
    % 2nd: Number for what carrier the Helo Crew is in
    HeloCrewsCarrierInfo(1:2) = 1;
    HeloCrewsCarrierInfo(3:4) = 2;

    % Missiles Carrier Info
    % 1st: Number for what carrier the Missile is in (0 means the missile
    % has been used)
    MissilesCarrierInfo(1:8) = 1;
    MissilesCarrierInfo(9:13) = 2;

    % set up data to plot schedule
    data = zeros(NumJets + NumHelos + NumPilots, NumHours);
end

function [chosenJets, chosenHelo, chosenPilots, jetPilotMapping, missionStartTimeHr, extraJetsToMoveMissiles, ...
    extraPilotsToMoveMissiles, JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    pilotsRepositionedByJet, jetsRepositioned, pilotsRepositionedByHelo, helosRepositioned, ...
    MissilesCarrierInfo, JetSortiesInfo, jetDownTime, heloDownTime, rerunAndIncrementStartTime, ...
    JetSortieData, PilotSortieData, HeloSortieData] = chooseJetsHeloPilots( ...
    targetNumber, startTimeHr, maxSortieTimeHrs, NumJets, NumPilots, NumHelos, NumHours, ...
    JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, MissilesCarrierInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    jetRestTime, heloRestTime, pilotRestTime, jetRepositionTime, pilotRepositionTime, heloRepositionTime, ...
    missileRepositionTime, heloConsecFlyTime, maxJetSortiesPerDay, jetFlyTimePerDay, jetPilotFlyTimePerDay, ...
    numMissilesNeeded, jetMissileStorage, HeloMaxPilotsMoved, JetSortiesInfo, ...
    JetMaintenanceHrsAfterHrsInFlight, JetDownTimeInfo, HeloDownTimeInfo, TurnOnPossibleJetHeloDownTime, ...
    sortieNumber, tempData, JetSortieData, PilotSortieData, HeloSortieData)

    % initialize
    rerunAndIncrementStartTime = 0;
    chosenJets = [];
    chosenHelo = [];
    chosenPilots = [];
    pilotsRepositionedByJet = [];
    jetsRepositioned = [];
    pilotsRepositionedByHelo = [];
    helosRepositioned = [];
    missionStartTimeHr = startTimeHr;
    jetsToMoveCarriers = 0;
    maxJetsToMoveCarriers = 0;
    pilotsToMoveCarriers = 0;
    jetsMoved = 0;
    extraJetsToMoveMissiles = [];
    extraPilotsToMoveMissiles = [];
    jetPilotMapping = [];
    jetDownTime = [];
    heloDownTime = 0;
    tempTempData = tempData;

    % figure out what jets/pilots groups are available at each time (hrs)

    % timespan (includes rest)
    heloTimeSpan = startTimeHr-1:(startTimeHr+maxSortieTimeHrs+heloRestTime);
    jetsTimeSpan = startTimeHr:(startTimeHr+maxSortieTimeHrs-1+jetRestTime);
    pilotsTimeSpan = startTimeHr:(startTimeHr+maxSortieTimeHrs-1+pilotRestTime);

    % get all carriers
    allCarriers = unique(JetsCarrierInfo(:,1));

    % find all available helos
    AvailableHelos = 1:NumHelos;
    for ii = heloTimeSpan
        AvailableHelos = intersect(AvailableHelos, find(HelosHoursInfo(:,ii)));
    end
    heloCarrierforAvailHelos = HelosCarrierInfo(AvailableHelos);
    uniqueHeloCarrierNumbers = unique(heloCarrierforAvailHelos);

    % find all available pilots
    AvailablePilots = 1:NumPilots;
    for ii = pilotsTimeSpan
        AvailablePilots = intersect(AvailablePilots, find(PilotsHoursInfo(:,ii)));
    end
    pilotCarrierforAvailPilots = PilotsCarrierInfo(AvailablePilots);

    % find all available jets
    AvailableJets = 1:NumJets;
    for ii = jetsTimeSpan
        AvailableJets = intersect(AvailableJets, find(JetsHoursInfo(:,ii)));
    end
    jetCarrierforAvailJets = JetsCarrierInfo(AvailableJets);

    if (isempty(AvailableJets))
        disp('No more jets available!');
        rerunAndIncrementStartTime = 1;
        return;  % go back out of the loop and rerun this with a new start time
    end

    % find any jets without a helo on the carrier
    AvailableJetsWithHelos = [];
    for ii = 1:length(jetCarrierforAvailJets)
        if ~isempty(intersect(jetCarrierforAvailJets(ii), uniqueHeloCarrierNumbers))
            AvailableJetsWithHelos = [AvailableJetsWithHelos; AvailableJets(ii)];
        end
    end
    jetCarrierforAvailJetsWithHelos = JetsCarrierInfo(AvailableJetsWithHelos);

    if (isempty(AvailableJetsWithHelos))
        disp('No helos available! Need to wait!');
        rerunAndIncrementStartTime = 1;
        return;  % go back out of the loop and rerun this with a new start time
    end

    % find carrier with more jets
    uniqueCarriers = unique(jetCarrierforAvailJetsWithHelos);
    currentCarrierJetInfo = zeros(length(uniqueCarriers), 2);
    currentCarrierJetInfo(:, 1) = uniqueCarriers; 
    for ii = 1:length(uniqueCarriers)
        currentCarrierJetInfo(ii, 2) = sum(jetCarrierforAvailJets == uniqueCarriers(ii));
    end
    tempIdx1 = find(currentCarrierJetInfo(:,2) >= numMissilesNeeded); % first assume each jet can carry only 1 missile
    carrierNumsCheck1 = currentCarrierJetInfo(tempIdx1,1);

    if isempty(carrierNumsCheck1)
        [maxJetNum, tmpIdx] = max(currentCarrierJetInfo(:,2));
        carrierWithMaxJets = currentCarrierJetInfo(tmpIdx,1);
        carriersToTry = setdiff(allCarriers, carrierWithMaxJets);
        jetCnt = 0;
        carrierToMoveJetsFrom = [];
        jetNumbersToMove = zeros(carriersToTry, NumJets);
        for ii = 1:carriersToTry
            if sum(jetCarrierforAvailJets == ii) > jetCnt
                jetCnt = jetCnt + sum(jetCarrierforAvailJets == ii);
                maxJetsToMoveCarriers(ii) = sum(jetCarrierforAvailJets == ii);
                jetNumbersToMove(ii, AvailableJets(find(jetCarrierforAvailJets == ii))) = 1;
                carrierToMoveJetsFrom = [carrierToMoveJetsFrom ii];
            end
        end
        if (maxJetNum + jetCnt >= numMissilesNeeded)
            % there are enough jets
            jetsToMoveCarriers = numMissilesNeeded - maxJetNum;
            pilotToMoveCarriers = jetsToMoveCarriers;
            % loop through carriers until get enough jets to move
            jetsStillNeeded = jetsToMoveCarriers;
            jetList = [];
            jetListMove = [];
            for ii = 1:carriersToTry
                completeJetNumbersToMove = find(jetNumbersToMove(ii,:));
                if (maxJetsToMoveCarriers(ii) >= jetsStillNeeded)
                    jetListMove = [jetListMove completeJetNumbersToMove(1:jetsStillNeeded)];
                    fprintf('Need to move at least %d jets/pilots from carrier %d!\n', jetsStillNeeded, ii);
                    jetsMoved = jetsMoved + jetsStillNeeded;
                    jetsStillNeeded = 0;
                    break;
                else
                    jetListMove = [jetListMove completeJetNumbersToMove(1:maxJetsToMoveCarriers(ii))];
                    fprintf('Need to move at least %d jets/pilots from carrier %d!\n', maxJetsToMoveCarriers(ii), ii);
                    jetsMoved = jetsMoved + maxJetsToMoveCarriers(ii);
                    jetsStillNeeded = jetsStillNeeded - maxJetsToMoveCarriers(ii);
                    if (jetsStillNeeded == 0)
                        break;
                    end
                end
            end
            % add jets from original carrier
            jetList = [AvailableJets(find(jetCarrierforAvailJets == carrierWithMaxJets))' jetListMove];
        else
            % there aren't enough jets
            disp('Not enough jets available! Need to wait!');
            rerunAndIncrementStartTime = 1;
            return;  % go back out of the loop and rerun this with a new start time
        end
    end

     % find carrier with more pilots
    currentCarrierPilotInfo = zeros(length(uniqueCarriers), 2);
    currentCarrierPilotInfo(:, 1) = uniqueCarriers; 
    for ii = 1:length(uniqueCarriers)
        currentCarrierPilotInfo(ii, 2) = sum(pilotCarrierforAvailPilots == uniqueCarriers(ii));
    end
    tempIdx2 = find(currentCarrierPilotInfo(:,2) >= numMissilesNeeded); % first assume each jet can carry only 1 missile
    carrierNumsCheck2 = currentCarrierPilotInfo(tempIdx2, 1);

    numPilotsNeeded = 0;
    if (isempty(carrierNumsCheck2) || isempty(carrierNumsCheck1))
        if isempty(carrierNumsCheck2)
            numPilotsNeeded = numMissilesNeeded;
        end
        if exist("carrierWithMaxJets")
            carrierWithMaxPilots = carrierWithMaxJets;
            tmpIdx = find(currentCarrierPilotInfo(:,1) == carrierWithMaxPilots);
            maxPilotNum = max(currentCarrierPilotInfo(tmpIdx,2));
            numPilotsNeeded = numPilotsNeeded + jetsMoved;
        else
            [maxPilotNum, tmpIdx] = max(currentCarrierPilotInfo(:,2));
            carrierWithMaxPilots = currentCarrierPilotInfo(tmpIdx,1);
        end
        carriersToTry = setdiff(allCarriers, carrierWithMaxPilots);
        pilotCnt = 0;
        carrierToMovePilotsFrom = [];
        pilotNumbersToMove = zeros(carriersToTry, NumJets);
        for ii = 1:carriersToTry
            if sum(pilotCarrierforAvailPilots == ii) > pilotCnt
                pilotCnt = pilotCnt + sum(pilotCarrierforAvailPilots == ii);
                maxPilotsToMoveCarriers(ii) = sum(pilotCarrierforAvailPilots == ii);
                pilotNumbersToMove(ii, AvailablePilots(find(pilotCarrierforAvailPilots == ii))) = 1;
                carrierToMovePilotsFrom = [carrierToMovePilotsFrom ii];
            end
        end

        if (maxPilotNum + pilotCnt >= numPilotsNeeded)
            % there are enough pilots
            pilotsToMoveCarriers = max(numPilotsNeeded - maxPilotNum, jetsMoved);
            pilotList = [];
            pilotListMove = [];
            heloList = [];
            % loop through carriers until get enough pilots to move
            pilotsStillNeeded = pilotsToMoveCarriers;
            for ii = 1:carriersToTry
                completePilotNumbersToMove = find(pilotNumbersToMove(ii,:));
                if (maxPilotsToMoveCarriers(ii) >= pilotsStillNeeded)
                    pilotListMove = [pilotListMove completePilotNumbersToMove(1:pilotsStillNeeded)];
                    fprintf('Need to move at least %d jets/pilots from carrier %d!\n', pilotsStillNeeded, ii);
                    pilotsStillNeeded = 0;
                    break;
                else
                    pilotListMove = [pilotListMove completePilotNumbersToMove(1:maxPilotsToMoveCarriers(ii))];
                    fprintf('Need to move at least %d jets/pilots from carrier %d!\n', maxPilotsToMoveCarriers(ii), ii);
                    pilotsStillNeeded = pilotsStillNeeded - maxPilotsToMoveCarriers(ii);
                    if (pilotsStillNeeded == 0)
                        break;
                    end
                end
            end

            % add pilots from original carrier
            pilotList = [AvailablePilots(find(pilotCarrierforAvailPilots == carrierWithMaxPilots))' pilotListMove];
               
            % use helos if not enough jets moved to other carrier
            if (pilotsToMoveCarriers - jetsMoved > 0)
                numHelosNeeded = ceil((pilotsToMoveCarriers - jetsMoved)/HeloMaxPilotsMoved);
                if (nnz(AvailableHelos) >= numHelosNeeded)
                    heloList = AvailableHelos(numHelosNeeded);
                    fprintf('Need to move %d pilots with %d helos', pilotsToMoveCarriers, nnz(heloList));
                else
                    % there are no helos to move pilots
                    disp('Not enough helos available to move pilots! Need to wait!');
                    rerunAndIncrementStartTime = 1;
                    return;  % go back out of the loop and rerun this with a new start time
                end
            end
        else
            % there aren't enough pilots
            disp('Not enough pilots available! Need to wait!');
            rerunAndIncrementStartTime = 1;
            return;  % go back out of the loop and rerun this with a new start time
        end
    end

    if exist("carrierWithMaxJets")
        carrierNumToUse = carrierWithMaxJets;
        jetsToUse = jetList';

        if (~exist("pilotList") || isempty(pilotList))
            availablePilotsToChoose = AvailablePilots(find(pilotCarrierforAvailPilots == carrierNumToUse));
        else
            availablePilotsToChoose = pilotList';
        end
    elseif exist("carrierWithMaxPilots")
        carrierNumToUse = carrierWithMaxPilots;
        if (~exist("jetList") || isempty(jetList))
            jetsToUse = AvailableJetsWithHelos(find(JetsCarrierInfo(AvailableJetsWithHelos) == carrierNumToUse));
        else
            jetsToUse = jetList';
        end
        availablePilotsToChoose = pilotList';
    else
        carrierNumToUse = intersect(carrierNumsCheck1,carrierNumsCheck2);
        if ~isempty(carrierNumToUse)
            carrierNumToUse = carrierNumToUse(1);
        else
            if ~isempty(carrierNumsCheck1)
                carrierNumToUse = carrierNumsCheck1(1);
            elseif ~isempty(carrierNumsCheck2)
                carrierNumToUse = carrierNumsCheck1(1);
            else
                carrierNumToUse = 1;
            end
        end

        % get jets on the carrier to use
        jetsToUse = AvailableJetsWithHelos(find(JetsCarrierInfo(AvailableJetsWithHelos) == carrierNumToUse));
        % get pilots on the carrier to use
        availablePilotsToChoose = AvailablePilots(find(pilotCarrierforAvailPilots == carrierNumToUse));
    end
    
    % find available jet and jet wings
    chosenJet = [];
    chosenWingJets = [];
    for ii = jetsToUse'      
        % find wing jet available in same carrier
        availableWingJets = find(JetsInfo(ii,:));
        wingJetsToUse = intersect(availableWingJets, jetsToUse');
        if (length(wingJetsToUse) >= max((numMissilesNeeded-1), 1))  % assume only 1 missile per jet first
            chosenWingJets = wingJetsToUse(1:max((numMissilesNeeded-1), 1));
            chosenJet = ii;
            break;
        end
    end

    if isempty(chosenJet) || isempty(chosenWingJets)
        disp('Need to move jets to carrier!');
        rerunAndIncrementStartTime = 1;
        return;  % go back out of the loop and rerun this with a new start time
    end

    chosenJets = [chosenJet chosenWingJets];
    missilesCarried = jetMissileStorage(chosenJets);
    numJetsNeeded = 0;
    tempSum = 0;
    for ii = 1:length(missilesCarried)
        tempSum = tempSum + missilesCarried(ii);
        if tempSum >= numMissilesNeeded
            numJetsNeeded = max(ii, 2);
            break;
        end
    end
    % update jet list
    chosenJets = chosenJets(1:numJetsNeeded);
    % update jet moved list
    updatedJetsToMove = 0;
    savedJetListMove = [];
    if exist('jetListMove')
        if length(jetListMove) ~= length(chosenJets)
            updatedJetsToMove = 1;
            saveJetListMove = jetListMove;
            jetListMove = intersect(jetListMove, chosenJets);
            if isempty(jetListMove)
                jetsMoved = 0;
            else
                jetsMoved = nnz(jetListMove);
            end
        end
    end

    % find available pilot and wing pilots
    chosenPilot = [];
    chosenWingPilots = [];
    chosenPilots = [];
    jetPilotMapping = zeros(length(chosenJets), 2);
    for ii = availablePilotsToChoose'      
        % find pilot available in same carrier
        availableWingPilots = find(PilotsInfo(ii,:));
        wingPilotsToUse = intersect(availableWingPilots, availablePilotsToChoose');
        if (length(wingPilotsToUse) >= (numJetsNeeded-1))
            % make sure that the pilots can fly the jets
            [~, sortIdx] = sort(sum(PilotJetsInfo(wingPilotsToUse, chosenJets), 2),'descend');
            failedFlag = 0;
            for jj = chosenJets
                if ((sum(PilotJetsInfo(wingPilotsToUse(sortIdx(1:(numJetsNeeded-1))), jj)) == 0) && ...
                    (PilotJetsInfo(ii, jj) == 0))
                    failedFlag = 1;
                end
            end
            
            if (~failedFlag)
                chosenWingPilots = wingPilotsToUse(1:(numJetsNeeded-1));
                chosenPilot = ii;
                chosenPilots = [chosenPilot chosenWingPilots];

                % map pilots to jets
                if (sum(sum(PilotJetsInfo(chosenPilots, chosenJets), 2))/length(chosenJets)) == length(chosenJets)
                    % all pilots can fly any jet
                    for jj = 1:length(chosenJets)
                        jetPilotMapping(jj, 1) = chosenJets(jj);
                        jetPilotMapping(jj, 2) = chosenPilots(jj);
                    end
                else
                    [~, sortIdx] = sort(sum(PilotJetsInfo(chosenPilots, chosenJets), 1), 'ascend');
                    tempChosenPilots = chosenPilots;
                    for jj = 1:length(chosenJets)
                        pilotsToPick = chosenPilots(find(PilotJetsInfo(tempChosenPilots, chosenJets(sortIdx(jj)))));
                        jetPilotMapping(jj, 1) = chosenJets(sortIdx(jj));
                        jetPilotMapping(jj, 2) = pilotsToPick(1);
                        tempChosenPilots = setdiff(tempChosenPilots, pilotsToPick(1));
                    end
                end

                break;
            end
        end
    end

    if isempty(chosenPilots)
        disp('Issue with having enough pilots that can fly the chosen jets! Need to wait!');
        rerunAndIncrementStartTime = 1;
        return;  % go back out of the loop and rerun this with a new start time
    end

    % update pilot moved list
    updatedPilotsToMove = 0;
    if exist('pilotListMove')
        pListMovedOrig = pilotListMove;
        if length(pListMovedOrig) ~= length(chosenPilots)
            updatedPilotsToMove = 1;
            pilotListMove = intersect(pListMovedOrig, chosenPilots);
            if isempty(pilotListMove)
                pilotsToMoveCarriers = 0;
            else
                pilotsToMoveCarriers = nnz(pilotListMove);
            end
        end
    end

    % get helo
    needHeloReposition = 0;
    chosenHelo = AvailableHelos(find(heloCarrierforAvailHelos == carrierNumToUse, 1, 'first'));
    if (exist("heloList") && ~isempty(heloList) && nnz(intersect(heloList, chosenHelo)) > 0 && ...
       (pilotsToMoveCarriers - jetsMoved > 0))
        % need to reposition helos
        needHeloReposition = 1;
        numHelosNeeded = ceil((pilotsToMoveCarriers - jetsMoved)/HeloMaxPilotsMoved);
        heloList = AvailableHelos(numHelosNeeded);
    end

    tempJetsHoursInfo = JetsHoursInfo;
    tempPilotsHoursInfo = PilotsHoursInfo;
    tempHelosHoursInfo = HelosHoursInfo;
    tempJetSortiesInfo = JetSortiesInfo;
    % add in jet reposition (4 hrs)
    if (jetsMoved > 0)
        tempJetsHoursInfo(jetListMove, startTimeHr:(startTimeHr+jetRepositionTime-1)) = 0;
        jetsRepositioned = jetListMove;
        pilotsRepositionedByJet = pilotListMove;
        tempPilotsHoursInfo(pilotsRepositionedByJet, startTimeHr:(startTimeHr+jetRepositionTime-1)) = 0;
        missionStartTimeHr = startTimeHr+jetRepositionTime;

        % fill  in tempData for checking constraints only
        tempData(jetListMove, startTimeHr:(startTimeHr+jetRepositionTime-1)) = 0.5;
        tempData(NumJets + pilotsRepositionedByJet, startTimeHr:(startTimeHr+jetRepositionTime-1)) = 0.5;
    end
    % add in pilot reposition (24 hrs) - jet reposition would be included
    % in this
    if (exist("heloList") && ~isempty(heloList))
        tempHelosHoursInfo(heloList, startTimeHr:(startTimeHr+pilotRepositionTime-1)) = 0;
        pilotsRepositionedByHelo = setdiff(pilotsToMoveCarriers, pilotsRepositionedByJet);
        tempPilotsHoursInfo(pilotsRepositionedByHelo, startTimeHr:(startTimeHr+pilotRepositionTime-1)) = 0;
        missionStartTimeHr = startTimeHr+pilotRepositionTime;

        % fill  in tempData for checking constraints only
        tempData(NumJets + NumPilots + heloList, startTimeHr:(startTimeHr+pilotRepositionTime-1)) = 0.5;
        tempData(NumJets + pilotsRepositionedByHelo, startTimeHr:(startTimeHr+pilotRepositionTime-1)) = 0.5;
    end
    % add in helo reposition (6 hrs)
    if needHeloReposition
        if isempty(pilotsRepositionedByHelo)
            tempHelosHoursInfo(chosenHelo, startTimeHr:(startTimeHr+heloRepositionTime-1)) = 0;
        else
            tempHelosHoursInfo(chosenHelo, missionStartTimeHr:(missionStartTimeHr+heloRepositionTime-1)) = 0;
        end
        helosRepositioned = chosenHelo;
        missionStartTimeHr = missionStartTimeHr+heloRepositionTime;

        % fill  in tempData for checking constraints only
        tempData(NumJets + NumPilots + chosenHelo, missionStartTimeHr:(missionStartTimeHr+pilotRepositionTime-1)) = 0.5;
    end

    % fill  in tempData for checking constraints only
    tempData(chosenJets, missionStartTimeHr:(missionStartTimeHr+maxSortieTimeHrs-1)) = 1;
    tempData(chosenJets, (missionStartTimeHr+maxSortieTimeHrs):(missionStartTimeHr+maxSortieTimeHrs+jetRestTime-1)) = 0.2;
    tempData(NumJets + chosenPilots, missionStartTimeHr:(missionStartTimeHr+maxSortieTimeHrs-1)) = 1;
    tempData(NumJets + chosenPilots, (missionStartTimeHr+maxSortieTimeHrs):(missionStartTimeHr+maxSortieTimeHrs+pilotRestTime-1)) = 0.2;
    tempData(NumJets + NumPilots + chosenHelo, missionStartTimeHr-1:(missionStartTimeHr+maxSortieTimeHrs)) = 1;
    tempData(NumJets + NumPilots + chosenHelo, (missionStartTimeHr+maxSortieTimeHrs+1):(missionStartTimeHr+maxSortieTimeHrs+heloRestTime)) = 0.2;
    dayNum = ceil(missionStartTimeHr/24);
    tempJetSortiesInfo(chosenJets, dayNum) = tempJetSortiesInfo(chosenJets, dayNum) + 1;

    % check flying constraints
    % check helo consecutive flying time
    consecHeloHrs = tempData(NumJets + NumPilots + chosenHelo, 1);
    listOfConsecHeloHrs = [];
    for rr = 2:length(tempData)
        if (tempData(NumJets + NumPilots + chosenHelo, rr) == 1)
            consecHeloHrs = consecHeloHrs + 1;
        elseif (consecHeloHrs > 0)
            listOfConsecHeloHrs = [listOfConsecHeloHrs consecHeloHrs];
            consecHeloHrs = 0;
        end
    end
    if (max(listOfConsecHeloHrs) > heloConsecFlyTime)
        disp('Helo cannot be airborne for this long! Need to wait!');
        rerunAndIncrementStartTime = 1;
        return;  % go back out of the loop and rerun this with a new start time
    end

    % check jet flying time per day and sorties per day
    for vv = 1:length(chosenJets)
        for dd = 1:(NumHours/24)
            dayHours = (dd-1)*24+1:(dd-1)*24+24;
            tmpIdx = find(tempData(chosenJets(vv), dayHours) == 1);
            if (nnz(tmpIdx) > jetFlyTimePerDay)
                disp('Jet cannot be airborne for this long in a day! Need to wait!');
                rerunAndIncrementStartTime = 1;
                return;  % go back out of the loop and rerun this with a new start time
            end

            if (tempJetSortiesInfo(chosenJets(vv), dd) > maxJetSortiesPerDay)
                disp('Jet cannot fly this many sorties in a day! Need to wait!');
                rerunAndIncrementStartTime = 1;
                return;  % go back out of the loop and rerun this with a new start time
            end
        end
    end

    % check pilot flying time per day
    for vv = 1:length(chosenPilots)
        for dd = 1:(NumHours/24)
            dayHours = (dd-1)*24+1:(dd-1)*24+24;
            tmpIdx = find(tempData(chosenPilots(vv), dayHours) == 1);
            if (nnz(tmpIdx) > jetPilotFlyTimePerDay)
                disp('Pilot cannot be airborne for this long in a day! Need to wait!');
                rerunAndIncrementStartTime = 1;
                return;  % go back out of the loop and rerun this with a new start time
            end
        end
    end

    % check maintenance
    for ii = 1:length(chosenJets)
        if (JetMaintenanceHrsAfterHrsInFlight(chosenJets(ii), 1) > 0)
            % jet needs maintenance eventually
            jetFlyingTime = nnz(find(tempData(chosenJets(ii), :) == 1 | tempData(chosenJets(ii), :) == 0.5));
            if (jetFlyingTime > JetMaintenanceHrsAfterHrsInFlight(chosenJets(ii), 1))
                % need to schedule the maintenance now (even if it is
                % early), but don't use this plane, and also zero out the
                % maintenance requirement after it is maintained
                hrsIdx = find(tempTempData(chosenJets(ii), :) == 1 | tempTempData(chosenJets(ii), :) == 0.5);
                if ~isempty(hrsIdx)
                    JetsHoursInfo(ii, hrsIdx(end)+1:hrsIdx(end) + JetMaintenanceHrsAfterHrsInFlight(chosenJets(ii), 2)) = 0;
                    JetMaintenanceHrsAfterHrsInFlight(chosenJets(ii), 1) = 0;
                    JetMaintenanceHrsAfterHrsInFlight(chosenJets(ii), 2) = 0;
                end
            end
        end
    end

    % check if need to reposition missiles
    msIdx = find(MissilesCarrierInfo == carrierNumToUse);
    if (nnz(msIdx) >= numMissilesNeeded)
        % have enough missiles on the carrier
        missilesToUse = msIdx(1:numMissilesNeeded);
    else
        % not enough missiles on the carrier
        numMissilesStillNeeded = numMissilesNeeded - nnz(msIdx);
        msFromOtherCarriersIdx = find(MissilesCarrierInfo ~= carrierNumToUse & MissilesCarrierInfo ~= 0);
        if (nnz(msFromOtherCarriersIdx) >= numMissilesStillNeeded)
            % have enough missiles if move some to the carrier
            missilesToMove = msFromOtherCarriersIdx(1:numMissilesStillNeeded);
            carriersToMoveMissilesFrom = MissilesCarrierInfo(missilesToMove);
            missilesToUse = [msIdx missilesToMove];

            spaceForMissilesOnRepoJets = 0;
            if (nnz(jetsRepositioned) > 0)
                for ff = 1:length(carriersToMoveMissilesFrom)
                    % jets are moving from the same carriers as the
                    % missiles, don't need to do anything extra
                    jIdx = find(JetCarrierInfo(jetsRepositioned) == carriersToMoveMissilesFrom(ff));
                    spaceForMissilesOnRepoJets = spaceForMissilesOnRepoJets + sum(jetMissileStorage(jIdx));
                end
            end
            numMissilesNeededToReposition = numMissilesStillNeeded - spaceForMissilesOnRepoJets;
            if (numMissilesNeededToReposition <= 0)
                % don't need to reposition missiles since enough jets
                % are being repositioned already
                disp(['Jets will be repositioned and those will take the needed ' num2str(numMissilesStillNeeded) ' missiles']);
            else
                % need to reposition missiles using any available jets
                jetsThatCanMoveMissiles = setdiff(AvailableJets, chosenJets);
                mCount = 0;
                jmCount = 0;
                for jj = 1:length(jetsThatCanMoveMissiles)
                    mCount = mCount + jetMissileStorage(jj);
                    jmCount = jmCount + 1;
                    if (mCount >= numMissilesNeededToReposition)
                        break;
                    end
                end
                if (jmCount > 0)
                    extraJetsToMoveMissiles = jetsThatCanMoveMissiles(1:jmCount);
                    fprintf('Need to move %d jets with %d missiles\n', nnz(extraJetsToMoveMissiles), numMissilesNeededToReposition);
                    tempJetsCarrierInfo(extraJetsToMoveMissiles) = carrierNumToUse;

                    % get pilots
                    extraJetsCarriers = JetsCarrierInfo(extraJetsToMoveMissiles, :);
                    pilotsThatCanMoveMissiles = setdiff(AvailablePilots, chosenPilots);
                    for ww = extraJetsCarriers'
                        pIdx = find(PilotsCarrierInfo(pilotsThatCanMoveMissiles) == ww);
                        if ~isempty(pIdx)
                            extraPilotsToMoveMissiles = [extraPilotsToMoveMissiles pilotsThatCanMoveMissiles(pIdx(1))];
                            fprintf('Need to move %d pilots with %d missiles', nnz(extraPilotsToMoveMissiles), numMissilesNeededToReposition);
                            tempPilotsCarrierInfo(extraPilotsToMoveMissiles) = carrierNumToUse;
                        else
                            disp('Don''t have enought pilots to move missiles! Need to wait!');
                            rerunAndIncrementStartTime = 1;
                            return;  % go back out of the loop and rerun this with a new start time
                        end
                    end
                else
                    disp('Don''t have enought jets to move missiles! Need to wait!');
                    rerunAndIncrementStartTime = 1;
                    return;  % go back out of the loop and rerun this with a new start time
                end
            end
        else
            % not enough missiles left
            missilesToUse = [];
        end
    end

    % add in missile reposition
    if ~isempty(extraJetsToMoveMissiles)
        tempJetsHoursInfo(extraJetsToMoveMissiles, startTimeHr:(startTimeHr+missileRepositionTime-1)) = 0;
        tempPilotsHoursInfo(extraPilotsToMoveMissiles, startTimeHr:(startTimeHr+missileRepositionTime-1)) = 0;
        missionStartTimeHr = max(missionStartTimeHr, startTimeHr+missileRepositionTime);
    end

    % down time for jets and helos are for when they get back from sorties,
    % not when they move things between carriers
    heloDownTime = 0;
    jetDownTime = zeros(1, length(chosenJets));
    if TurnOnPossibleJetHeloDownTime
        % roll dice to determine if helo needs additional downtime
        if (rand <= HeloDownTimeInfo(chosenHelo, 1))
            % need down time
            heloDownTime = HeloDownTimeInfo(chosenHelo, 2);
        else
            % don't need down time
        end
        for jj = 1:length(chosenJets)
            % roll dice to determine if jet needs additional downtime
            if (rand <= JetDownTimeInfo(chosenJets(jj), 1))
                % need down time
                jetDownTime(jj) = JetDownTimeInfo(chosenJets(jj), 2);
            else
                % don't need down time
            end
        end
    end
        
    % update pilot/jet/carrier data information given what was chosen 
    for jj = 1:length(chosenJets)
        tempJetsHoursInfo(chosenJets(jj), missionStartTimeHr:(missionStartTimeHr+maxSortieTimeHrs-1+jetRestTime+jetDownTime(jj))) = 0;
    end
    tempPilotsHoursInfo(chosenPilots, missionStartTimeHr:(missionStartTimeHr+maxSortieTimeHrs-1+pilotRestTime)) = 0;
    tempHelosHoursInfo(chosenHelo, missionStartTimeHr-1:(missionStartTimeHr+maxSortieTimeHrs+heloRestTime+heloDownTime)) = 0;

    % output what the front end needs
    % jet sortie data
    JetSortieData(sortieNumber).repositionedJets = jetsRepositioned;
    JetSortieData(sortieNumber).startRepositionTimeHr = startTimeHr;
    JetSortieData(sortieNumber).endRepositionTimeHr = startTimeHr+jetRepositionTime-1;
    JetSortieData(sortieNumber).jetsUsedToRepositionMissiles = extraJetsToMoveMissiles;
    JetSortieData(sortieNumber).startMissileRepositionTimeHr = startTimeHr;
    JetSortieData(sortieNumber).endMissileRepositionTimeHr = startTimeHr+missileRepositionTime-1;
    JetSortieData(sortieNumber).jetsToFlySortie = chosenJets;
    JetSortieData(sortieNumber).startSortieTimeHr = missionStartTimeHr;
    JetSortieData(sortieNumber).endSortieTimeHr = missionStartTimeHr+maxSortieTimeHrs-1;
    JetSortieData(sortieNumber).jetsNeedingRestDownTime = chosenJets;
    JetSortieData(sortieNumber).startRestDownTimeHr = missionStartTimeHr+maxSortieTimeHrs;
    for jj = 1:length(chosenJets)
        JetSortieData(sortieNumber).endRestDownTimeHr = missionStartTimeHr+maxSortieTimeHrs-1+jetRestTime+jetDownTime(jj);
    end
    % pilot sortie data
    PilotSortieData(sortieNumber).repositionedPilotsByJet = pilotsRepositionedByJet;
    PilotSortieData(sortieNumber).startRepositionByJetTimeHr = startTimeHr;
    PilotSortieData(sortieNumber).endRepositionByJetTimeHr = startTimeHr+jetRepositionTime-1;
    PilotSortieData(sortieNumber).repositionedPilotsByHelo = pilotsRepositionedByHelo;
    PilotSortieData(sortieNumber).startRepositionByHeloTimeHr = startTimeHr;
    PilotSortieData(sortieNumber).endRepositionByHeloTimeHr = startTimeHr+pilotRepositionTime-1;
    PilotSortieData(sortieNumber).pilotsUsedToRepositionMissiles = extraPilotsToMoveMissiles;
    PilotSortieData(sortieNumber).startMissileRepositionTimeHr = startTimeHr;
    PilotSortieData(sortieNumber).endMissileRepositionTimeHr = startTimeHr+missileRepositionTime-1;
    PilotSortieData(sortieNumber).pilotsToFlySortie = chosenPilots;
    PilotSortieData(sortieNumber).startSortieTimeHr = missionStartTimeHr;
    PilotSortieData(sortieNumber).endSortieTimeHr = missionStartTimeHr+maxSortieTimeHrs-1;
    PilotSortieData(sortieNumber).pilotsNeedingRestTime = chosenPilots;
    PilotSortieData(sortieNumber).startRestTimeHr = missionStartTimeHr+maxSortieTimeHrs;
    PilotSortieData(sortieNumber).endRestTimeHr = missionStartTimeHr+maxSortieTimeHrs-1+pilotRestTime;
    % helo sortie data
    HeloSortieData(sortieNumber).repositionedHelos = helosRepositioned;
    if isempty(pilotsRepositionedByHelo)
        HeloSortieData(sortieNumber).startRepositionTimeHr = startTimeHr;
        HeloSortieData(sortieNumber).endRepositionTimeHr = startTimeHr+heloRepositionTime-1;
    else
        HeloSortieData(sortieNumber).startRepositionTimeHr = startTimeHr+pilotRepositionTime;
        HeloSortieData(sortieNumber).endRepositionTimeHr = startTimeHr+pilotRepositionTime+heloRepositionTime-1;
    end
    HeloSortieData(sortieNumber).helosToFlySortie = chosenHelo;
    HeloSortieData(sortieNumber).startSortieTimeHr = missionStartTimeHr-1;
    HeloSortieData(sortieNumber).endSortieTimeHr = missionStartTimeHr+maxSortieTimeHrs;
    HeloSortieData(sortieNumber).helosNeedingRestDownTime = chosenHelo;
    HeloSortieData(sortieNumber).startRestDownTimeHr = missionStartTimeHr+maxSortieTimeHrs+1;
    HeloSortieData(sortieNumber).endRestDownTimeHr = missionStartTimeHr+maxSortieTimeHrs+heloRestTime+heloDownTime;

    % set results
    JetsHoursInfo = tempJetsHoursInfo;
    PilotsHoursInfo = tempPilotsHoursInfo;
    HelosHoursInfo = tempHelosHoursInfo;
    JetSortiesInfo = tempJetSortiesInfo;
    MissilesCarrierInfo(missilesToUse) = 0;

    % display results
    fprintf('\nSortie for Target: %d\n', targetNumber)
    fprintf('Mission Start Time (hrs): %d\n', missionStartTimeHr);
    fprintf('Carrier Chosen: %d\n', carrierNumToUse);
    fprintf('Jets Chosen: %d', chosenJet);
    for ii = chosenWingJets
        fprintf(', %d', ii);
    end
    fprintf('\nHelo Chosen: %d\n', chosenHelo);
    fprintf('Pilots Chosen: %d', chosenPilot);
    for ii = chosenWingPilots
        fprintf(', %d', ii);
    end
    fprintf('\nMissiles Chosen: ');
    for ii = 1:length(missilesToUse)-1
        fprintf('%d, ', missilesToUse(ii));
    end
    if (length(missilesToUse) >= 1)
        fprintf('%d\n', missilesToUse(length(missilesToUse)));
    else
        fprintf('\n');
    end
    fprintf('Number of Missiles Needed: %d\n', numMissilesNeeded);
end

function createSchedule(data, numJets, numHelos, numPilots)

    dataString1 = 'Jets';
    dataString2 = 'Helos ';
    dataString3 = 'Pilots ';
    numDataToPlot = size(data,1); % jets by hr
    [y,x] = ndgrid(1:numDataToPlot,1:size(data,2));
    c = repelem(1:numDataToPlot,size(data,2),1).';
    scatter(x(:),y(:),data(:)*100+1,c(:),'filled')
    clr = cool(numDataToPlot); % make a color map
    colormap(clr)
    title('Time Period')
    ax = gca;
    ax.XAxisLocation = 'top';
    ax.XAxis.TickValues(1) = [];
    ax.YAxis.Direction = 'reverse';
    maxStringSize = 10;
    data = [[repmat(dataString1,numJets,1) num2str((1:numJets).') repmat(' ',numJets,maxStringSize-length(dataString1)-length(num2str(numJets)))];
            [repmat(dataString2,numHelos,1) num2str((1:numHelos).') repmat(' ',numHelos,maxStringSize-length(dataString2)-length(num2str(numHelos)))];
            [repmat(dataString3,numPilots,1) num2str((1:numPilots).') repmat(' ',numPilots,maxStringSize-length(dataString3)-length(num2str(numPilots)))]];
    for k = 1:numDataToPlot
        text(ax.XAxis.Limits(1)-7,k,data(k,:),'Color',clr(k,:),...
            'HorizontalAlignment','left');
    end
    ax.YAxis.Visible = 'off'; % remove the original labels
end

function [data] = plotSchedule(chosenJets, chosenHelo, chosenPilots, extraJetsToMoveMissiles, ...
    extraPilotsToMoveMissiles, pilotsRepositionedByJet, jetsRepositioned, pilotsRepositionedByHelo, helosRepositioned, ...
    startTime, missionStartTimeHr, maxSortieTimeHrs, jetRestTime, heloRestTime, pilotRestTime, ...
    jetRepositionTime, pilotRepositionTime, heloRepositionTime, missileRepositionTime, jetDownTime, heloDownTime, ...
    data, NumJets, NumHelos, NumPilots)

    % plot
    % fill in jet data
        % reposition time
        data(jetsRepositioned, startTime:(startTime+jetRepositionTime-1)) = 0.5;
        % missile reposition time
        data(extraJetsToMoveMissiles, startTime:(startTime+missileRepositionTime-1)) = 0.3;
        % fly time
        data(chosenJets, missionStartTimeHr:(missionStartTimeHr+maxSortieTimeHrs-1)) = 1;
        % rest time (8 hrs) and downtime, if any
        if isempty(jetDownTime)
            data(chosenJets, (missionStartTimeHr+maxSortieTimeHrs):(missionStartTimeHr+maxSortieTimeHrs-1+jetRestTime)) = 0.1;
        else
            for ii = 1:length(chosenJets)
                data(chosenJets(ii), (missionStartTimeHr+maxSortieTimeHrs): ...
                    (missionStartTimeHr+maxSortieTimeHrs-1+jetRestTime+jetDownTime(ii))) = 0.1;
            end
        end
    % fill in helo data
        % reposition time
        if isempty(pilotsRepositionedByHelo)
            data(NumJets + helosRepositioned, startTime:(startTime+heloRepositionTime-1)) = 0.5;
        else
            data(NumJets + helosRepositioned, startTime+pilotRepositionTime:(startTime+pilotRepositionTime+heloRepositionTime-1)) = 0.5;
        end
        % fly time
        data(NumJets + chosenHelo, missionStartTimeHr-1:(missionStartTimeHr+maxSortieTimeHrs)) = 1;
        % rest time (12 hrs) and downtime, if any
        data(NumJets + chosenHelo, (missionStartTimeHr+maxSortieTimeHrs+1): ...
            (missionStartTimeHr+maxSortieTimeHrs+heloRestTime+heloDownTime)) = 0.1;
    % fill in pilot data
        % reposition time
        data(NumJets + NumHelos + pilotsRepositionedByJet, startTime:(startTime+jetRepositionTime-1)) = 0.5;
        data(NumJets + NumHelos + pilotsRepositionedByHelo, startTime:(startTime+pilotRepositionTime-1)) = 0.5;
        % missile repositon time
        data(NumJets + NumHelos + extraPilotsToMoveMissiles, startTime:(startTime+missileRepositionTime-1)) = 0.3;
        % fly time
        data(NumJets + NumHelos + chosenPilots, missionStartTimeHr:(missionStartTimeHr+maxSortieTimeHrs-1)) = 1;
        % rest time (16 hrs)
        data(NumJets + NumHelos + chosenPilots, (missionStartTimeHr+maxSortieTimeHrs):(missionStartTimeHr+maxSortieTimeHrs-1+pilotRestTime)) = 0.1;
    % create schedule
    createSchedule(data, NumJets, NumHelos, NumPilots);
end

function [IndProbKillsIfTgtIdxStrk, TgtToIdxToKill, DestroyOrDisableFlags, sortieTimesAgainstTarget, ...
    percentOfJetsThatGetKilledIfAttacked] = targetInfoSetup()

    % individual probabilities that target (row #) will kill for 
    % other targets (T1 - T6) (col #) if those targets are striked
    % columns: target indices striked
    % rows: target that will attack if the target of the column is striked
    IndProbKillsIfTgtIdxStrk = [0    0    0   0   0   0;
                                0    0    0   0   0   0;
                                0.25 0    0.3 0   0   0;
                                0    0    0.3 0.3 0   0;
                                0.15 0.15 0   0   0.4 0;
                                0.15 0.15 0   0   0   0.4];
    
    % targets to kill
    TgtToIdxToKill = [1 2 3 4 5 6];

    % flags for destroy or disable targets in target list
    DestroyOrDisableFlags = [1 0 0 0 0 0];

    % sortie times
    % min/ max times in hrs
    sortieTimesAgainstTarget = [2 4;
                                3 5;
                                2 4;
                                3 5;
                                4 6;
                                4 6];

    % percent of jets/pilots that will get killed if target attacks
    percentOfJetsThatGetKilledIfAttacked = .5;
end

function [TgtStrikeOrder, OrderedDestroyOrDisableFlags, OrderedSortieTimesAgainstTarget, ...
    OrderedChanceGetKilledIfStriked] = determineTargetStrikingOrder( ...
    IndProbKillsIfTgtIdxStrk, TgtToIdxToKill, DestroyOrDisableFlags, ...
    sortieTimesAgainstTarget)

    % probability of getting killed if attack the target (at index)
    ChanceGetKilledIfStriked = 1 - prod(1 - IndProbKillsIfTgtIdxStrk,1);

    % probability of getting killed if strike all targets but no targets destroyed
    GetKilledProbIfStrikeAll = 1 - prod(1 - ChanceGetKilledIfStriked);
    
    % determine order to strike targets
    TgtStrikeOrder = zeros(1, size(IndProbKillsIfTgtIdxStrk,2));
    LiveProbability = zeros(1, size(IndProbKillsIfTgtIdxStrk,2));
    ProbGetKilledIfStrikeThisTgt = zeros(1, size(IndProbKillsIfTgtIdxStrk,2));

    for aa = 1:length(TgtStrikeOrder)
        
        idxToUse = find(TgtStrikeOrder == 0);
        ProbGetKilledIfTgtStriked = zeros(1, length(idxToUse));
        for ii = 1:length(idxToUse)
            % don't use successfully striked targets
            tempProbGetKilledIfTgtStriked = IndProbKillsIfTgtIdxStrk(idxToUse,idxToUse);
    
            % check for what happens when striking the next target if the next
            % target is the index
            if (intersect(idxToUse(ii), TgtToIdxToKill))
                tempProbGetKilledIfTgtStriked(ii,:) = zeros(1,length(idxToUse));
            end
            tempChanceGetKilledIfStriked = 1 - prod(1 - tempProbGetKilledIfTgtStriked,1);
            % probability get killed striking rest of targets after the target (at index) is destroyed
            ProbGetKilledIfTgtStriked(ii) = 1 - prod(1 - tempChanceGetKilledIfStriked);
        end
        % impact to GetKilledProbIfStrikeAll if target is destroyed
        GoodImpactIfTgtStriked = GetKilledProbIfStrikeAll - ProbGetKilledIfTgtStriked;
        % probability of not getting killed striking rest of targets after the target (at index) is destroyed
        LiveProbabilityIfTgtStriked = (1 - ProbGetKilledIfTgtStriked);
        
        % normalize
        LiveProbabilityIfTgtStrikedNorm = LiveProbabilityIfTgtStriked/sum(LiveProbabilityIfTgtStriked);
        GoodImpactIfTgtStrikedNorm = GoodImpactIfTgtStriked/sum(GoodImpactIfTgtStriked);
        CombinedLiveAndGoodImpactProbs = LiveProbabilityIfTgtStrikedNorm + GoodImpactIfTgtStrikedNorm;
        
        % add to target strike order
        idx = find(CombinedLiveAndGoodImpactProbs == max(CombinedLiveAndGoodImpactProbs),1,'first');
        TgtStrikeOrder(idxToUse(idx)) = aa;
        ProbGetKilledIfStrikeThisTgt(idxToUse(idx)) = ProbGetKilledIfTgtStriked(idx);
        
        % probability of survival
        LiveProbability(idxToUse(idx)) = LiveProbabilityIfTgtStriked(idx);
    end
    
    OrderedDestroyOrDisableFlags = DestroyOrDisableFlags(TgtStrikeOrder);
    OrderedSortieTimesAgainstTarget = sortieTimesAgainstTarget(TgtStrikeOrder, :);
    OrderedChanceGetKilledIfStriked = ChanceGetKilledIfStriked(TgtStrikeOrder);

    % survivability
    probNotGetKilled = 1;
    for ii = TgtToIdxToKill
        probNotGetKilled = probNotGetKilled * (1 - ProbGetKilledIfStrikeThisTgt(ii));
    end
    
    disp(['Target Strike Order: ' num2str(TgtStrikeOrder)]);
    disp(['% Chance Get Killed: ' num2str(ProbGetKilledIfStrikeThisTgt)]);
    disp(['Survivability Probability: ' num2str(probNotGetKilled*100) '%']);
end

function [numMissilesPerTarget, numMissilesNeededForTgt] = missileInfoSetup(OrderedDestroyOrDisableFlags)
    ProbNeededToDisableTgt = 0.9;
    ProbNeededToDestroyTgt = 0.9;
    MissileHitProbability = 0.6;
    HitProbilityOfDestroy = 0.5; % if not destroyed, then disabled
    
    % probability of missile to disable or destroy a target
    ProbMissileDisablesOrDestroysTgt = MissileHitProbability;
    ProbTgtNotDisabled = 1 - ProbMissileDisablesOrDestroysTgt;

    % probability of missile to destroy target
    ProbMissileDestroysTgt = MissileHitProbability * HitProbilityOfDestroy;
    ProbTgtNotDestroyed = 1 - ProbMissileDestroysTgt;
    
    % number of missiles needed to disable a target
    %ProbTgtNotDisabled^NumMissilesNeeded = 1 - ProbNeededToDisableTgt;
    NumMissilesNeededToDisableTarget = ceil(log10(1 - ProbNeededToDisableTgt)/log10(ProbTgtNotDisabled));

    % number of missiles needed to destroy a target
    %ProbTgtNotDisabled^NumMissilesNeeded = 1 - ProbNeededToDisableTgt;
    NumMissilesNeededToDestroyTarget = ceil(log10(1 - ProbNeededToDestroyTgt)/log10(ProbTgtNotDestroyed));
    
    fprintf('Num Missiles Needed for %d%% Success Disabling Target: %i\n', ProbNeededToDisableTgt*100, NumMissilesNeededToDisableTarget);
    fprintf('Num Missiles Needed for %d%% Success Destroying Target: %i\n\n', ProbNeededToDisableTgt*100, NumMissilesNeededToDestroyTarget);

    % figure out how many missiles are needed for each target
    numMissilesPerTarget = NumMissilesNeededToDisableTarget * ones(1, length(OrderedDestroyOrDisableFlags));
    for ii = 1:length(OrderedDestroyOrDisableFlags)
        if (OrderedDestroyOrDisableFlags(ii))
            numMissilesPerTarget(ii) = NumMissilesNeededToDestroyTarget;
        end
    end

    disp(['Num Missiles Needed for each Target: ' num2str(numMissilesPerTarget)]);

    % roll a dice to see if a target is disabled or destroyed per missile
    % on target
    numMissilesNeededForTgt = numMissilesPerTarget;
    for tgtIdx = 1:length(OrderedDestroyOrDisableFlags)
        for nMissile = 1:numMissilesPerTarget
            % determine if missile hits the target
            if (rand <= MissileHitProbability)
                % hit
                if (rand <= HitProbilityOfDestroy)
                    % destroy
                    numMissilesNeededForTgt(tgtIdx) = nMissile;
                    break;
                else
                    % disable
                    if (OrderedDestroyOrDisableFlags(tgtIdx) == 1)
                        % need to destroy
                    else
                        % disable is good enough
                        numMissilesNeededForTgt(tgtIdx) = nMissile;
                        break;
                    end
                end
            else
                % miss
            end
        end
    end

    disp(['Num Missiles Actually Used for each Target: ' num2str(numMissilesNeededForTgt)]);
end