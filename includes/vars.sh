#################
## Text styles ##
#################
readonly STYLE_NORMAL=$(tput sgr0); readonly STYLE_BLACK=$(tput setaf 0); readonly STYLE_RED=$(tput setaf 1);
readonly STYLE_GREEN=$(tput setaf 2); readonly STYLE_YELLOW=$(tput setaf 3); readonly STYLE_BLUE=$(tput setaf 4);
readonly STYLE_MAGENTA=$(tput setaf 5); readonly STYLE_CYAN=$(tput setaf 6); readonly STYLE_WHITE=$(tput setaf 7);
readonly STYLE_BOLD=$( tput bold );


readonly CMD_TIME=`date +%Y.%m.%d_%H.%M.%S`