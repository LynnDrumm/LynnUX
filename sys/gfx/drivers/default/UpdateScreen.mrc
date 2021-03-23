alias lx.proc.sys.gfx.UpdateScreen {

        .drawdot @lx.screen

        if (%lx.fullscreen == 1) {

                .drawcopy @lx.screen 0 0 %lx.screen.w %lx.screen.h @lx.screen.fs 0 0 %lx.fullscreen.w %lx.fullscreen.h
        }

        .drawrect -nrf @lx.screen 0 0 0 0 %lx.screen.w %lx.screen.h
}

on *:SIGNAL:lx.updateScreen.init: {

}