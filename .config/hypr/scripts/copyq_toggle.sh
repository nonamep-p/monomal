#!/bin/bash

# Ensure CopyQ server is running in the background
# This prevents issues if CopyQ isn't already started
copyq & disown

# Toggle the CopyQ main window
copyq toggle
