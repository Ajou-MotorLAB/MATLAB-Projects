% Model         :   AD2S1210 absolute resolver position monitor
% Description   :   Set parameters for CN0276/AD2S1210 SPI read example
% File name     :   mcb_resolver_f28379d_data.m

% Copyright 2022 - 2024 The MathWorks, Inc.

%% Set target execution rate
% Keep the original variable names because the F28379D processor-parameter
% helper uses the execution frequency when it creates the target structure.
PWM_frequency          = 20e3;            % Hz
T_pwm                  = 1/PWM_frequency; % s

%% Set Sample Times
Ts                     = T_pwm;           % s
Ts_serial              = Ts;              % s

%% Set data type for controller and code generation
% dataType = fixdt(1,32,22);
dataType = 'single';

%% Target Parameters
target = mcb.getProcessorParameters('F28379D',PWM_frequency);
target.comport = '<Select a port...>';
% target.comport = 'COM5';       % Uncomment and set the serial port

%% CN0276 / AD2S1210 serial-interface parameters
% RES0 = RES1 = 1 selects 16-bit position resolution.
resolver.resolutionBits       = 16;
resolver.positionCounts       = 2^16;
resolver.positionScale        = single(2*pi/resolver.positionCounts); % rad/count
resolver.positionScaleDeg     = single(360/resolver.positionCounts);  % deg/count
resolver.spiFrequency         = uint32(1e6);

% Allow the 16-bit tracking loop to settle after RESET. A multiple of
% three ticks guarantees that the first active phase is SAMPLE-low.
resolver.trackingWait         = 60e-3;
resolver.startupDelayTicks    = 3*ceil(resolver.trackingWait/(3*Ts));

% Three-step read sequence: SAMPLE-low, SAMPLE-high, then SPI read.
resolver.readPeriod           = 3*Ts;
