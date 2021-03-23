alias lx.console {

        var %consoleX   10
        var %consoleY    4
        var %consoleW   60
        var %consoleH   22

        var %font "lucida console"
        var %size 9

}

alias -l drawConsole {

        var %id     $1

        var %x      $2
        var %y      $3
        var %w      $4
        var %y      $5

        var %font   $6
        var %size   $7
        var %colour $8

        var %input  $9-

        var %win $+($+(@lx.console.,%id)

        var %offset $hget($+(lx.console.,%id), offset)

        var %cnt %offset
        var %cnt $calc(%h + %offset)

        while (%cnt < %tot) {

                drawtext -nr %win %colour %font %size %x $calc(%y + ((%size + 2) * %cnt)) $line(%win, %cnt)

                inc %cnt
        }

        drawtext -nr %win %colour %font %size %x $calc(%y + ((%size + 2) * %cnt))  $line(%win, %cnt) $+(%input,▒)
}

alias -l openConsole {

        var %id $1

        lxLog lx.console: Opening new console with id %id

        ;; create table name with id

        var %table $+(lx.console.,%id)

        ;; check if table does not exist yet, otherwise, throw an error.

        if ($hget(%table) != $null) {

                ;; store the console's properties inside a table.

                hadd %table x      $2
                hadd %table y      $3
                hadd %table w      $4
                hadd %table y      $5

                hadd %table font   $6
                hadd %table size   $7
                hadd %table colour $8
        }

        ;; create window to log to.

        var %window $+(@lx.console.,%id)

        window -h %window

        ;; write the console greet message.

        echo %window lx $lx.version console.
}