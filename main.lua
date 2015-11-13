local loggly = require 'LogglyBufferMod'


loggly:init('861d2eb8-add3-4e66-ae02-fe147fa7e5aa', 2)


loggly:log({msg = [[11 Hola
mundo]]})
loggly:log('11 Hola mundo sin salto')
