alias lx.proc.gfx.gui.menubar {

        if ($1 == run) {

                noop

        }

        elseif ($1 == draw) {

                drawrect -nrf @lx.proc.gfx.gui.menubar $rgb(192, 192, 192) 0 0 0 %lx.screen.w 16

                ;; draw buttons from left to right

                set %lx.menuBar.button.widthCount 0

                drawButton [!] About...,$separator,Applications,Tools,System settings
                drawButton Edit Copy,Cut,Paste,$separator,Screenshot
                drawButton Special Restart,Exit

                ;; draw fps/clock at rightmost position

                var %text       $+($time,$str($chr(160), 10))
                set %lx.menuBar.button.widthCount $calc(%lx.screen.w - $width(%text, fixedsys, 12))

                drawButton %text

                set %lx.menuBar.button.widthCount $calc(%lx.menuBar.button.widthCount - $width($str($chr(160), 10), fixedsys, 12))

                drawButton $+(fps:,%lx.fps.current)
        }
}


alias -l drawButton {

        var %name $1

        var %text $+($chr(160),%name,$chr(160))
        var %w $width(%text, fixedsys, 12)

        var %x %lx.menuBar.button.widthCount

        if ($inrect(%lx.mouse.x, %lx.mouse.y, %x, 0, %w, 14) == $true) {

                if ((%lx.mouse.button.l == 1) && ($inrect(%lx.mouse.x, %lx.mouse.y, %x, 0, %w, $calc(14 + $+(%,lx.gfx.menu.,%name,.h))))) {

                        var %txtColour  $rgb(192, 192, 192)
                        var %bgColour   0

                        lx.gfx.drawMenu $calc(%x + 1) 18 $1 $2-
                }

                else {
                        var %txtColour  0
                        var %bgColour   $rgb(255, 255, 255)
                }
        }

        else {

                var %txtColour  0
                var %bgColour   $rgb(192, 192, 192)

                unset $+(%,lx.gfx.menu.,%name,.h)
        }

        drawtext -nrb @lx.proc.gfx.gui.menubar %txtColour %bgColour fixedsys 12 %x 0 %text

        inc %lx.menuBar.button.widthCount %w
}

alias -l clock {

        var %w $+($chr(160),$width($time),$chr(160))
        var %x $calc(%lx.screen.w - %w)

        drawtext -nr @lx.proc.gfx.gui.menubar 0
}
