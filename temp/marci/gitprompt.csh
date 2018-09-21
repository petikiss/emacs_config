setenv GIT_BRANCH_CMD "sh -c 'git branch --no-color 2> /dev/null' | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'"
#set prompt="%m:%~ `$GIT_BRANCH_CMD`%B%#%b "
set prompt="%m:%~ %B`$GIT_BRANCH_CMD`%b %B%#%b "

#setenv GIT_BRANCH_CMD "sh -c 'git branch --no-color 2> /dev/null' | sed -e '/^[^]/d' -e 's/ (.*)/(\1) /'"
#set prompt="%{\033[34m%}%n@%B%m%b %B%{\033[31m%}%~%b %{\033[36m%}$GIT_BRANCH_CMD%{\033[39m%}%h ) "
