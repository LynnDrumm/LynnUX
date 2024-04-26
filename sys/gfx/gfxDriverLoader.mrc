on *:SIGNAL:lx.sys.gfxDriverLoader.init: {

        ;; initialize/load driver configuration/info tables.
        lxLog !!!!!! gfxDriverLoader initializing... !!!!!!!!!!

        var %ini $scriptdirgfxDriverConfig.ini

        if ($isfile(%ini) = $true) {

                var %confTab lx.gfxDriver.config
                var %infoTab lx.gfxDriver.info
                var %modeTab lx.gfxDriver.modes

                lxLog >> confTab: %confTab
                lxLog >> infoTab: %infoTab

                lxLog Loading configuration table...

                if ($hget(%confTab) != $null) {

                        lxLog table %confTab already exists; freeing...

                        hfree %confTab
                }

                hmake -m %confTab
                hload -i %confTab $qt(%ini) config

                lxLog Loading screenmodes table...

                if ($hget(%modeTab) != $null) {

                        lxLog table %modeTab already exists; freeing...

                        hfree %modeTab
                }

                hmake -m %modeTab
                hload -i %modeTab $qt(%ini) modes

                lxLog Loading info table...

                if ($hget(%infoTab) != $null) {

                        lxLog table %infoTab already exists; freeing...

                        hfree %infoTab
                }

                hmake -m %infoTab
                hload -i %infoTab $qt(%ini) info

                lxLog Loading driver: $hget(%infoTab, name) $+($hget(%infoTab, version),$chr(44)) by $+($hget(%infoTab, author),.)

                ;; Load and initialize all the driver's files.
                var %dir $+($scriptdirdrivers\,$hget(%infoTab, name))

                if ($isdir(%dir) == $true) {

                        lxLog >> loading from %dir

                        echo -s $findFile(%dir, *.mrc, 0, 0, load $1-)

                        lxLog >> initialize screenMode
                        .signal -n lx.ScreenMode.init
                }

                else {

                        lxLog FATAL ERROR: Configured graphics driver not found: %dir
                        halt
                }

                ;;

                lxLog Testing if screen exists...

                if ($window(@lx.screen) != $null) {

                        lxLog Starting screen updates...

                        lx.sys.procManager new sys.gfx.updateScreen
                }

                else {

                        lx.panic screen failed to open somehow :(
                        halt
                }

        }

        else {

                lx.panic missing configuration for gfx driver: %ini
                halt
        }

}

alias -l load {

        lxLog >> $1-
        signal -n $remove($+(lx.,$nopath($1-),.init),.mrc)
        .load -rs $1-
}