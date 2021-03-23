on *:SIGNAL:lx.sys.guiLoader.init: {

        lxLog Loading GUI elements...

        var %items desktop,menubar,mousecursor

        var %cnt 1
        var %tot $numtok(%items, 44)

        while (%cnt <= %tot) {

                var %item $gettok(%items, %cnt, 44)

                var %proc $+(gfx.gui.,%item)
                var %file $+($scriptdirgui\,%item,.mrc)

                var %proc $+(lx.proc.gfx.gui.,%item)

                if ($hget(%proc) != $null) {

                        hfree %proc
                }

                lxLog making table %proc

                hmake %proc
                lxLog hload -i %proc $qt($+($scriptdirgui\,%item,.ini)) flags
                hload -i %proc $qt($+($scriptdirgui\,%item,.ini)) flags

                load %file

                var %proc $+(gfx.gui.,%item)

                lx.sys.procmanager new %proc

                inc %cnt
        }

        var %files menu.mrc

        var %cnt 1
        var %tot $numtok(%files, 44)

        while (%cnt <= %tot) {

                load $+($scriptdirgui\,$gettok(%files, %cnt, 44))

                inc %cnt
        }

}


alias -l load {

        lxLog >> loading $1-

        .load -rs $1-
        signal -n $remove($+(lx.,$nopath($1-),.init),.mrc)
}
