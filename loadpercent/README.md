## Average load percentage display

A widget for [Übersicht](http://tracesof.net/uebersicht/) that displays a large number showing the average system load as a percentage, with the actual load reading to the right. The percent symbol in the number is animated and color-coded based on load (low, normal, high, higher, highest), and pulses faster as load increases. An arrow to the left shows whether the load is increasing or decreasing.

Load is calculated as (5-minute cpu load) / (logical cores). A load higher than your max logical cores will be higher than 100%.

![](screenshot2.png)

### Notes

Adjust the refresh rate as desired.
