alias lx.gfx.drawMenu {

        var %x          $1
        var %y          $2
        var %name       $3
        var %contents   $4-
        var %items      $numtok(%contents, 44)
        var %h          $calc($height(A, fixedsys, 12) * (%items + .1))

        drawrect -nrf @lx.screen $rgb(192, 192, 192) 0 %x %y $width($separator, fixedsys, 12) %h

        var %cnt 1

        while (%cnt <= %items) {

                var %text $($gettok(%contents, %cnt, 44), 2)
                drawtext -nr @lx.screen 0 fixedsys 12 %x %y %text

                inc %y 17
                inc %cnt
        }
        unset %lx.gfx.menu.*.h
        set $+(%,lx.gfx.menu.,%name,.h) %h
}

alias -l separator {

        return ----------------
}