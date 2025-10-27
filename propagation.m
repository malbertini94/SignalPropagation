%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute Signal Propagation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Desc: Compute signal propagation between transmitter (tx) and receiver (rx)

%--------------------------------------------------------------------------
%% 0 Directories
%--------------------------------------------------------------------------

% 0.1 Specify YOUR directories
impianti_dir = '';
ward_dir = '';
save_dir = '';

%--------------------------------------------------------------------------
%% 1 Antennas
%--------------------------------------------------------------------------

% 1.1 Read data
tx = readtable(fullfile(impianti_dir, 'transmitters.csv'));

%--------------------------------------------------------------------------
%% 2 Receivers 
%--------------------------------------------------------------------------

% 2.1 Read wards coordinates
rx = readtable(fullfile(ward_dir, 'receivers_coords.csv'));

%--------------------------------------------------------------------------
%% 3 Set up parameters of longley-rice propagation model
%--------------------------------------------------------------------------

% 3.1 Settings
txLat  = tx.latitude;
txLon  = tx.longitude;
freqHz = tx.frequencymhz' * 1e6;              % Frequency: MHz -> Hz
txPower_dBm = 10 * log10(tx.txpower' * 1000); % Power: convert W → mW → dBm
txHeight_m = tx.txheight'; % Antenna height: meters

% 3.2 Specify transmitter site: works also with only lat/lon and freq
tx = txsite('Latitude', txLat, 'Longitude',txLon,'TransmitterFrequency',...
    freqHz, 'AntennaHeight', txHeight_m, 'TransmitterPower', txPower_dBm);

% 3.3 Create receiver points
rxLat = rx.centroid_lat;
rxLon = rx.centroid_lon;
rx = rxsite('Latitude', rxLat,'Longitude',rxLon);
%show(rx);

% 3.4 Longley-rice
pm = propagationModel("longley-rice");

  % 3.4.1 Conservative but reasonable defaults 
pm.AntennaPolarization = "vertical";    % many mobile/BS use vertical
pm.GroundConductivity   = 0.01;         % baseline inland (S/m). Adjust per region
pm.GroundPermittivity   = 15;           % baseline (relative)
pm.AtmosphericRefractivity = 320;       % N-units: slightly above default (tropical)
pm.ClimateZone = "tropical";            % baseline
pm.TimeVariabilityTolerance = 0.9;      % conservative (high reliability)
pm.SituationVariabilityTolerance = 0.9; % conservative

  % 3.4.2 Display coverage of first antennas
coverage(tx(:,1),"PropagationModel",pm, "SignalStrengths",-100:-5);

%--------------------------------------------------------------------------
%% 4 Compute signal
%--------------------------------------------------------------------------

% 4.1 Signal at the location of the receiver: longley-rice throws error if
% distance from rx e tx>500 km need to create loop

    % 4.1.2 Loop settings
numRx = length(rx); 
numTx = length(tx); 

signalMatrix = NaN(numRx,numTx);
rxIDs = rx.rxid;                      % identify wards
txIDs = tx.txid;               % identify antennas

    % 4.1.2 Setting up the loop for Longley-Rice
dt0 = datetime('now'); % timing
for i = 1:numTx
    % Current antenna
    currentTx = tx(i);

    % Compute distances between antenna i and all wards
    dists = distance(rx, currentTx);  % meters

    % Find rx within 450 km (ITM model cannot compute above threshold)
    validIdx = dists < 450000;  % 450 km = 450,000 meters

    % Compute signal between antenna i and valid wards
    if any(validIdx) %returns TRUE if at least one is valid
        signalMatrix(validIdx, i) = sigstrength(rx(validIdx), currentTx, pm);
    end
end
fprintf('Run time: %.2f s\n', seconds(datetime('now') - dt0));

writematrix(signalMatrix, fullfile(save_dir, 'signalMatrix.csv'));

