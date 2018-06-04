# BASH cheat sheet

## random

    #!/bin/bash
    #!/usr/bin/env bash #- should work on all OS

    ./bash_profile # read when bash is started on login
    ./bashrc # executed when new shell is started (evry shell)

    time ps -l # time something
    time sleep 2

    nl README.md # like cat but with the line number.
    more - ls -latr /etc | more # more = paginates output
    && - mkdir newdir && cd newdir # do next on success

    [[ $1 ]] || echo "missing argument">&2  # do second if first is failed
    chmod +x shebang.sh # add execution rights to the script
    bash shebang.sh # will not need execution rights for the script
    PATH=$PATH:~/bin
    type ls # show if the name is used
    type time # check if global variable is used
    sleep 2 # sleeps for 2 seconds

    file example.sh # if CRLF ending, the filename might not be found
    dos2unix example.sh # converts CRLF (dos) to ASCII (unix) format

## grep - filters down by filter

    ls -latr /bin | grep -i user

## variables

    echo $? # displays the status code of latest comand / bash
    $1 - first variable
    $@ - all variable / parameters
    $* - all variables
    $$ - current PID
    $0 - path to the program itself

    n=world
    export great=hello # copies(not reference) to new processes
    declare -x expVar
    echo $great $n
    unset $n
    echo $great $n
    a="hello world"

    abc=12
    echo ${abc}Text without space

    z=abc
    abc=def
    echo ${!z} # prints def

    x=${var:-Hotdog} # x=var if var unset or empty else use default "Hotdog"
    # ${var-Hotdog} # will only use Hotdog if var is unset
    ${var:=Hotdog} # will also set var to Hotdog if empty or unset.
    # :-  if var unset/null, return value; otherwise, return value if var.
    # :?  Displays an error and exit script if var unset/null
    # :+  if var unset/null return nothing; otherwise, return value
    # ${var:offset} - string of var starting at offset
    # ${var:offset:len} - value of var starting at offset up to length len
    # ${#var} - length of var
    # ${var#pre} - remove matching prefix
    # ${var%post} - remove suffix

### export function

    export -f myfunc

### print the list of vars of the shell environment

    export

## scope using brackets

    a=1
    (
    a=2
    )
    echo $a # prints 1.
    {
    a=2
    }
    echo $a # prints 2.

### Local Variables and typeset command

x must be an integer

    typeset -i x #
    let x++; # evaluates arithmetic expressions. (()) prefered
    let y=x**2; # x squared

    function f1 {
        typeset x;
        x=7
        y=8
    }
    x=1
    y=2
    echo x is $x
    echo y is $y
    f1
    echo x is $x
    echo y is $y

    declare -l x=Hello! # saved as hello! (converted to lower case)
    declare -u y=hello! # saved as HELLO! (converted to upper case)
    declare -r r=HiHoo  # creates constant variable (can not be reasigned)

    declare -a myIndexedArray
    myIndexedArray[2]="indexed value"
    echo 'index 2= ' ${myIndexedArray[2]}

    declare -A myAssociativeArray # dictionary / hash array
    myAssociativeArray["name"]="Bob"
    echo 'name: ' ${myAssociativeArray["name"]}

    while
        read a b
    do
        echo a is $a and b is $b
    done <data_file

    ls -l | while
        read a b c d
    do
        echo owner is $c
    done

    for i in dog cat elephant
    do
        echo i is $i
    done


    for i in `seq 3 8`
    do
        echo i is $i
    done

    touch {a..c}.log

    for i in {8..-3} ## {A..Z}
    do
        echo i is $i
    done

    for d in $(<data_file) # echo every word separated by space or \n
    do
        echo $d
    done

    for d in *.sh
    do
        echo $d
    done

    for f in $(find /etc 2>/dev/null | grep grub)
    do
        echo grub named things are $f
    done

### prints Bash builtins

    enable

#### prints Bash keywords

    compgen -k

### source OR "." (dot)

run everything from file within itself (Shell).
source example.sh
. example.sh

### alias

list all aliaces

    alias
    alias ll="ls -l"
    alias ll='ls -latrh'
    alias ll # prints the current meaning of ll alias
    unalias ll # unset alias

## echo

different bash might have different default settings

    echo -n # don't add a new line to echo
    echo -e # enable backslashed escape characters like \n and \t
    echo -E # disable backslash escape characters in case they were enabled by default

## Redurection and Pipes

    0 => stdin
    1 => stdout
    2 => stderr

    command &> file # stdout and stderr from command to file.
    command 2>&1 | command2 # gets stdout and stderr from command

    command > file # create or overwite the file and write to it
    command >> file # append to the end of file

### <<

take from script

sort <<END
cherry
banana
apple
orange
END

### exec

redirect I/O for the whole script

    exec>logfile 2>error.log # send everything to logfile and errors to errorlog
    exec N< myfile # opens file descriptor N for reading from file
    exec N> myfile # opens file descripton N for writing to file
    exec N<> myfile # opens for read & write

    exec N>&-
    exec N<&-  # closes file descriptor

    lsof # list open files
    lsof -p $$# displays all files open by current shell
    # $$ is shell's PID

    echo Just '>' -----------------------------
    find /etc -name grub >grub.out
    echo Just '2>' -----------------------------
    find /etc -name grub 2>errs.out
    echo Just '>' -----------------------------
    find /etc -name grub &>both.out

### [] = string compare

    [[ ex1 -eq ex2 ]] = ((ex1 == ex2)) # equal
    [[ ex1 -ne ex2 ]] = ((ex1 != ex2)) # not equal
    [[ ex1 -lt ex2 ]] = ((ex1 <  ex2)) # less than
    [[ ex1 -le ex2 ]] = ((ex1 <= ex2)) # less or equal
    [[ ex1 -gt ex2 ]] = ((ex1 > ex2)) # greater than
    [[ ex1 -ge ex2 ]] = ((ex1 >= ex2)) # greater or equal
    ((ex1 && ex2))
    ((ex1 && ex2))

    x=01
    y=1
    echo comparing $x and $y
    if
    [ $x == $y ]
    then
        echo ==
    else
        echo not == # string compare <- lands here
    fi
    if
    [ $x -eq $y ] # numeric compare
    then
        echo eq # <- lands here
    else
        echo not eq
    fi
    if ((x==y)) # numeric compare
    then
        echo '(())' == # <- lands here
    else
        echo not '(())' ==
    fi

    if
        test -x /bin/ls
    then
        if
        [ ! -w /etc/hosts ]
        then
            if
            echo about to look for foobar
            grep -q foobar /etc/passwd
            then
                echo foobar found in /etc/passwd
            else
                echo foobar not found
            fi
        fi
    else
        echo Oh no, /bin/ls not executable
    fi

    echo -n "print message? "
    valid=0
    while [ $valid == 0 ];
    do
        read ans
        case $ans in
            y*|Y* )  echo Will print the message
                        echo The message
                        valid=1
                        ;;
            [nN][oO]    )  echo Will not print the message
            # first Char = N|n and second char = o|O
                        valid=1 ;;
            *            )  echo Yes or No fo some form please ;;
        esac
    done

    until false;do
        ;; #commands
    done

### arithmetic operations

used in (( )) or with let

    id++ id-- ++id --id
    ! ~ ** * / % + -
    << >>  <= >= < >
    == !=  & ^ | && ||
    expr?expr:export
    = *= /= %= += -= <<= >>= &= ^= |=
    expr1 , expr2 # do first, then second and the value of expresion = second expr

### using operators

    ((n=2**3 + 5)) # 13
    ((y=n^4)) # exclusive or bitwise operator
    echo y = $y # print 9

    for f in /usr/bin/*
    do
        if strings $f | grep -q "unable to fork"
        then
            echo $f
        fi
    done

    line=0
    ps -ly | while
    read c1 c2 c3 c4 c5 c6 c7 c8 c9 c10
    do
        if((++line>1))
        then
            ((rss+=$c8))
            ((sz+=$c9))
            echo $line . rss=$rss and sz=$sz
        fi
    done

## filters

    ls -l | head -3 # print first 3 lines
    ls -l | tail -2 # print last 2 lines
    ls -l | head -4 | tail -2 # print line 2-4

    ls -l | wc -l # displays number of lines
    ls -l | wc # display lines, words, chars

    ./somescript.sh >output.log & # execute the scrit and keep rinning it but give the shell back
    tail -n2 -f test.log # output last 2 lines and keep watching the file

### search and replace

    ${var/pattern/string} # substitude first match with string
    ${var//pattern/string} # replace all matches
    ${var/#pattern/string} # matches BEGINNING of the string
    ${var/%pattern/string} # matches only from end of the string

### sed

stream editor

    sed -i # edit in file
    sed  's/old/new' filename # replace first 'old' on each line
    sed 's/old/new/g' filename # /g = replace all 'old' on each line
    sed 's/old/new/g ; s/test/rest/g' filename # replace both on paterns all lines
    sed -e 's/old/new/g' -e 's/test/rest/g' filename.sh # same as above
    sed -e 's/[xX]/Y/' # if starts with x or X
    sed -e 's/b.*n/blue/' # Regexp. if starts with b, any number of char, ends with n
    sed -f sedscript -n sed4 # run commands from sedscript on file sed4
    date | sed 's/2018/18/' # replace first instance of 2018 with 18
    sed -n '3,5p' # print line 3-6
    nl README.md | sed -n '3,12n' # prints 3-12 lines only
    sed 'alpha/s/beta/gamma/' # if line has alpha, substitude beta/gamma
    sed '/apple/,/orange/d' # find apple, find orange and delete all lines between
    sed '/important/!s/print/throw_away/' # replace 'print' with 'throw_away' unless 'important' on the line

### awk

Breaks the lien into fields $1 $2 $3 $4.... Good for report writing.

    $0 # unbroken line

    FS = field separator (normally white space)
    ps -el | awk '/tty/||$8~/35/{printf("%5d 5d %s\n", $4, $5, $14)}'
    # if line has tty OR field 8 matches 35 then printf(5 decimal digit number, 5d, string and new line.)

    ps -ly | ./awk1 # pipe ps -ly into script

    man ls | col -b | awk -f words.awk # col -b strips out formatting

file sed3:

    sed -n "$1,$2p"
    sed3 3 5 <filename # 3 & 5 will be used inside the script

### shift

moves $2 into $1, $3->$2....

    echo arg1 is $ arg 11 is ${11}
    shift
    echo now arg1 is $1 arg 11 is ${11}
    echo program is $0

### pattern matching

    * any string
    ? any char
    [] set of chars

    i="/Users/reindert/demo.txt"
    ${i#*/} => "Users/reindert/demo.txt" # trims the shortest find
    ${i##*/}=> "demo.txt" # trims the longest find
    ${i%.*} => "/Users/reindert/demo"

    #!/bin/bash
    unset x a
    a=${x:-Hotdog}
    echo a is $a
    echo x is $x

    a=${x:=Hotdog} #  := if x is unset or null -> will set x to Hotdog
    echo a is $a
    echo x is $x

    unset x	
    ${x:?}
    echo Will not get here

    s="a string with words"
    sub=${s:4} # ring wirth words
    echo sub is $sub
    sub=${s:4:3} # rin
    echo sub is $sub
    echo length of s is ${#s}

    #!/bin/bash
    p="/usr/local/bin/hotdog.sh"
    echo whole path is $p
    echo Remove prefix ${p#/*local/} # bin/hotdog.sh
    echo Remove suffix ${p%.sh} # /usr/local/bin/hotdog
    cmd=${p#*/bin/}
    cmd2=${cmd%.sh}
    echo the command without .sh is $cmd2 # hotdog

    #!/bin/bash
    while [[ "$1" ]]; do
        echo $1
        sleep 0.3
        shift
    done

    ls -latr | awk '$9~/.sh/{printf("%s\n",$9)}' |
    while read a
    do
        echo ${a%.sh}
    done

## coprocesses

    #!/bin/bash
    while
        read line
    do
        echo $line | tr "ABC" "abc" # tr = translates A->a B->b C->c
    done

    coproc ./coproc.sh
    echo printback >&"${COPROC[1]}"
    cat <&"${COPROC[0]}"

    coproc myprcss { ./coproc.sh; } # give coproc a name
    echo printback >&"${myprcss[1]}"
    cat <&"${myprcss[0]}"

    jobs # display all coprocesses
    kill %1 # kill coprocess 1

    coproc.sh
    #!/bin/bash
    declare -l line
    while read line
    do
        echo $line
    done

## debugging

    bash -x prog.sh

    #!/bin/bash
    set -x # start debugging
    set +x # stop debugging

    shopt -s # set
    shopt -u # unset

    shopt -s extglob # enable extended pattern matching
    shopt -s nocaseglob # ignore case with pathname expansion
    shopt -s dotglob # include hidden files with pathname expansion

    bash -n prog.sh # check for syntax only don't run the scropt
    set -u # report usage of an unset variable
    set -v # print each command as it is read
    ./file.sh | tee file.log

## trap

overwrite the behaviour of terminations / errors

    trap "echo just got ctrl+c; exit" INT
    trap "echo you can not quit now" QUIT
    trap "" QUIT # ignores the sygnal

## eval

bash will evaluate a string

    c="ls / -latr"
    eval $c

### getopt

    used to process command-line options
    opts='getopts -o a: -l apple -- "$@"'
    eval $opts

    #!/bin/bash
    opts="a b $1 $2"
    set -- "$opts"
    echo $@

    #!/bin/bash
    opts="a b \$1 \$2"
    eval set -- "$opts"
    echo $@

## read

    read -p "Please enter your text: " text; echo $text

### running scripts in the background

will be suspended if tried to read from the terminal

    myscript & #
    nohup bash myscript.sh & # keep the script running after terminal exit
    nice ./script.sh # set priority on executions
    nohup nice ./myscrip.sh &

    declare -i i=0
    while [[ true ]]; do
        echo "${date} printing $i"
        sleep 3
    done

## at & cron

    at -f myscript.sh noon tomorrow
    crontab -e