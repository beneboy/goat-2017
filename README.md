# goat-2017
Analysis of data from The Goat 2017

Wave and finish times analysed for The Goat Adventure Race 2017 (http://thegoat.co.nz).

About
=====

Uses Python to fetch data (URLs not included) and Octave to analyse. The CSV data has had
the bib numbers all set to zero, and does not include the source URLs, for privacy reasons.


Octave Files
------------

*fetcher.py* fetches the wave start data and results data and combines them into one CSV.

*gender_plot.m* will generate a histogram of finish times split by genders.

*wave_analyse.m* generates a plot of finish times by start wave (split into 1-6, A and B grouped into the same wave). Also then shows how many people in later waves finished faster than the average for each wave (e.g. those in wave 1B who finished faster than the average of 1A, those in 3A who finished faster than 1A-2B, and so on).

*predict_finish_from_hut_time.m* plots the finish time vs time to the hut (4KM from the end).
It then uses machine learning (linear regression) to predict their finish time and draw a trendline. A few samples are tested for accuracy.

*predict_finish_from_previous_time.m* plots the finish time in 2017 vs the runner's previous best finish time. Again uses linear regression to predict finish times and draws a trendline. A few samples are tested.
