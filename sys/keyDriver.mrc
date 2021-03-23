;; why the fuck would I pass these events to functions when I could handle them directly??
on *:KEYDOWN:@lx.screen:*: {

        keydown $keyval $keychar $keyrpt
}


on *:KEYUP:@lx.screen:*: {

        keyup $keyval $keychar $keyrpt
}

on *:KEYDOWN:@lx.screen.fs:*: {

        keydown $keyval $keychar $keyrpt
}


on *:KEYUP:@lx.screen.fs:*: {

        keyup $keyval $keychar $keyrpt
}

alias -l keydown {

        lxLog lx.keyDriver: asc: $keyval chr: $keychar rpt: $keyrpt

        ;; hardkeys:

        ;; p(anic) -- forces a panic. for testing.
        if ($keyval == 80) {

                lx.panic blarg im ded
        }
}

alias -l keyup {

}