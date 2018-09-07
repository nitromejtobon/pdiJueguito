clear all;close all;clc;
% [y,Fs] = audioread('InitialD-dejavu.mp3'); sound(y,Fs);
% sound(y);
[A,map,transparency] =imread('Guitarra.png');
[A1,map1,transparency1]=imread('me.png');
f=imshow(A);impixelinfo;set(f, 'AlphaData', transparency);
hold on
G=image(355,216,A1);set(G, 'AlphaData', transparency1);

