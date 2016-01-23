require "CiderDebugger";local loggly = require 'LogglyBufferMod'

display.setStatusBar( display.DefaultStatusBar )

loggly:init('861d2eb8-add3-4e66-ae02-fe147fa7e5aa')
loggly.debug = false

loggly:log({msg = [[5 Hello
World]]})
loggly:sendRequest()
loggly:log('5 No new line')
loggly:log()
loggly:log('Five')
loggly:log(5)
