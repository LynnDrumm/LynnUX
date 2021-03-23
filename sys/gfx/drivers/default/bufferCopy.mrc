alias lx.sys.gfx.bufferCopy {

        var %proc $1

        var %t          $($hget(%proc, buffer.t),2)
        var %w          $($hget(%proc, buffer.w),2)
        var %h          $($hget(%proc, buffer.h),2)
        var %x          $($hget(%proc, pos.x),   2)
        var %y          $($hget(%proc, pos.y),   2)
        var %buffer     $($hget(%proc, buffer),  2)

        if (%t != $null) {

                drawcopy -nt %buffer %t 0 0 %w %h @lx.screen %x %y %w %h

        }

        else {

                drawcopy -n %buffer 0 0 %w %h @lx.screen %x %y %w %h
        }
}