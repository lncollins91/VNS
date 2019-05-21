# VNS 
This respository includes the following scripts:

VNS_Minh:
Use this script to analyze widefield VNS data. This code includes:
-Load Spike2 and .tsm files
-correct Spike2 traces and create resampled timeseries (using SorrectSpike2 function)
-Clip all traces around stimulation onset
-Draw ROIs for whole brain, motor, somato, and visual from each hemisphere
-Make timeseries of widefield data
-Clip WF traces around time of VNS
-Run through VNScalcs_short function 
-Saves files as structure

VNScalcs_short:
Use this function to create variables averaged over stims
Creates and saves: avpup, avencoder, avwhisk, avlfp, avSU, avstim, time

VNScalcs:
Use this function to create varaibles averaged over stims and separated based on arousal. this code includes:
-average all traces (same as VNScalcs_short)
-manually select stationary period 
-separate walk, whisk, pupil, SU, and lfp based on walking speed (walking/not walking)
-separate same variables based on high, intermediate, or low pupil size
-use stdshade to graph

