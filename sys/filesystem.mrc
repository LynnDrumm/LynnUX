alias lx.fs.root {

        ;; I'm sure I had a good reason for this but right now I don't know
        return $+($gettok($scriptdir, $+(1-,$calc($numtok($scriptdir, 92) - 1)), 92),$1-)
}



on *:SIGNAL:lx.filesystem.init: {

        lxLog initializing filesystem driver

        lxLog root directory at $lx.fs.root
}