alias lxLog {

        if ($1 == -) {

                ;; if the message is just a dash, make it a cool separator
                var %msg 11 @lx.console.log $str(-, 60) ----- ---- --- -- -
        }

        elseif ($1 isnum) {

                ;; if first token in the message is a number, interpret it as a
                ;; mIRC color code to colorise the message.
                var %msg $1 @lx.console.log $ts $2-
        }

        else {

                var %msg @lx.console.log $ts $1-
        }

        echo %msg
}

alias -l ts {

        ;; return timestamp
        return $+([,$lx.ticks,])
}

on *:SIGNAL:lx.sys.log.init: {

        ;; make a full screen window for the console log
        window -ak0Bfd +b @lx.console.log 0 0 $window(-1).w $window(-1).h
        font @lx.console.log 12 fixedsys
        clear @lx.console.log
}