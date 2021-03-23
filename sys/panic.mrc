;; ah yes, the Pink Screen of Panic. aka a Panic Attack.
;; this is probably my favourite part of this project, I really tried to combine
;; the feeling/aesthetics of kernal panics, BSoDs, and Guru Meditations.
alias lx.panic {

        if ($timer(lx.run) != $null) {

                ;; if the main system loop timer is still active, kill it.
                .timerlx.run off
        }

        ;; "clever" way to replace the default error message.
        ;; could use some better wording tbh.
        var %error $replace($1-, not connected to server, nonexistant routine)

        ;; I don't know. I guess to make sure nothing gets repeated
        if ((%error != %lx.panic.lastPanic) && (%error != $null)) {

                lxLog 13 PANIC: %error
                set %lx.panic.lastPanic %error
                set %lx.panic.blink 0
        }

        else {

                ;; not sure why we're setting it in reverse here
                var %error %lx.panic.lastPanic
        }

        if ($window(@lx.screen) != $null) {

                ;; if we have a graphical screen open, draw a super cool panic message!
                var %font Fixedsys
                var %size 12

                var %w.text     $calc($width(%error, %font, %size) * 1.5)
                var %h.text     $height(%error, %font, %size)
                ;var %h.dialog   $calc(%h.text * 23)
                var %h.dialog   $calc((%h.text * (%lx.screen.h / %h.text)) - 128)
                var %w.dialog   $calc(%w.text + (%h.text * 2))

                var %x          $calc((%lx.screen.w / 2) - (%w.dialog / 2))
                var %x          -8
                var %y          $calc((%lx.screen.h / 2) - (%h.dialog / 2))
                var %y          64

                if (%lx.fade.c < 63) {

                        inc %lx.fade.c
                }

                else {

                        set %lx.fade.c 4
                }

                var %lx.fade.tab 2359332 2818091 3276850 3735609 4259906 4784201 5308497 5832793 6422625 6946922 7536754 8126588 8650884 9240717 9765013 10354846 10879142 11403438 11993270 12452030 12976325 13435085 13959380 14352603 14745826 15204583 15532269 15859954 16187639 16449787 16711935 16449787 16187639 15859954 15532269 15139048 14745826 14352603 13959380 13435085 12976326 12452030 11993271 11403438 10879142 10289310 9765013 9175180 8650884 8061052 7536755 6946922 6422626 5832793 5308497 4784201 4259905 3735610 3276850 2818091 2359333 1900574 1572887

                drawrect -nr @lx.screen $gettok(%lx.fade.tab, %lx.fade.c, 32) 4 %x %y $calc(%lx.screen.w + 20) %h.dialog

                var %text P-P-P-PANIC! (>.<);
                drawtext -nrb @lx.screen $rgb(255, 128, 255) 0 %font 32 $calc((%lx.screen.w / 2) - ($width(%text, %font, 32) / 2)) $calc(0 + %h.text) %text

                var %tot        $calc(%lx.screen.h / %h.text)
                var %offset     $calc($line(@lx.console.log, 0) - (%tot - 11))
                var %y          $calc(%y + (%h.text * 0))
                var %cnt        1

                ;; loop through the log to print all the recent messages!
                while (%cnt <= %tot) {

                        var %text       $line(@lx.console.log, %offset)
                        var %w.text     $width(%text, %font, %size)

                        if (%text != $null) {

                                drawtext -nrb @lx.screen $rgb(255, 128, 255) 0 %font %size $calc(%x + %h.text) $calc(%y + (%h.text * %cnt)) %text
                        }

                        inc %cnt
                        inc %offset
                }

                lx.proc.sys.gfx.UpdateScreen
        }

        set %lx.panic %error

        ;; print a neat little timer that counts down until reboot
        if ($timer(lx.panic.reboot) == $null) {

                ;; set reboot timer
                .timerlx.panic.reboot -t 1 10 lx.panic.reboot

                lxLog 04 Rebooting in $timer(lx.panic.reboot).secs
        }

        rline 04 @lx.console.log $line(@lx.console.log, 0) $+([,$lx.ticks,]) Rebooting in $timer(lx.panic.reboot).secs

        ;; emergency timer loop to update the panic screen
        .timerlx.panic -tmh 1 0 noop $!lx.panic.run( lx.panic )
        halt
}

alias -l lx.panic.run {

        $1 %lx.panic
}

alias -l lx.panic.reboot {

        ;; with just a handfull of men
        ;; we'll start all over again
        .timerlx.* off
        lx.sys.boot.loader
}