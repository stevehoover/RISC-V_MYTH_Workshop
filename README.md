# RISC-V_MYTH_Workshop

For students of ["Microprocessor for You in Thirty Hours" Workshop](https://www.vlsisystemdesign.com/riscv-based-myth/), offered by for [VLSI System Design (VSD)](https://www.vlsisystemdesign.com/) and [Redwood EDA](https://www.redwoodeda.com/), find here accompanying live info and links for Day 3 - 5.

## About the Workshop

This workshop has recieved a great deal of attention in the RISC-V community for enabling students to learn at a pace never before possible through the use of TL-Verilog and [Makerchip](https://www.makerchip.com). Some links:
  - [Workshop info](https://www.vlsisystemdesign.com/vsd-iat/)
  - riscv.org blogs about [13-year-old Nicholas Sharkey](https://riscv.org/blog/2020/11/13-year-old-nicholas-sharkey-creates-a-risc-v-core/) and [12-year-old Niel Josiah](https://riscv.org/blog/2020/12/risc-v-microarchitecture-for-kids-steve-hoover-redwood-eda/)
  - [Linkedin posts](https://www.linkedin.com/search/results/all/?keywords=%23mythworkshop&origin=GLOBAL_SEARCH_HEADER)
  - [riscv.org's list of RISC-V cores, including MYTH cores](https://riscv.org/exchange/cores-socs/)

## Slides

As you listen to videos and do the lab assignments, follow along in the slides. Comments have been added to address points of confusion.

  - [Day 3 Slides](https://drive.google.com/file/d/1ZcjLzg-53It4CO3jDLofiUPZJ485JZ_g/view?usp=sharing)
  - [Day 4 - 5 Slides](https://drive.google.com/file/d/1tqvXmFru31-tezDX30jTNJoLcQk308UM/view?usp=sharing)

## Temporary Makerchip Servers

We are running two Makerchip servers specially for this workshop, with support for visualization not yet available at makerchip.com. Please help us distribute the load by using the appropriate links below based on the day-of-month of your birthday. For all links, open in a new tab using ctrl-click. (Github Markdown links always replace the page when clicked.) On the off-chance there is an issue with one server, feel free to use the other.

## Labs Starting-Point Code

### Intro Labs (all that are not calculator or RISC-V)

No special starting point is required.

Use [makerchip.com](https://www.makerchip.com) or:

  - If your birthday is an odd-numbered day, use [myth1.makerchip.com](https://myth1.makerchip.com). (Ctrl-click)
  - If your birthday is an even-numbered day, use [myth2.makerchip.com](https://myth2.makerchip.com). (Ctrl-click)


### Calculator Labs

Begin with the following starter code.

  - Odd birthday: <a href="https://myth1.makerchip.com/sandbox?code_url=https:%2F%2Fraw.githubusercontent.com%2Fstevehoover%2FRISC-V_MYTH_Workshop%2Fmaster%2Fcalculator_shell.tlv" target="_blank" atom_fix="_">Calculator Starter Code</a> (Ctrl-click)
  - Even birthday: <a href="https://myth2.makerchip.com/sandbox?code_url=https:%2F%2Fraw.githubusercontent.com%2Fstevehoover%2FRISC-V_MYTH_Workshop%2Fmaster%2Fcalculator_shell.tlv" target="_blank" atom_fix="_">Calculator Starter Code</a> (Ctrl-click)

### RISC-V Labs

Begin with the following starter code.

  - Odd birthday: <a href="https://myth1.makerchip.com/sandbox?code_url=https:%2F%2Fraw.githubusercontent.com%2Fstevehoover%2FRISC-V_MYTH_Workshop%2Fmaster%2Frisc-v_shell.tlv" target="_blank" atom_fix="_">RISC-V Starter Code</a> (Ctrl-click)
  - Even birthday: <a href="https://myth2.makerchip.com/sandbox?code_url=https:%2F%2Fraw.githubusercontent.com%2Fstevehoover%2FRISC-V_MYTH_Workshop%2Fmaster%2Frisc-v_shell.tlv" target="_blank" atom_fix="_">RISC-V Starter Code</a> (Ctrl-click)


**Note** : As the complexity of your design increases, it might take long time (~3 mins) to generate the diagrams or they might fail to generate altogether.
This does **not** indicate a problem in your code. 


## Lab Submissions

Labs involving the calculator or RISC-V CPU must be submitted. This is done via your GitHub Classroom repository (no longer Google Form).

For each calculator or RISC-V lab:
 - Open your github classroom repository in your web browser.
 - Navigate into the `Day3_5` folder and the corresponding `calculator_solutions.tlv` or `risc-v_solutions.tlv`.
 - Click edit (pencil).
 - Paste your updated solution. (Within Makerchip editor select all (Ctrl-A) and copy (Ctrl-C), then select all in github editor (Ctrl-A) and paste with (Ctrl-V).)
 - Add commit message specifying the slide number or name of the lab, and commit changes.

## HELP!!!

It's important to take your time with each concept and with each lab. Rushing ahead will slow you down in the end.

When you get stuck:

  1. Always check the LOG! Keep your log clean of errors (both SandPiper errors (blue) and Verilator errors (black)). In some cases we expect warnings (LOGIC_ERRORs) for signals that are "used but never assigned" where we want Makerchip to provide random input values. Common "Issues and Solutions" can be found below.
  1. Check the slide PDFs for any corrections, and check below for "Common Issues and Solutions".
  1. Review previous lectures.
  1. Follow conversation in Slack (https://risc-vmythworkshop.slack.com/home) to see if someone else encountered similar issues.
  1. Discuss the issue with your "Team" in Slack (if assigned).
  1. Explore these reference solutions:

     - Odd birthday: <a href="https://myth1.makerchip.com/sandbox?code_url=https:%2F%2Fraw.githubusercontent.com%2Fstevehoover%2FRISC-V_MYTH_Workshop%2Fmaster%2Freference_solutions.tlv" target="_blank" atom_fix="_">Reference Solutions</a> (Ctrl-click)
     - Even birthday: <a href="https://myth2.makerchip.com/sandbox?code_url=https:%2F%2Fraw.githubusercontent.com%2Fstevehoover%2FRISC-V_MYTH_Workshop%2Fmaster%2Freference_solutions.tlv" target="_blank" atom_fix="_">Reference Solutions</a> (Ctrl-click)
  
     No, we're not giving away the answers! This link will open in Makerchip the diagram, waveform, and visualization for the solution, but will not show source code. Explore these to figure out the issue that's plaguing you, and then go back to doing the lab on your own. If you are stuck on syntax, hover over a signal assignment in the diagram to see an expression.

     **Note** : Last time we conducted this workshop, students relied to heavily on reference solutions. This **slowed them down** . Furthermore, there are intentional bugs in the reference solutions, and we can easily tell if you are simply copying them.

     Note that you have to comment the line with `m4_define(['M4_CALCULATOR'], 1)` to see solutions for RISC-V Labs. 
  
     Also, we've pre-generated a Diagram of the final RISC-V reference solution at the bottom of this README.

  1. Share your sandbox URL with a mentor via Direct Message in Slack. (Be sure it is saved/cloned, and clone again before editing.)
  1. We have a Zoom plugin in Slack. Feel free to request a meeting with the instructors, or meet with others. Start a meeting with:
  
     `/zoom meeting My topic`

## Common Issues and Solutions

In some cases the viz logic will make error/warning messages a bit more obscure. If you have enabled visualization, try disabling it.

### SandPiper(TM) (blue log output)

### Verilator (black log output)

#### Verilated model didn't DC converge

Combinational logic loops back on itself so the combinational logic does not stabilize. Perhaps you missed a `>>1`.

Errors related to `[***NULL***:***NULL***]`: Disable viz macro and this error will most likely go away. Debug other SandPiper errors and re-enable viz.

## Pre-generated Diagram

Your generated CPU would look like this after implementing all labs.

**Note** : As noted above in "HELP!!!" section, refer to this diagram only when stuck. Reverse-engineering this diagram will **not** help you finish faster, and we can tell whether you simply reverse-engineer it.

*Ctrl-click* to use your browser's zooming and to hover over assignment statements.

![Complete CPU](tlv_lib/fullcore.svg)
