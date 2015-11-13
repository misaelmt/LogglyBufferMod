local loggly = require 'LogglyBufferMod'


loggly:init('861d2eb8-add3-4e66-ae02-fe147fa7e5aa')
loggly.debug = false

loggly:log({msg = [[12 Hola
mundo]]})
loggly:log('12 Hola mundo sin salto')
loggly:log()
loggly:log('tres')
loggly:log(4)
