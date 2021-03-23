alias lx.sys.boot.loader {

        ;; start cleaning the environment.
        ;; (no, sorry greenpeace, not like that.)
        unset %lx.*
        set %lx.ticks.start $ticks

        echo -s freeing old lx hashtables...
        hfree -w lx.*

        echo -s closing old lx windows...
        var %i $window(@lx.*, 0)
        echo -s >> %tot windows found

        while (%i > 0) {

                var %win $window(@lx.*, %i)

                echo -s >> >> %i %win

                if (%win != $null) {

                        window -c %win
                }

                dec %i
        }

        ;; load logger
        load $scriptdirlog.mrc

        lxLog lx 1.0 bootloader
        lxLog -
        lxLog Unloading all unneeded scripts...

        ;; list of scripts to keep
        var %keep $scriptdirlog.mrc $scriptdirboot.mrc

        var %i 1
        var %tot $script(0)

        while (%i <= %tot) {

                var %script $script(%i)

                if (%script != $null) {

                        if (%script !isin %keep) {

                                lxLog >> unloading %script
                                .unload -rs $qt(%script)
                        }

                        else {

                                lxLog skipping system file %script
                        }
                }

                inc %i
        }

        lxLog loading essential files...

        load $scriptdirfunctions.mrc
        load $scriptdirpanic.mrc
        load $scriptdirprocManager.mrc

        lxLog Booting...
        lxLog -

        if ($hget(@lx.boot) != $null) {

                hfree lx.boot
        }

        hmake lx.boot
        hadd lx.boot counter 1

        lx.sys.procManager new sys.boot
        lx.sys.procManager run

        return
}

alias lx.proc.sys.boot {

        ;; contains list of instructions to run to boot the system
        var %file $scriptdirboot.lx
        var %i  $hget(lx.boot, counter)

        var %read $read(%file, %i)

        lxLog boot: %read

        %read

        if (%i <= $lines(%file)) {

                hinc lx.boot counter
        }

        else {

                lxLog $alias Boot sequence complete.
                lx.sys.procManager exit lx.proc.sys.boot
        }
}

alias -l load {

        ;; if the logger is loaded, print loader message, otherwise skip.
        if ($isalias(lxLog) == $true) {

                lxLog loading $1-
        }

        .load -rs $1-
        signal -n $remove($+(lx.sys.,$nopath($1-),.init),.mrc)
}

on *:LOAD: {

        ;; run bootloader immediately when loading this file (boot.mrc)
        lx.sys.boot.loader
}

on *:CLOSE:@lx.*: {

        ;; disable the hide cursor DLL. I don't remember why this is in boot.mrc
        noop $dll($lx.fs.root(\sys\dll\HideCursor.dll),hidecursor,0)
}