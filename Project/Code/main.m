%% Init data
clear;
clc;
close all;

m = mesh;
m.load('Data/mesh.txt');

figure;
m.plot();