close all; clear all; clc;

% restraints/constraints that users will need to handle
% Jet 5 will need 48 hours of maintenance after it's first 10 hours of flight
% Jet 4, 8, 9 , and 17 can only carry one missile
% Each Helo has a 30% chance of needing 16 hours of down-time after landing at it's home carrier for that day
% Each Jet has a 20% chance of needing 24 hours of downtime after each landing at it's home carrier for that day
% hotseats - 30 min
% Each carrier can accommodate 2x hotseats at a time in any combination of jet or helo

% 24 hrs to shuffle pilots in helo
% 12 hrs to shuffle missiles in jet/jet pilot (2way trip)
% 4 hrs to shuffle jets
% It takes six hours occupies 1 helo and 1 helo crew to reposition that helo between carriers
% Helos may not be airborne for more than 8 hours
% Each jet may fly 3 sorties per day, but may not be airborne for more than 16 hours in a day
% Each Jet Pilot may only fly for 16 hours in a day, but may fly more than one Jet in a day (hotseat time counts against their max duty time for the day)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine Target Striking Order %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% individual probabilities that target (row #) will kill for 
% other targets (T1 - T6) (col #) if those targets are striked
IndProbKillsIfTgtIdxStrk = [0    0    0   0   0   0;
                            0    0    0   0   0   0;
                            0.25 0    0.3 0   0   0;
                            0    0    0.3 0.3 0   0;
                            0.15 0.15 0   0   0.4 0;
                            0.15 0.15 0   0   0   0.4];

% targets to kill
TgtToIdxToKill = [1 2 3 4 5 6];

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

% survivability
probNotGetKilled = 1;
for ii = TgtToIdxToKill
    probNotGetKilled = probNotGetKilled * (1 - ProbGetKilledIfStrikeThisTgt(ii));
end

disp(['Target Strike Order: ' num2str(TgtStrikeOrder)]);
disp(['% Chance Get Killed: ' num2str(ProbGetKilledIfStrikeThisTgt)]);
disp(['Survivability Probability: ' num2str(probNotGetKilled*100) '%']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine Number of Missiles Needed for Targets %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ProbNeededToDisableTgt = 0.9;
MissileHitProbability = 0.6;
HitProbilityOfDisable = 0.5;
NumMissilesPerJet = 2;
% probability of missile to disable target
ProbMissileDisablesTgt = MissileHitProbability * HitProbilityOfDisable;
ProbTgtNotDisabled = 1 - ProbMissileDisablesTgt;
% number of missiles needed
%ProbTgtNotDisabled^NumMissilesNeeded = 1 - ProbNeededToDisableTgt;
NumMissilesNeeded = ceil(log10(1 - ProbNeededToDisableTgt)/log10(ProbTgtNotDisabled));
% number of sorties needed assuming max weapons capacity
NumSortiesNeeded = ceil(NumMissilesNeeded/NumMissilesPerJet);

fprintf('Num Missiles Needed for %d%% Success Disabling Target: %i\n', ProbNeededToDisableTgt*100, NumMissilesNeeded);
fprintf('Num Sorties Needed for %d%% Success Disabling Target: %i\n\n', ProbNeededToDisableTgt*100, NumSortiesNeeded);


%%%%%%%%%%%%%
% Timeline  %
%%%%%%%%%%%%%
[NumJets, NumPilots, NumHelos, NumHours, jetRestTime, heloRestTime, pilotRestTime, ...
    jetRepositionTime, pilotRepositionTime, heloRepositionTime, ...
    JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    data] = setUp();

% have to add schedules with start times >= than the last start time
startTimeHr = 24;
maxSortieTimeHrs = 4;
numJetsNeeded = 4;
[JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    data] = ...
    AddToSchedule(startTimeHr, maxSortieTimeHrs, numJetsNeeded, ...
    NumJets, NumPilots, NumHelos, NumHours, ...
    JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    jetRestTime, heloRestTime, pilotRestTime, jetRepositionTime, pilotRepositionTime, heloRepositionTime, data);

startTimeHr = 24;
maxSortieTimeHrs = 6;
numJetsNeeded = 4;
[JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    data] = ...
    AddToSchedule(startTimeHr, maxSortieTimeHrs, numJetsNeeded, ...
    NumJets, NumPilots, NumHelos, NumHours, ...
    JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    jetRestTime, heloRestTime, pilotRestTime, jetRepositionTime, pilotRepositionTime, heloRepositionTime, data);

startTimeHr = 37;
maxSortieTimeHrs = 6;
numJetsNeeded = 4;
[JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    data] = ...
    AddToSchedule(startTimeHr, maxSortieTimeHrs, numJetsNeeded, ...
    NumJets, NumPilots, NumHelos, NumHours, ...
    JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    jetRestTime, heloRestTime, pilotRestTime, jetRepositionTime, pilotRepositionTime, heloRepositionTime, data);

startTimeHr = 40;
maxSortieTimeHrs = 4;
numJetsNeeded = 5;
[JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    data] = ...
    AddToSchedule(startTimeHr, maxSortieTimeHrs, numJetsNeeded, ...
    NumJets, NumPilots, NumHelos, NumHours, ...
    JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    jetRestTime, heloRestTime, pilotRestTime, jetRepositionTime, pilotRepositionTime, heloRepositionTime, data);

startTimeHr = 45;
maxSortieTimeHrs = 4;
numJetsNeeded = 5;
[JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    data] = ...
    AddToSchedule(startTimeHr, maxSortieTimeHrs, numJetsNeeded, ...
    NumJets, NumPilots, NumHelos, NumHours, ...
    JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    jetRestTime, heloRestTime, pilotRestTime, jetRepositionTime, pilotRepositionTime, heloRepositionTime, data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    data] = ...
    AddToSchedule(startTimeHr, maxSortieTimeHrs, numJetsNeeded, ...
    NumJets, NumPilots, NumHelos, NumHours, ...
    JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    jetRestTime, heloRestTime, pilotRestTime, jetRepositionTime, pilotRepositionTime, heloRepositionTime, data)

    % choose jets, helo, pilots for a sortie
    [chosenJets, chosenHelo, chosenPilots, missionStartTimeHr, ...
        JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
        PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
        pilotsRepositionedByJet, jetsRepositioned, pilotsRepositionedByHelo, helosRepositioned] = ...
        chooseJetsHeloPilots(startTimeHr, maxSortieTimeHrs, numJetsNeeded, ...
        NumJets, NumPilots, NumHelos, NumHours, ...
        JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
        PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
        jetRestTime, heloRestTime, pilotRestTime, jetRepositionTime, pilotRepositionTime, heloRepositionTime);

    % plot schedule
    data = plotSchedule(chosenJets, chosenHelo, chosenPilots, ...
        pilotsRepositionedByJet, jetsRepositioned, pilotsRepositionedByHelo, helosRepositioned, ...
        startTimeHr, missionStartTimeHr, maxSortieTimeHrs, jetRestTime, heloRestTime, pilotRestTime, ...
        jetRepositionTime, pilotRepositionTime, heloRepositionTime, ...
        data, NumJets, NumHelos, NumPilots);
end

function createSchedule(data, numJets, numHelos, numPilots)

    dataString1 = 'Jets';
    dataString2 = 'Helos ';
    dataString3 = 'Pilots ';
    numDataToPlot = size(data,1); % jets by hr
    [y,x] = ndgrid(1:numDataToPlot,1:size(data,2));
    c = repelem(1:numDataToPlot,size(data,2),1).';
    scatter(x(:),y(:),data(:)*100+1,c(:),'filled')
    clr = lines(numDataToPlot);
    colormap(clr)
    title('Time Period')
    ax = gca;
    ax.XAxisLocation = 'top';
    ax.XAxis.TickValues(1) = [];
    clr = lines(numDataToPlot); % make a color map
    ax.YAxis.Direction = 'reverse';
    maxStringSize = 10;
    data = [[repmat(dataString1,numJets,1) num2str((1:numJets).') repmat(' ',numJets,maxStringSize-length(dataString1)-length(num2str(numJets)))];
           [repmat(dataString2,numHelos,1) num2str((1:numHelos).') repmat(' ',numHelos,maxStringSize-length(dataString2)-length(num2str(numHelos)))];
           [repmat(dataString3,numPilots,1) num2str((1:numPilots).') repmat(' ',numPilots,maxStringSize-length(dataString3)-length(num2str(numPilots)))]];
    x = repelem(ax.XAxis.Limits(1)-0.05,numDataToPlot); % make an x position vector
    for k = 1:numDataToPlot
        text(ax.XAxis.Limits(1)-0.05,k,data(k,:),'Color',clr(k,:),...
            'HorizontalAlignment','right');
    end
    ax.YAxis.Visible = 'off'; % remove the original labels
end

function [NumJets, NumPilots, NumHelos, NumHours, jetRestTime, heloRestTime, pilotRestTime, ...
    jetRepositionTime, pilotRepositionTime, heloRepositionTime, ...
    JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo,PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    data] = setUp()

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

    % set up data to plot schedule
    data = zeros(NumJets + NumHelos + NumPilots, NumHours);
end

function [chosenJets, chosenHelo, chosenPilots, missionStartTimeHr,...
    JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    pilotsRepositionedByJet, jetsRepositioned, pilotsRepositionedByHelo, helosRepositioned] = ...
    chooseJetsHeloPilots(startTimeHr, maxSortieTimeHrs, numJetsNeeded, ...
    NumJets, NumPilots, NumHelos, NumHours, ...
    JetsInfo, JetsHoursInfo, JetsCarrierInfo, PilotsInfo, PilotJetsInfo, ...
    PilotsHoursInfo, PilotsCarrierInfo, HelosHoursInfo, HelosCarrierInfo, HeloCrewsCarrierInfo, ...
    jetRestTime, heloRestTime, pilotRestTime, jetRepositionTime, pilotRepositionTime, heloRepositionTime)

    % figure out what jets/pilots groups are available at each time (hrs)

    % timespan (includes rest)
    heloTimeSpan = startTimeHr-1:(startTimeHr+maxSortieTimeHrs+heloRestTime);
    jetsTimeSpan = startTimeHr:(startTimeHr+maxSortieTimeHrs-1+jetRestTime);
    pilotsTimeSpan = startTimeHr:(startTimeHr+maxSortieTimeHrs-1+pilotRestTime);

    % get all carriers
    allCarriers = unique(JetsCarrierInfo(:,1));
    jetsToMoveCarriers = 0;
    maxJetsToMoveCarriers = 0;
    pilotsToMoveCarriers = 0;
    jetsMoved = 0;

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
        keyboard;
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
        keyboard;
    end

    % find carrier with more jets
    uniqueCarriers = unique(jetCarrierforAvailJetsWithHelos);
    currentCarrierJetInfo = zeros(length(uniqueCarriers), 2);
    currentCarrierJetInfo(:, 1) = uniqueCarriers; 
    for ii = 1:length(uniqueCarriers)
        currentCarrierJetInfo(ii, 2) = sum(jetCarrierforAvailJets == uniqueCarriers(ii));
    end
    tempIdx1 = find(currentCarrierJetInfo(:,2) >= numJetsNeeded);
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
        if (maxJetNum + jetCnt >= numJetsNeeded)
            % there are enough jets
            jetsToMoveCarriers = numJetsNeeded - maxJetNum;
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
            keyboard;
        end
    end

     % find carrier with more pilots
    currentCarrierPilotInfo = zeros(length(uniqueCarriers), 2);
    currentCarrierPilotInfo(:, 1) = uniqueCarriers; 
    for ii = 1:length(uniqueCarriers)
        currentCarrierPilotInfo(ii, 2) = sum(pilotCarrierforAvailPilots == uniqueCarriers(ii));
    end
    tempIdx2 = find(currentCarrierPilotInfo(:,2) >= numJetsNeeded);
    carrierNumsCheck2 = currentCarrierPilotInfo(tempIdx2, 1);

    if isempty(carrierNumsCheck2)
        if exist("carrierWithMaxJets")
            carrierWithMaxPilots = carrierWithMaxJets;
            tmpIdx = find(currentCarrierPilotInfo(:,1) == carrierWithMaxPilots);
            maxPilotNum = max(currentCarrierPilotInfo(tmpIdx,2));
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

        if (maxPilotNum + pilotCnt >= numJetsNeeded)
            % there are enough pilots
            pilotsToMoveCarriers = numJetsNeeded - maxPilotNum;
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
                % helos can seat 2 jet pilots max
                HeloMaxPilotsMoved = 2;
                numHelosNeeded = ceil((pilotsToMoveCarriers - jetsMoved)/HeloMaxPilotsMoved);
                if (nnz(AvailableHelos) >= numHelosNeeded)
                    heloList = AvailableHelos(numHelosNeeded);
                    fprintf('Need to move %d pilots with %d helos', pilotsToMoveCarriers, nnz(heloList));
                else
                    % there are no helos to move pilots
                    disp('Not enough helos available to move pilots! Need to wait!');
                    keyboard;
                end
            end
        else
            % there aren't enough pilots
            disp('Not enough pilots available! Need to wait!');
            keyboard;
        end
    end

    if exist("carrierWithMaxJets")
        carrierNumToUse = carrierWithMaxJets;
        jetsToUse = jetList';

        if isempty(pilotList)
            availablePilotsToChoose = AvailablePilots(find(pilotCarrierforAvailPilots == carrierNumToUse));
        else
            availablePilotsToChoose = pilotList';
        end
    elseif exist("carrierWithMaxPilots")
        carrierNumToUse = carrierWithMaxPilots;
        if isempty(jetList)
            jetsToUse = AvailableJetsWithHelos(find(JetsCarrierInfo(AvailableJetsWithHelos) == carrierNumToUse));
        else
            jetsToUse = jetList';
        end
        availablePilotsToChoose = pilotList;
    else
        carrierNumToUse = intersect(carrierNumsCheck1,carrierNumsCheck2);
        carrierNumToUse = carrierNumToUse(1);

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
        if (length(wingJetsToUse) >= (numJetsNeeded-1))
            chosenWingJets = wingJetsToUse(1:(numJetsNeeded-1));
            chosenJet = ii;
            break;
        end
    end

    if isempty(chosenJet) || isempty(chosenWingJets)
        disp('Need to move jets to carrier!');
        keyboard;
    end

    chosenJets = [chosenJet chosenWingJets];

    % get helo
    needHeloReposition = 0;
    chosenHelo = AvailableHelos(find(heloCarrierforAvailHelos == carrierNumToUse, 1, 'first'));
    if (exist("heloList") && ~isempty(heloList) && nnz(intersect(heloList, chosenHelo)) > 0)
        % need to reposition helos
        needHeloReposition = 1;
    end

    % find available pilot and wing pilots
    chosenPilot = [];
    chosenWingPilots = [];
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
        keyboard;
    end

    missionStartTimeHr = startTimeHr;
    % add in jet reposition (4 hrs)
    pilotsRepositionedByJet = [];
    jetsRepositioned = [];
    if (jetsMoved > 0)
        JetsHoursInfo(jetListMove, startTimeHr:(startTimeHr+jetRepositionTime-1)) = 0;
        pilotsRepositionedByJet = pilotListMove(find(jetPilotMapping(:,1) == jetListMove));
        PilotsHoursInfo(pilotsRepositionedByJet, missionStartTimeHr:(missionStartTimeHr+jetRepositionTime-1)) = 0;
        missionStartTimeHr = startTimeHr+jetRepositionTime;
    end
    % add in pilot reposition (24 hrs) - jet reposition would be included
    % in this
    pilotsRepositionedByHelo = [];
    if (exist("heloList") && ~isempty(heloList))
        HeloHoursInfo(heloList, startTimeHr:(startTimeHr+pilotRepositionTime-1)) = 0;
        pilotsRepositionedByHelo = setdiff(pilotListMove, pilotsRepositionedByHelo);
        missionStartTimeHr = startTimeHr+pilotRepositionTime;
    end
    % add in helo reposition (6 hrs)
    helosRepositioned = [];
    if needHeloReposition
        if isempty(pilotsRepositionedByHelo)
            HeloHoursInfo(chosenHelo, startTimeHr:(startTimeHr+heloRepositionTime-1)) = 0;
        else
            HeloHoursInfo(chosenHelo, missionStartTimeHr:(missionStartTimeHr+heloRepositionTime-1)) = 0;
        end
        helosRepositioned = chosenHelo;
        missionStartTimeHr = missionStartTimeHr+heloRepositionTime;
   end
    % update pilot/jet/carrier data information given what was chosen 
    JetsHoursInfo(chosenJets, missionStartTimeHr:(missionStartTimeHr+maxSortieTimeHrs-1+jetRestTime)) = 0;
    PilotsHoursInfo(chosenPilots, missionStartTimeHr:(missionStartTimeHr+maxSortieTimeHrs-1+pilotRestTime)) = 0;
    HelosHoursInfo(chosenHelo, missionStartTimeHr-1:(missionStartTimeHr+maxSortieTimeHrs+heloRestTime)) = 0;

    % display results
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
    fprintf('\n');
end

function data = plotSchedule(chosenJets, chosenHelo, chosenPilots, ...
    pilotsRepositionedByJet, jetsRepositioned, pilotsRepositionedByHelo, helosRepositioned, ...
    startTime, missionStartTimeHr, maxSortieTimeHrs, jetRestTime, heloRestTime, pilotRestTime, ...
    jetRepositionTime, pilotRepositionTime, heloRepositionTime, ...
    data, NumJets, NumHelos, NumPilots)

    % plot
    % fill in jet data
        % reposition time
        data(jetsRepositioned, startTime:(startTime+jetRepositionTime-1)) = 0.5;
        % fly time
        data(chosenJets, missionStartTimeHr:(missionStartTimeHr+maxSortieTimeHrs-1)) = 1;
        % rest time (8 hrs)
        data(chosenJets, (missionStartTimeHr+maxSortieTimeHrs):(missionStartTimeHr+maxSortieTimeHrs-1+jetRestTime)) = 0.2;
    % fill in helo data
        % reposition time
        if isempty(pilotsRepositionedByHelo)
            data(NumJets + helosRepositioned, startTime:(startTime+heloRepositionTime-1)) = 0.5;
        else
            data(NumJets + helosRepositioned, startTime+pilotRepositionTime:(startTime+pilotRepositionTime+heloRepositionTime-1)) = 0.5;
        end
        % fly time
        data(NumJets + chosenHelo, missionStartTimeHr-1:(missionStartTimeHr+maxSortieTimeHrs)) = 1;
        % rest time (12 hrs)
        data(NumJets + chosenHelo, (missionStartTimeHr+maxSortieTimeHrs+1):(missionStartTimeHr+maxSortieTimeHrs+heloRestTime)) = 0.2;
    % fill in pilot data
        % reposition time
        data(NumJets + NumHelos + pilotsRepositionedByJet, startTime:(startTime+jetRepositionTime-1)) = 0.5;
        data(NumJets + NumHelos + pilotsRepositionedByHelo, startTime:(startTime+pilotRepositionTime-1)) = 0.5;
        % fly time
        data(NumJets + NumHelos + chosenPilots, missionStartTimeHr:(missionStartTimeHr+maxSortieTimeHrs-1)) = 1;
        % rest time (16 hrs)
        data(NumJets + NumHelos + chosenPilots, (missionStartTimeHr+maxSortieTimeHrs):(missionStartTimeHr+maxSortieTimeHrs-1+pilotRestTime)) = 0.2;
    % create schedule
    createSchedule(data, NumJets, NumHelos, NumPilots);
end