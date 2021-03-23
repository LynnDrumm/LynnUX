alias lx.sys.gfx.ScreenMode {

        var %modeTab    lx.gfxDriver.modes
        var %confTab    lx.gfxDriver.config
        var %activeMode $hget(%confTab, screenMode)
        var %input      $1-

        if ($isid) {

                if ($1 == $null) {

                        return %activeMode
                }

                else {
                        if ($1 == $null) {

                                var %input %activeMode
                        }

                        if ($prop == w) {

                                return $gettok($hget(%modeTab, %input), 1, 42)
                        }

                        elseif ($prop == h) {

                                return $gettok($hget(%modeTab, %input), 2, 42)
                        }
                }
        }

        else {

                if ($1 isnum) {

                        lxLog Setting screenmode: %input

                        set %lx.screen.w $gettok($hget(%modeTab, %input), 1, 42)
                        set %lx.screen.h $gettok($hget(%modeTab, %input), 2, 42)

                        set %lx.screenmode $1
                }

                elseif ($1 == -c) {

                        lxLog Setting custom screenmode: $2-

                        set %lx.screen.w $2
                        set %lx.screen.h $3

                        set %lx.screenmode 0
                }

                set %lx.screen.x 0
                set %lx.screen.y 0

                lxLog Screen will be set to %lx.screen.w * %lx.screen.h

                window -dk0pfh @lx.screen %lx.screen.x %lx.screen.y %lx.screen.w %lx.screen.h
        }
}

on *:SIGNAL:lx.ScreenMode.init: {

        lxLog screenmode init

        var %confTab lx.gfxDriver.config
        var %modeTab lx.gfxDriver.modes

        lxLog is confTab loaded?

        if ($hget(%confTab) != $null) {

                lxLog ... yes
        }

        else {

                lxLog ... no
        }

        ;; Set the screenmode

        lx.sys.gfx.ScreenMode $hget(%confTab, screenmode)

        ;; Go fullscreen if it's allowed

        set %lx.fullscreen $hget(%confTab, fullscreen)

        if (%lx.fullscreen == 1) {

                lxLog Going fullscreen...

                set %lx.fullscreen.w $window(-1).w
                set %lx.fullscreen.h $window(-1).h

                if ($window(@lx.screen.fs) != $null) {

                        window -c @lx.screen.fs
                }

                window -dak0pfBb +d @lx.screen.fs 0 0 %lx.fullscreen.w %lx.fullscreen.h
        }

}