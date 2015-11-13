--[[
loggly.com module for Corona SDK
Copyright (c) 2015 Misael Madrigal
https://github.com/misaelmt/LogglyBufferMod
]]--


local json = require 'json'
local network = require 'network'

local requestBuffer = require 'libs.RequestBuffer.RequestBuffer'



local loggly = {
    token = nil,
    endpoint = nil,
    
    deviceInfo = {},
    
    ENVIRONMENT = 'environment',
    DEVICE = 'device',
    APP_NAME = 'appName',
    APP_VERSION_STRING = 'appVersionString',
    MODEL = 'model',
    SIMULATOR = 'simulator',
    POST = 'POST',
    NEW_LINE = '\n',
    
    debug = false,
}


local function networkListener(event)
    if event.isError then
        print('Error: ' .. event.response)
    elseif loggly.debug then
        print (event.response)
    end
end


local function callback()
    local message = {}
    message.body = ''
    
    for i = 1, requestBuffer.last do
        local data
        if type(requestBuffer.list[i]) ~= 'table' then
            data = {}
            data.content = requestBuffer.list[i]
        else
            data = requestBuffer.list[i]
        end
        data.deviceInfo = loggly.deviceInfo
        message.body = message.body .. json.encode(data) .. loggly.NEW_LINE
    end
    
    local headers = {}
    headers["content-type"] = "text/plain"
    local params = {}
    params.headers = headers

    print('loggly payload: ' .. message.body)
    network.request(loggly.endpoint, loggly.POST, networkListener, message, params)
end


local function add(data)
    if data ~= nil then
--        data = json.encode(data)
--        data = data:gsub(loggly.NEW_LINE, '')
        requestBuffer:add(data)
    end
end


local function getDeviceInfo()
    if system.getInfo(loggly.ENVIRONMENT) == loggly.DEVICE then
        loggly.deviceInfo.appName = system.getInfo(loggly.APP_NAME)
        loggly.deviceInfo.appVersion = system.getInfo(loggly.APP_VERSION_STRING)
        loggly.deviceInfo.deviceOS = system.getInfo(loggly.MODEL)
    elseif system.getInfo(loggly.ENVIRONMENT) == loggly.SIMULATOR then
        loggly.deviceInfo.deviceOS = 'Corona simulator: ' .. system.getInfo(loggly.MODEL)
    end
end


function loggly:init(token, bufferSize)
    requestBuffer:new(callback, bufferSize)
    self.token = token
    self.endpoint = 'http://logs-01.loggly.com/bulk/' .. token .. '/tag/bulk/'
end


function loggly:log(data)
    add(data)
end


-- Runtime:addEventListener("unhandledError", loggly.logError)
function loggly.logError(error)
    loggly:log({errorMessage = error.errorMessage, stackTrace = error.stackTrace})
end


getDeviceInfo()



return loggly