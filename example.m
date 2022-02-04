clearvars
close all
clc


%% Lets make a square coil which is 5 cm by 10cm. 

BSmag = BSmag_init(); % Initialize BSmag analysis

% Define the corners of the loop (including returning to the first coil!)
% Note, units are [m]
Gamma = [0, 0, 0;  
    0, 0, 0.05;
    0, 0.1, 0.05;
    0, 0.1, 0;
    0, 0, 0] - [0, 0.05, 0.025]; % centered over [0,0,0] (not essential)

I = 1; % filament current [A]
dGamma = 1e-3; % filament max discretization step [m]      
[BSmag] = BSmag_add_filament(BSmag,Gamma,I,dGamma);

%% Generate the field points (where we want to see field values)

% example lets look at plane in x, 10 cm from the coil, 20x20 wide.

x = 0.1;                      % x [m]
y = linspace(-0.2,0.2,50);    % y [m]
z = linspace(-0.2,0.2,50);    % z [m]

[xM, yM, zM] = meshgrid(x,y,z);

BSmag_plot_field_points(BSmag,xM,yM,zM); % -> shows the field point line

%% PHYSICS!


% Biot-Savart Integration
[BSmag,X,Y,Z,BX,BY,BZ] = BSmag_get_B(BSmag,xM,yM,zM);      

% Plot B/|B|
figure(1)
    normB=sqrt(BX.^2+BY.^2+BZ.^2);
    quiver3(X,Y,Z,BX./normB,BY./normB,BZ./normB,'b')

figure(2)
subplot(131)
imagesc(squeeze(BX))
subplot(132)
imagesc(squeeze(BY))
subplot(133)
imagesc(squeeze(BZ))