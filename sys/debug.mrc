alias lx.Debug {

        ;; debugging is hardcoded to 0. makes sense I guess.
        set %lx.debug 0

        if (%lx.debug == 1) {

                ;; I don't remember why I included an FPS counter,
                ;; or why I implemented it this way.
                inc %lx.fps.count

                if ($calc($ticks - %lx.fps.ticks.start) >= 1000) {

                        set %lx.fps.current %lx.fps.count
                        set %lx.fps.count 0
                        set %lx.fps.ticks.start $ticks
                }

                ;; calculate font scaling based on screenmode (resolution)
                var %s $calc(4 + (%lx.screenmode * 1.75))
                var %h $height(a,terminal,%s)

                ;; draw the fps / frame render time / ticks since start on screen
                .drawtext -nrb @lx.screen 16777215 0 terminal %s 2  2                  fps: %lx.fps.current
                .drawtext -nrb @lx.screen 65535    0 terminal %s 2 $calc(2 + %h)       frt: %lx.frt
                .drawtext -nrb @lx.screen 255      0 terminal %s 2 $calc(2 + (%h * 2)) ticks: $lx.ticks
        }
}