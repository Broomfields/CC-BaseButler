------------------------------------------------------
-- # Title : Base Butler - Peripherals Handler  
------------------------------------------------------

os.loadAPI("BaseButler/interaction.lua")

-- Initialises a connected Monitor
function InitialiseMonitor(monitor)    --Called only by AssertMonitorPresent()
    
    if (monitor ~= nil) then
        monitor.setBackgroundColour(colors.gray)
        monitor.setTextColour(1)
        monitor.setTextScale(1)
        monitor.setCursorPos(1,1)
        monitor.clear()
    end

    return monitor
end


-- Asserts if a Monitor is connected, relaying a relative message if this is a new change and initialising a Monitor it was just connected
function AssertMonitorPresent(monitor) -- Called in MainProcess()

    local monitorWasPresent = (monitor ~= nil)
    monitor = peripheral.find("monitor")
    local monitorPresent = (monitor ~= nil)

    if (monitorPresent == true) then
        
        if (monitorWasPresent == false) then
            interaction.ComputerLine("Monitor has been connected!", monitor)
            monitor = InitialiseMonitor()
        end
    else
        
        if (monitorWasPresent == true) then
            interaction.ErrorLine("Monitor has been disconnected!", monitor)
        end
    end

    return monitor
end


-- Asserts if a ChatBox is connected, relaying a relative message if this is a new change and initialising a ChatBox it was just connected
function AssertChatBoxPresent(chatBox) -- Called in MainProcess()

    local chatBoxWasPresent = (chatBox ~= nil)
    chatBox = peripheral.find("chatBox")
    local chatBoxPresent = (chatBox ~= nil)

    if (chatBoxPresent == true) then
        
        if (chatBoxWasPresent == false) then
            interaction.ComputerLine("ChatBox has been connected!", monitor)
            -- InitialiseChatBox() -- No such function - may be in future
        end
    else
        
        if (chatBoxWasPresent == true) then
            interaction.ErrorLine("ChatBox has been disconnected!", monitor)
        end
    end

    return chatBox
end