# EdgeTX Custom Widgets for Radiomaster TX16S

## TX16SDocs
A simple widget that displays a .png file with the same name as the
currently loaded model from IMAGES/TX16SDocs.  It has no options/setup.

This widget is intended to display full screen images generated from
[https://marcoose.github.io/tx16s-docs/](https://marcoose.github.io/tx16s-docs/)

It generates 'documentation' images to remind you how you set up your
switches, pots, and trims.  I have a many different 'toy' models, and sometimes
I can't remember how to arm or control some of the more eccentric ones :laughing:.

Add the widget to a separate 'Main view' using `Full screen` (with all display
elements turned off) or `App mode` layout.  Navigate to and from the screen
from your main model layout(s) with the `Page >` and `Page <` buttons.

### Configuration:
![Configuration screenshot](https://github.com/marcoose/edgetx-tx16s-widgets/blob/main/Docs/widget-config.png)

### Example:
![Example screenshot](https://github.com/marcoose/edgetx-tx16s-widgets/blob/main/Docs/example-docs-screen.png)


## OutputsPRO
Basicall the same as the built-in Outputs widget except that it lets you choose which channels
to output via a 'bitmask'.  There are two eight-character option inputs, `FirstChans`
and `LastChans`, consisting of 1's and 0's to indicate if the channel should be
included or not.  `FirstChans` is Ch1-8, and `LastChans` is Ch9-16.  A `1` indicates
the channel should be included.

The borders and color of the border is also configurable.