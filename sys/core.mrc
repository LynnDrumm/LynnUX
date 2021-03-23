;; not sure what calls this or what it's for
alias lx.core {

        lx.debug

        lx.sys.procManager run

        ;; does this trigger a panic attack or just initialise it?
        lx.sys.initiatePanicAttack

        ;; this updates the screen but I'm not sure why this function's
        ;; name is being passed to it
        lx.gfx.updateScreen lx.core

        return

        ;; I guess this script is the core (ha!) of everything,
        ;; since any error that occurs will jump back through it's parent
        ;; function until it encounters this label
        :error

        ;; I guess %lx.panic is only set if something bad happens,
        ;; else things just continue on like nothing happened
        if ((%lx.panic != $null) || ($error != $null)) {

                lx.panic $iif($error, $error, %lx.panic)
                halt
        }
}