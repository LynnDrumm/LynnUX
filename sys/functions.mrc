;; this was apparently a very necessary function to have and isolate into
;; it's own file? I wonder in how many places this is actually used.
alias lx.ticks {

        return $calc($ticks - %lx.ticks.start)
}

