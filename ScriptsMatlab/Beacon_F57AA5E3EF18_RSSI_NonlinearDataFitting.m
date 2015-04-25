%%  Beacon_F57AA5E3EF18 (RSSI) - Nonlinear Data-Fitting 

clear all

d = (0.5:0.5:8.5);
rssi = [-67.274, -64.015, -67.980, -74.039, -70.670, -71.513, -79.871, -81.807, -88.136, -89.058, -83.470, -89.657, -92.045, -90.125, -84.849, -86.479, -81.197];

% axis([0 2 -0.5 6])
% hold on
plot(d,rssi,'ro')
title('RSSI over distance [0.5, 8,5] meters')
xlabel('Distance [m]')
ylabel('RSSI [dBm]')
set(gca,'XTick',d)
% hold off

%%
% We would like to fit the function
%
%     RSSI =  RSSI_o-10*n*log(d/d_0)+Xg
%
% to the data. 
%
%% Solution Approach Using |lsqcurvefit|
%
% The |lsqcurvefit| function solves this type of problem easily.
%
% To begin, define the parameters in terms of one variable x:
%
%  x(1) = RSSI_0
%  x(2) = n
%  x(3) = Xg(1)
%
% Then define the curve as a function of the parameters x
d_0 = 1;

F = @(x,d)(x(1)-10*x(2)*log10(d/d_0)+x(3));

%%
% We arbitrarily set our initial point x0 as follows: 
% n(1) = 0, Xg(1) = 0

x0 = [-77 1 0];

%% 
% We run the solver and plot the resulting fit.

[x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,d,rssi)

hold on
plot(d,F(x,d))
hold off