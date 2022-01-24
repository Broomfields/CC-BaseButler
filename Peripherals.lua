------------------------------------------------------
-- # Title : Base Butler - Peripherals Handler  
------------------------------------------------------

os.loadAPI("Interaction")

-- Initialises a connected Monitor
function InitialiseMonitor(monitor)    --Called only by AssertMonitorPresent()
    
    if (monitor ~= nil) then
        monitor.setBackgroundColour(colors.gray)
        monitor.setTextColour(1)
        monitor.setTextScale(1)
        monitor.setCursorPos(1,1)
        monitor.clear()
    end
end


-- Asserts if a Monitor is connected, relaying a relative message if this is a new change and initialising a Monitor it was just connected
function AssertMonitorPresent(monitor) -- Called in MainProcess()

    local monitorWasPresent = (monitor ~= nil)
    monitor = peripheral.find("monitor")
    local monitorPresent = (monitor ~= nil)

    if (monitorPresent == true) then
        
        if (monitorWasPresent == false) then
            Interaction.ComputerLine("Monitor has been connected!")
            InitialiseMonitor()
        end
    else
        
        if (monitorWasPresent == true) then
            Interaction.ErrorLine("Monitor has been disconnected!")
        end
    end

    return monitorPresent
end


-- Asserts if a ChatBox is connected, relaying a relative message if this is a new change and initialising a ChatBox it was just connected
function AssertChatBoxPresent(chatBox) -- Called in MainProcess()

    local chatBoxWasPresent = (chatBox ~= nil)
    chatBox = peripheral.find("chatBox")
    local chatBoxPresent = (chatBox ~= nil)

    if (chatBoxPresent == true) then
        
        if (chatBoxWasPresent == false) then
            Interaction.ComputerLine("ChatBox has been connected!")
            -- InitialiseChatBox() -- No such function - may be in future
        end
    else
        
        if (chatBoxWasPresent == true) then
            Interaction.ErrorLine("ChatBox has been disconnected!")
        end
    end

    return chatBoxPresent
end