alias lx.sys.procManager {

        if ($1 == run) {

                ;; go through the list of active processes and execute them.
                ;; processes require an update routine in which all the processing is done.
                ;; there should be a seperate draw routine which the process manager can execute when required.
                var %cnt 1
                var %tot $line(@lx.procList, 0)

                ;lxLog 8 -
                ;lxLog 7 <procManager> running:

                while (%cnt <= %tot) {

                        var %line $line(@lx.procList, %cnt)
                        var %proc $gettok(%line, 2, 32)

                        ;lxLog 9 <procManager> %cnt : %line

                        if ($hget(%proc, draw) == 1) {

                                ;lxLog 10 <procManager> >> >> drawing

                                $hget(%proc, draw.exec)

                                lx.sys.gfx.bufferCopy %proc
                        }

                        $hget(%proc, exec)

                        inc %cnt
                }

                .timerlx.run -tmh 1 0 noop $!lx.sys.procManager.run( lx.sys.procManager )
        }

        elseif ($1 == new) {

                lxLog -

                ;; new processes require a unique ID paramater to be passed.
                ;; also, be sure to create a flag table with the same ID so the procmanager knows what to do!
                var %id $+(lx.proc.,$2)

                lxLog spawning new process: %id
                lxLog checking if id %id is available...

                if ($window(@lx.procList.tmp) != $null) {

                        window -c @lx.procList.tmp
                }

                window -h  @lx.procList.tmp
                clear      @lx.procList.tmp
                filter -ww @lx.procList @lx.procList.tmp $+(*,%id,*)

                var %tot $line(@lx.procList.tmp, 0)

                if (%tot > 0) {

                        lxLog  >> found %tot similar IDs

                        var %cnt 1

                        while (%cnt <= %tot) {

                                if (%id == $gettok($line(@lx.procList.tmp, %cnt), 2, 32)) {

                                        lx.panic  Attempted to create process with duplicate ID %id
                                        return
                                }

                                inc %cnt
                        }
                }

                else {

                        lxLog >> no ID conflicts detected.
                }

                lxLog Checking for flag table:

                if ($hget(%id) == $null) {

                        lxLog  >> Warning: no flag table found, creating...

                        hmake %id
                }

                lxLog flag table: %id
                lxLog Checking if draw flag is set...

                if ($hget(%id, draw) != $null) {

                        lxLog Yup!

                        var %window $+(@,%id)

                        lxLog checking if buffer exists...

                        if ($window(%window) == $null) {

                                var %w $hget(%id, buffer.w)
                                var %h $hget(%id, buffer.h)
                                var %x $hget(%id, pos.x)
                                var %y $hget(%id, pos.y)

                                if (%w == $null) {

                                        hadd %id buffer.w 320
                                        var %w 320

                                        lxLog  Warning: no buffer width specified! assuming 320.
                                }

                                if (%h == $null) {

                                        hadd %id buffer.h 240
                                        var %h 240

                                        lxLog  Warning: no buffer height specified! assuming 240.
                                }

                                if (%x == $null) {

                                        hadd %id pos.x
                                        var %y 32

                                        lxLog  Warning: no screen x pos specified! assuming 32.
                                }

                                if (%y == $null) {

                                        hadd %id pos.y 240
                                        var %y 32

                                        lxLog  Warning: no screen y pos specified! assuming 32.
                                }

                                lxLog  Buffer size: %w * %h
                                lxLog  opening buffer %window

                                window -ph %window 0 0 %w %h

                                hadd %id buffer %window
                        }

                        else {

                                lxLog       Attempted to create existing buffer $+(%window,!)
                                lx.panic  I refuse to overwrite any existing buffers.

                                halt
                        }

                        lxLog determining draw routine...

                        var %draw.exec $hget(%id, draw.exec)

                        if (%draw.exec == $null) {

                                lxLog draw exec blank, filling in

                                hadd %id draw.exec %id draw

                                var %draw.exec $hget(%id, draw.exec)
                        }

                        lxLog draw exec: %draw.exec
                }

                else {

                        lxLog draw flag not set.
                }

                lxLog determining run routine...

                var %exec $hget(%id, exec)

                lxLog current exec: %exec

                if (%exec == $null) {

                        lxLog exec is null

                        hadd %id exec %id run

                        var %exec %id
                }

                lxLog run routine: %exec
                lxLog determining priority...

                var %priority $hget(%id, priority)

                if (%priority == $null) {

                        hadd %id priority 64

                        var %priority 64

                }

                lxLog priority has been set to $+(%priority,)
                lxLog adding %priority %id to process list

                echo @lx.procList %priority %id

                lxLog -
        }

        elseif ($1 == exit) {

                lxLog  Request to terminate process: $2
                lxLog  Removing from proclist...

                filter -xww @lx.procList @lx.proclist.tmp $+(*, $2 ,*)

                lxLog resetting proclist...

                clear @lx.procList
                filter -ww @lx.proclist.tmp @lx.proclist

                lxLog done.
        }

        :error

        if ((%lx.panic != $null) || ($error != $null)) {

                lx.panic $iif($error, $error, %lx.panic)
                halt
        }
}

alias -l lx.sys.procManager.run {

        $1 run
}

;; Sort specified process according to its priority

alias -l sortProc {

        var %proc       $1
        var %priority   $2

        lxLog >> sorting %proc into proclist

        var %cnt        1
        var %tot        $line(@lx.procList, 0)

        while (%cnt <= %tot) {

                if (%priority < $gettok($line(@lx.procList, %cnt), 1, 32)) {

                        iline @lx.procList %cnt %priority %proc
                        break
                }

                inc %cnt
        }

        lxLog >> %proc sorted to position %cnt
}

alias -l load {

        var %file $1-

        lxLog  >> Loading %file
        load -rs $qt(%file)

        lxLog  >> initializing %file
        .signal -n $remove($+(lx.,$nopath($1-),.init),.mrc)
}

on *:SIGNAL:lx.sys.procManager.init: {

        lxLog Initializing processManager
        lxLog -
        lxLog Opening process list
        window -h @lx.procList
        clear @lx.procList

}