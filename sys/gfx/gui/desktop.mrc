alias lx.proc.gfx.gui.desktop {

        if ($1 == run) {

                set %lx.wallpaper $($hget(lx.proc.gfx.gui.desktop, wallpaper), 2)

        }

        elseif ($1 == draw) {

                if (%lx.wallpaper != $null) {

                        drawpic -nsc @lx.proc.gfx.gui.desktop 0 0 %lx.screen.w %lx.screen.h $qt(%lx.wallpaper)
                }

        }

}

on *:SIGNAL:lx.proc.gfx.gui.desktop.init: {

}