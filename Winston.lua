------------------------------------------------------
-- # Title : Winston 
------------------------------------------------------
-- # Description : A Modded-Minecraft Automation Assistant 
-- #             - built in 'Computer Craft'/'CC: Tweaked' and 'Advanced Peripherals'.
------------------------------------------------------



---------------------------
-- # Member Variable Declarations 
---------------------------

Monitor = nil --peripheral.find("monitor")
ChatBox = nil --peripheral.find("chatBox")

Scale = 1

PosX = Scale
PosY = Scale
    
CommandUser = "Broomfields"     --Change to your user name
CommandPhrase = "Winston"       --Change to your assistant name

CommandPhraseLength = string.len(CommandPhrase)



---------------------------
-- # General Utility Functions -- Will split off into a library later
---------------------------

-- Splits a string by a delimiter, defaults to whitespace
function Split(s, delimiter)
    result = {};

    if (delimiter == nil) then -- default to whitespace
        delimiter = " "
    end    
    
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end

    return result;
end


-- Returns the count of a table
function tableCount(table)
    local count = 0
    
    for _ in pairs(table) do
        count = count + 1
    end
    
    return count
  end

---------------------------
-- # Assistant Core Functions 
---------------------------

-- Initialises a connected Monitor
function InitialiseMonitor()    --Called only by AssertMonitorPresent()
    Monitor.setBackgroundColour(colors.gray)
    Monitor.setTextColour(1)
    Monitor.setTextScale(1)
    Monitor.setCursorPos(1,1)
    Monitor.clear()
end


-- Outputs any given text, and if specified, any give text type to the computer and a connected Monitor
function WriteLine(text, typeText)

    print("cursorPosY = " .. PosY)

    if (text == nil) then
        print("Error - WriteLine(text) - text == nil")
    else

        -- Outputs to computer
        if (typeText == nil) then
            print(text)
        else
            print(typeText .. " - " .. text)
        end    

        -- Outputs to the Monitor if one is present
        if (Monitor ~= nil) then

            Monitor.write(text)        
            Monitor.setCursorPos(PosX, PosY)
            PosY = PosY + Scale
        end
    end
end


-- Outputs any given text, and if specified, any give text type to the computer and a connected ChatBox
function SendChat(text, prefix)

    if (text == nil) then
        print("Error - SendChat(text) - text == nil")
    else
        -- Outputs to the Monitor if one is present
        if (ChatBox ~= nil) then
            ChatBox.sendMessage(text, prefix)
            print("Sent to chat : " .. text)
            os.sleep(1)
        end
    end
end


-- Outputs a new line to the computer
function NewLine()
    WriteLine("")
end


-- Outputs a formatted message from the program to the computer and a connected Monitor
function ComputerLine(text)
    
    if (Monitor ~= nil) then
        Monitor.setTextColour(colors.lightBlue)
    end

    WriteLine(text, "Computer")
    SendChat(text, CommandPhrase)

end


-- Outputs a formatted message from chat to the computer and a connected Monitor
function ChatLine(text)
    
    if (Monitor ~= nil) then
        Monitor.setTextColour(colors.white)
    end

    WriteLine(text, "Chat")

end


-- Outputs a formatted error message to the computer and a connected Monitor
function ErrorLine(text)
    
    if (Monitor ~= nil) then
        Monitor.setTextColour(colors.red)
    end
    
    WriteLine(text, "Error")

end


-- Asserts if a Monitor is connected, relaying a relative message if this is a new change and initialising a Monitor it was just connected
function AssertMonitorPresent() -- Called in MainProcess()

    local monitorWasPresent = (Monitor ~= nil)

    Monitor = peripheral.find("monitor")

    if (Monitor ~= nil) then
        
        if (monitorWasPresent == false) then
            ComputerLine("Monitor has been connected!")
            InitialiseMonitor()
        end
        return true

    else
        
        if (monitorWasPresent == true) then
            ErrorLine("Monitor has been disconnected!")
        end
        return false

    end
end


-- Asserts if a ChatBox is connected, relaying a relative message if this is a new change and initialising a ChatBox it was just connected
function AssertChatBoxPresent() -- Called in MainProcess()

    local chatBoxWasPresent = (ChatBox ~= nil)

    ChatBox = peripheral.find("chatBox")

    if (ChatBox ~= nil) then
        
        if (chatBoxWasPresent == false) then
            ComputerLine("ChatBox has been connected!")
            -- InitialiseChatBox() -- No such function - may be in future
        end
        return true

    else
        
        if (chatBoxWasPresent == true) then
            ErrorLine("ChatBox has been disconnected!")
        end
        return false

    end
end


-- Asserts that a command is present in the given text
function AssertCommand(text)

    if (text ~= nil) then

        if (string.len(text) >= CommandPhraseLength) then
            
            local comparison = string.sub(text, 1, CommandPhraseLength)
            print("### Command Assertion ###")
            print("Text: '" .. text .. "'")
            print("Subbed Comparison: '" .. comparison .. "'")
            print("Command Phrase: '" .. CommandPhrase .. "'")
            print("### End Command Assertion ###")

            if (string.upper(comparison) == string.upper(CommandPhrase)) then
                -- Command Found
                return true
            end 

        end

    else

        print("Error - AssertCommand(text) - text == nil")

    end
    
    -- Command Not Found
    return false
end


function ParseCommand(text)
    
    if (text ~= nil) then
        local parts = Split(text)
        local commandPhraseIndex = -1
        
        local count = tableCount(parts)
        local index = 1 -- lua indexes start at 1
        while (index < count) do

            local part = parts[index]

            if (commandPhraseIndex == -1) then
                
                if (string.upper(part) == string.upper(AssertCommand)) then
                    commandPhraseIndex = index
                end

            else

                -- TODO

            end

            -- TODO

        end

    end

    return false
end


function RefreshDisplay()
    
    if (Monitor ~= nil) then

        local monitorWidth = nil
        local monitorHeight = nil
        monitorWidth, monitorHeight = Monitor.getSize()

        if (PosY > monitorHeight) then
            Monitor.scroll(PosY - monitorHeight)      
        end
    end

end


-- Main Process Function (TODO : Turn in to State Machine)
function MainProcess()

    AssertChatBoxPresent()
    AssertMonitorPresent()

    ComputerLine("Waiting for messages...")
    NewLine()

    local inError = false
    while inError == false do

        AssertChatBoxPresent()
        AssertMonitorPresent()
        RefreshDisplay()

        local eventData = {os.pullEvent("chat")}
        local event = eventData[1]
        local username = eventData[2]
        local message = eventData[3]
            
        ChatLine("<" .. username .. "> " .. message)

        if (username == CommandUser) then
            if (AssertCommand(message)) then
                
                ComputerLine("~ Command Identified")
                
                if (ParseCommand(message)) then
                    ComputerLine("~ Command Parsed")
                else
                    ComputerLine("~ Command Not Parsed")
                end
            end
        end

        os.sleep(1)

    end

    ComputerLine("~ Terminating Instance") 
end



---------------------------
-- # Start Main Process 
---------------------------

MainProcess()