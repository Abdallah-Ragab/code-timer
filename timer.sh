#! /bin/bash
GUIDE="
Description:
    Simple script to keep track of your coding time spent on VS Code.

Requirements:
    pidof, xdotool, xargs

USAGE:
    ./$(basename "$0") [-c] [-b seconds]

OPTIONS:
    -b  [OPTIONAL] Set buffer time (in seconds) default value is 300s.
    -c  [OPTIONAL] Launces vs code alongside the timer.
    -h  Help.

**buffer time is the duratuion given to the user to return to VS Code
 before the timer stops recording coding time and move on to rest time.**  
"

BRED='\033[1;91m'
LRED='\033[1;31m'
BGREEN="\033[1;92m"
LGREEN='\033[1;32m'
BBLUE="\033[1;94m"
LBLUE='\033[1;34m'
LYELLOW='\033[1;33m'
BYELLOW='\033[1;93m'
GRAY='\033[1;30m'
LGRAY='\033[0;37m'
BWHITE='\033[1;97m'
LCYAN="\033[1;36m"
BCYAN="\033[1;96m"
MAGENTA="\033[1;95m"
LMAGENTA="\033[1;35m"
NC='\033[0m'

LAUNCH_CODE=false
CODE_RUNNING=false
CODE_ACTIVE=false
RECORDING=false
PAUSED=false
BUFFERING=false
CODE_TIME=0
BUFFER_LIMIT=300
BUFFER_TIME=0
IDLE_TIME=0
SHOW_PROMPT=false
SHOULD_RESET=false
SHOULD_QUIT=false


run(){
    check_requirements
    iscoderunning
    # if $LAUNCH_CODE && ! $CODE_RUNNING; then
    #     printf "${LYELLOW} LAUNCHING VS CODE ... ${NC}"
    #     code
    #     while ! $CODE_RUNNING;
    #     do
    #         iscoderunning
    #         sleep 1
    #     done
    # fi
    run_code
    while :; do
        live_view
        update
        listen_for_keys
    done
}

check_requirements(){
    if ! command -v code &> /dev/null
    then
        printf "${LRED}ERROR:${NC} VS Code is not installed in your system.\n"
        printf "${LYELLOW}TRY:${NC} sudo apt install code\n"
        exit
    elif ! command -v pidof &> /dev/null
    then
        printf "${LRED}ERROR:${NC} pidof is not installed in your system.\n"
        printf "${LYELLOW}TRY:${NC} sudo apt install pidof\n"
        exit

    elif ! command -v xdotool &> /dev/null
    then
        printf "${LRED}ERROR:${NC} xdotool is not installed in your system.\n"
        printf "${LYELLOW}TRY:${NC} sudo apt install xdotool\n"
        exit
    elif ! command -v xargs &> /dev/null
    then
        printf "${LRED}ERROR:${NC} xargs is not installed in your system.\n"
        printf "${LYELLOW}TRY:${NC} sudo apt install xargs\n"
        exit
    fi
}

ispidof() {
    PIDS=$(pidof $2)
    STRIPPED_PIDS=$(echo $PIDS | xargs)
    if [ -z "${STRIPPED_PIDS}" ] ;then
        CODE_RUNNING=false
        CODE_ACTIVE=false
        return
    else
        CODE_RUNNING=true
    fi
    INPUT=$(echo $1 | xargs)
    read -a PIDS_LIST <<< "$PIDS"
    for PID in "${PIDS_LIST[@]}";
    do
        if [ "$PID" = "$INPUT" ]; then
            CODE_ACTIVE=true
            return
        fi
    done
        CODE_ACTIVE=false
        return
}

iscoderunning(){
    CURRENT_PID=$(xdotool getwindowfocus getwindowpid);
    ispidof $CURRENT_PID code
}
update(){
    iscoderunning
    if ! $CODE_RUNNING = || $SHOW_PROMPT;then
        return
    fi
    if ($CODE_ACTIVE);then
        RECORDING=true
        CODE_TIME=$(($CODE_TIME + $BUFFER_TIME))
        BUFFER_TIME=0
        BUFFERING=false
    else
        if $RECORDING;then
            RECORDING=false
            BUFFERING=true
        elif $BUFFERING;then
            BUFFER_TIME=$(($BUFFER_TIME + "1"))
            if [ $BUFFER_TIME -gt $BUFFER_LIMIT ];then
                BUFFER_TIME=0
                BUFFERING=false
            fi
        else
            IDLE_TIME=$(($IDLE_TIME + "1"))
        fi
    fi
    count
}
count(){
    if ($RECORDING);then
        CODE_TIME=$(($CODE_TIME + "1"))
    fi
}
live_view(){
    clear
    render_art
    if ! $CODE_RUNNING;then
        printf "${LRED}  VS CODE IS NOT RUNNING CLICK [C] TO LAUNCH IT\n${NC}"
        printf "${BYELLOW}  Hint:${LGRAY} run $0 -c to launch vs code alongside the timer.\n${NC}"
    elif $PAUSED;then
        printf "${BRED}  TIMER PAUSED\n${NC}"
    elif $CODE_ACTIVE;then
        printf "${BGREEN}  VS CODE IS ACTIVE [CODING]\n${NC}"
    elif $BUFFERING;then
        printf "${BYELLOW}  VS CODE IS NOT ACTIVE [IDLING IN $(($BUFFER_LIMIT - $BUFFER_TIME))s]\n${NC}"
    else
        printf "${BRED}  VS CODE IS NOT ACTIVE [IDLE]\n${NC}"
    fi

    printf "${BBLUE}  CODING TIME:${BWHITE} $(date -d@$CODE_TIME -u +%H:%M:%S)${NC}\n"
    printf "${BCYAN}  IDLE TIME:${BWHITE} $(date -d@$IDLE_TIME -u +%H:%M:%S)${NC}\n"

    printf "
${BWHITE}  Controls:
    ${LMAGENTA}[${BYELLOW}P${LMAGENTA}]${NC}ause/resume
    ${LMAGENTA}[${BYELLOW}R${LMAGENTA}]${NC}eset
    ${LMAGENTA}[${BYELLOW}Q${LMAGENTA}]${NC}uit\n"
    if ! $CODE_RUNNING;then
    printf "    ${LMAGENTA}[${BYELLOW}C${LMAGENTA}]${NC}ode - Run VS Code\n"
    fi

if $SHOW_PROMPT;then
    printf "\n${BYELLOW}Are you sure ? ${NC}[${BRED}Y${NC}]es or [${BGREEN}N${NC}]o\n${NC}"
fi

}
render_art(){
    file="visuals/ascii_logo.txt"
    while IFS= read -r line
    do
    echo "$line"
    done < "$file"
}

listen_for_keys(){

    PRE_SEC=$(date +%s)

    read -t .$((10**9-10#$(date +%N))) -n 1 input

    if [[ $input = "q" ]] || [[ $input = "Q" ]]; then
        if ! $SHOW_PROMPT;then
            SHOW_PROMPT=true
            SHOULD_QUIT=true
            return
        fi
    elif [[ $input = "r" ]] || [[ $input = "R" ]]; then
        if ! $SHOW_PROMPT;then
            SHOW_PROMPT=true
            SHOULD_RESET=true
            return
        fi
    elif [[ $input = "p" ]] || [[ $input = "P" ]]; then
        if $PAUSED;then
            PAUSED=false
        else
            PAUSED=true
            return
        fi
        P_SEC=$C_SEC
    elif [[ $input = "y" ]] || [[ $input = "Y" ]]; then
        if $SHOW_PROMPT;then
            if $SHOULD_RESET;then
                SHOW_PROMPT=false
                SHOULD_RESET=false
                reset
                return
            elif $SHOULD_QUIT;then
                SHOW_PROMPT=false
                SHOULD_QUIT=false
                quit
            fi
        fi
    elif [[ $input = "n" ]] || [[ $input = "N" ]]; then
        if $SHOW_PROMPT;then
            SHOW_PROMPT=false
            SHOULD_RESET=false
            SHOULD_QUIT=false
            return
        fi
    elif [[ $input = "c" ]] || [[ $input = "C" ]]; then
        if ! $CODE_RUNNING;then
            LAUNCH_CODE=true
            run_code
            # break
        fi
    fi

    C_SEC=$(date +%s)
    if (( $PRE_SEC == $C_SEC )); then
        sleep .$((10**9-10#$(date +%N)))
    fi
} 

reset(){
    CODE_TIME=0
    IDLE_TIME=0
}

quit(){
    exit
}

run_code(){
    if $LAUNCH_CODE && ! $CODE_RUNNING; then
    clear
    printf "${LYELLOW} LAUNCHING VS CODE ... \n${NC}"
    code
    while ! $CODE_RUNNING;
    do
        iscoderunning
        sleep 1
    done
    fi
}

while getopts "cb:h" arg; do
case $arg in
    b)
        BUFFER_LIMIT=$OPTARG
    ;;
    c) 
        LAUNCH_CODE=true
    ;;
    h)
        echo "$GUIDE"
        exit
    ;;
esac
done

run
