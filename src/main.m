clc;clear;close all;

addpath("functions");
% The functions that will make it to the last version are moved into
% functions folder. Some are only placeholders and will be modified before
% the last push
addpath("utils");
% The functions that are stored in utils may not make it to the end, but
% are useful, to generate an Additive White Gaussian Noise, for instance
addpath("gui");
% The functions that are stored in gui are directly linked to graphical
% user interface management
%% === Begin

G = gui2();
