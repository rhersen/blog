---
title: "TDD with CUnit and inotify"
date: "2012-01-25 22:03"
---

I was trying to do some TDD with CUnit and Emacs, but I was a bit
disappointed at how painful it was to run the tests; save file, make,
change to terminal and run. After configuring Emacs to save the file
automatically I got rid of one step, but changing to the terminal
window wall still a pain.

Then I thought of googling *notify on file change*, and I found
`inotify-tools`, which enabled me to write this little script:

    #!/bin/sh
    while [ true ]
    do inotifywait *.c
        gcc -g obj2gl.c -lcunit && ./a.out
    done
      
So all I have to do now is save my file in Emacs, and the script runs
the unit tests instantly.
