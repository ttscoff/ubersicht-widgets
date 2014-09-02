## LoadChart: CPU usage chart for Übersicht

A widget for [Übersicht](http://tracesof.net/uebersicht/) that displays a graph of the 5-minute average CPU load over time.

There are settings in the `index.coffee` file for showing it in color or black and white, inverse, with and without background, and bright or translucent.

![](screenshot2.png)

### Adjusting settings

In the `.coffee` file's `update` function, locate these lines:

    settings =
      background: true
      color: true
      brighter: false
      inverse: false
      bars: 100
      animated: false

Adjust and save to see the results in the widget on the desktop. The widget will automatically change width based on the number of bars you request.

Note that the "animated" option is CPU-intensive, especially if you have a lot of bars showing. It works pretty well with 25-50 bars, but it still causes a noticeable spike in CPU load.

### Notes

The load chart currently rescales as minimum and maximum values change. This requires iterating through all the bars on every update. I'm planning to add a "static" setting that bases everything on a fixed minimum/maximum and only has to add and remove bars from either end. This will improve performance in some cases, and could still have a nifty "growing" animation to bring new bars in gracefully on the right.
