alias lx.proc.gfx.gui.mouseCursor {

        var %table lx.proc.gfx.gui.mouseCursor

        if ($1 == run) {

                ;; in the future, maybe add some stuff to change the cursor depending on context.

                hadd %table cursor $scriptdircursors\pointer.png

                if (%lx.fullscreen == 1) {

                        hadd %table pos.x $calc($mouse.x / (%lx.fullscreen.w / %lx.screen.w))
                        hadd %table pos.y $calc($mouse.y / (%lx.fullscreen.h / %lx.screen.h))
                }

                else {

                        hadd %table pos.x $mouse.x
                        hadd %table pos.y $mouse.y
                }

                ;; check/set button status

                ;; left button

                if ($mouse.key & 1) {

                        hadd %table button.l 1
                }

                else {

                        hadd %table button.l 0
                }

                ;; right button

                if ($mouse.key & 16) {

                        hadd %table button.r 1
                }

                else {

                        hadd %table button.r 0
                }
        }

        elseif ($1 == draw) {

                drawpic -nrct $hget(%table, buffer) $rgb(0, 255, 255) $hget(%table, pos.x) $hget(%table, pos.y) $qt($hget(%table, cursor))
                ;drawpic -nrct $hget(%table, buffer) $rgb(0, 255, 255) 0 0 $qt($hget(%table, cursor))
        }
}

on *:SIGNAL:lx.mouseCursor.init: {

        lxLog >> initializing mouse cursor driver...

        var %table lx.proc.gfx.gui.mouseCursor

        if ($hget(%table) == $null) {

                hmake %table
        }

        hadd lx.proc.gfx.gui.mouseCursor cursor $scriptdircursors\pointer.png

        lxLog hiding root cursor...

        lxLog $dll($lx.fs.root(\sys\dll\HideCursor.dll),hidecursor,1)
}