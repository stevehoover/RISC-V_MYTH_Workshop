# RISC-V_MYTH_Workshop

For students of "Microprocessor for You in Thirty Hours" Workshop, offered by for VLSI System Design (VSD) and Redwood EDA, find here accompanying live info and links.

## Temporary Makerchip Servers

We are running two Makerchip servers specially for this workshop, with support for visualization not yet available at makerchip.com. Please help us distribute the load by using the appropriate links below based on the day-of-month of your birthday. For all links, open in a new tab using the right-click pull-down menu. (Github Markdown links always replace the page when clicked.) On the off-chance there is an issue with one server, feel free to use the other.

## Labs

Before each lab, clone the previous lab (or save new, initially) and bookmark the new URL, named appropriately for the new lab. You will submit URLs for each lab.

## Starting-point Code

### For Intro Labs (all that are not calculator or RISC-V)

No special starting point is required.

Use makerchip.com or:

  - If your birthday is an odd-numbered day, use [myth1.makerchip.com](https://myth1.makerchip.com). (Right-click and "Open in new tab".)
  - If your birthday is an even-numbered day, use [myth2.makerchip.com](https://myth2.makerchip.com). (Right-click and "Open in new tab".)


### For Calculator Labs

Begin with the following starter code.

  - Odd birthday: <a href="https://myth1.makerchip.com/sandbox?code_url=https:%2F%2Fraw.githubusercontent.com%2Fstevehoover%2FRISC-V_MYTH_Workshop%2Fmaster%2Fcalculator_shell.tlv" target="_blank" atom_fix="_">Calculator Starter Code</a> (right-click and "Open in new tab")
  - Even birthday: <a href="https://myth2.makerchip.com/sandbox?code_url=https:%2F%2Fraw.githubusercontent.com%2Fstevehoover%2FRISC-V_MYTH_Workshop%2Fmaster%2Fcalculator_shell.tlv" target="_blank" atom_fix="_">Calculator Starter Code</a> (right-click and "Open in new tab")

### For RISC-V Labs

Begin with the following starter code.

  - Odd birthday: <a href="https://myth1.makerchip.com/sandbox?code_url=https:%2F%2Fraw.githubusercontent.com%2Fstevehoover%2FRISC-V_MYTH_Workshop%2Fmaster%2Frisc-v_shell.tlv" target="_blank" atom_fix="_">RISC-V Starter Code</a> (right-click and "Open in new tab")
  - Even birthday: <a href="https://myth2.makerchip.com/sandbox?code_url=https:%2F%2Fraw.githubusercontent.com%2Fstevehoover%2FRISC-V_MYTH_Workshop%2Fmaster%2Frisc-v_shell.tlv" target="_blank" atom_fix="_">RISC-V Starter Code</a> (right-click and "Open in new tab")

Visualisation can be enabled by uncommenting `m4+cpu_viz(@4)`.

**Note** : As the complexity of your design increases, it might take long time (~3 mins) to generate the diagrams, this does **NOT** indicate a problem in your code. 


### Lab Submissions

There are submission forms for lab solutions:
 - [Days 2 & 3 Submission Form](https://docs.google.com/forms/d/1-FEtrSJvP9g5vqzRfnbYlG2DUmCV7agOHM6bzdWtah8) (Right-click and "Open in new tab".)
 - [Day 4 Submission Form](https://docs.google.com/forms/d/e/1FAIpQLSeLOzOZpPY1QXV-BlCAp0mEOKZFeqxTrDNVW5ROWIxyg_4xLg/viewform?usp=sf_link) (Right-click and "Open in new tab".)
 - [Day 5 Submission Form](https://forms.gle/vUmw2J5TuUikb6fF9) (Right-click and "Open in new tab".) 

Follow these steps for each lab in the form:
 - Keep the form open while doing the labs.
 - For each lab that is listed in it, submit the URL for your solution.
 - Save answers elsewhere as well, just in case.
 - After filling in a URL, BE SURE TO CLONE your sandbox to avoid modifying your submission.
 - You can make corrections at any time by re-opening a submission URL.
 - After this workshop, these servers will be taken off-line. Your work will not be saved and will not be recoverable, so be sure to save off any work you want to keep.

## HELP!!!

It's important to take your time with each concept and with each lab. Rushing ahead will slow you down in the end.

When you get stuck:

  1. Always check the LOG.
  1. Check the information below for course corrections, updated during the workshop. (Reload this page if it's been up for a while.)
  1. Review previous lectures.
  1. Explore these reference solutions:

 - Odd birthday: <a href="https://myth1.makerchip.com/sandbox?code_url=https:%2F%2Fraw.githubusercontent.com%2Fstevehoover%2FRISC-V_MYTH_Workshop%2Fmaster%2Freference_solutions.tlv" target="_blank" atom_fix="_">Reference Solutions</a> (right-click and "Open in new tab")
 - Even birthday: <a href="https://myth2.makerchip.com/sandbox?code_url=https:%2F%2Fraw.githubusercontent.com%2Fstevehoover%2FRISC-V_MYTH_Workshop%2Fmaster%2Freference_solutions.tlv" target="_blank" atom_fix="_">Reference Solutions</a> (right-click and "Open in new tab")
  
  No, we're not giving away the answers. This link will open code in Makerchip that you can use to see solutions -- not the source code, but the Makerchip diagrams, waveforms, and visualizations. Explore these to figure out the issue that's plaguing you, and then go back to doing the lab on your own. If you are stuck on syntax, hover over a signal assignment in the diagram to see an expression.

  Note that you have to comment the line with `m4_define(['M4_CALCULATOR'], 1)` to see solutions for RISC-V Labs. 
  
  Also, we've pre-generated a Diagram of the final RISC-V reference solution at the bottom of this README.

  1. There is a WhatsApp Group for everyone in the workshop, both students and mentors: https://chat.whatsapp.com/GTeXhnNrEtJ4m9kcto2GGG
  1. There is a TL-Verilog help room available during the workshop for individual assistance: <a href="https://us02web.zoom.us/j/4218739141" target="_blank" atom_fix="_">TL-Verilog Zoom Room</a>

## Common Issues and Solutions

### SandPiper(TM) (blue log output)

### Verilator (black log output)

#### Verilated model didn't DC converge

Combinational logic loops back on itself so the combinational logic does not stabilize. Perhaps you missed a `>>1`.

### By Slide

(Filled in as issues are identified/reported.)

Day 3, Slide 16 "Lab: Combinational Calculator":

  - Syntax is required that has not been presented. For boolean selects of `$out` mux, need to compare `$op` with 2-bit constants. Eg: `($op[1:0] == 2'b00)`. `2'b00` (2-bit binary 00) is explained in D3SK2_L2.

Day 4, Slide 15 "Lab: Register File Read (part 1) :
  - **There was an issue with the visualisation that was resulting in strange errors. It has been fixed, but requires use of a new CPU shell** (updated at 3:41 AM Sunday, August 2, 2020 Indian Standard Time)
  - This seems to be the first time that there are enough signals in the model that the waveform viewer does not display them all by default. There is a little red "+" on the left of the waveform viewer for scopes that can be expanded to see waveforms.

Day 5, Slide 51ish "Load Data" :
  - The final input of the memory ($dmem_rd_index[5:0]) should not exist.

## Pre-generated Diagram

Your generated CPU would look like this after implementing all labs:  
*Right click and open image in new tab* to use your browser's zooming and to hover over assignment statements.

![Complete CPU](tlv_lib/fullcore.svg)
