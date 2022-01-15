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

Programs = {};
table.insert(Programs, "Information")
table.insert(Programs, "Update")            -- Set And Get
table.insert(Programs, "Reboot")
table.insert(Programs, "Message")
table.insert(Programs, "Message")
table.insert(Programs, "Speak")
table.insert(Programs, "CommandUser")       -- Set And Get
table.insert(Programs, "CommandPhrase")     -- Set And Get
table.insert(Programs, "Label")             -- Set And Get
table.insert(Programs, "MonitorColour")     -- Set And Get
table.insert(Programs, "MonitorTextColour") -- Set And Get
table.insert(Programs, "MonitorScale")      -- Set And Get
table.insert(Programs, "Mute")              -- Set And Get

-- Set And Get Power Networks (Network is defined with ID and has configurable ports)
table.insert(Programs, "Power")  -- Network{On, Off}, Network{Set, Edit, Remove [Input, Output] ports}, Network{List [Input, Output, All] ports and networks}, Network{Measure (Total Difference, Active Difference, Active Rate)}, Network{Ratio}



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
function Count(table)
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


-- Parses identified command line in chat and calls relevant program
function ParseCommand(text)
    
    if (text ~= nil) then
        local parts = Split(text)
        local commandPhraseIndex = -1
        local commandProgramIndex = -1
        
        local programsCount = Count(Programs)
        local partsCount = Count(parts)
        
        print("[DEBUG] Parts Count = " .. partsCount)

        local partIndex = 0 -- lua indexes start at 1, so increment at start
        while (partIndex < partsCount) do

            partIndex = partIndex + 1

            local part = parts[partIndex]

            print("[DEBUG] Parts Index = " .. partsCount .. " | Part = " .. part)

            -- Identify Command Phrase
            if (commandPhraseIndex == -1) then
                
                if (string.upper(part) == string.upper(CommandPhrase)) then
                    commandPhraseIndex = partIndex
                end

            -- Identify Command / Program
            elseif (commandProgramIndex == -1) then

                print("[DEBUG] Program Count = " .. programsCount)

                local programIndex = 1 -- lua indexes start at 1, so increment at start      
                while (programIndex < programsCount) do
                    programIndex = programIndex + 1

                    local program = Programs[programIndex]

                    print("[DEBUG] Program Index = " .. programIndex .. " | Program = " .. program)

                    if (string.upper(part) == string.upper(program)) then
                        commandProgramIndex = programIndex
                        print("[DEBUG] Program Matched!")

                        break
                    end

                    os.sleep(0) -- Allow for thread to yield
                end

                if (commandProgramIndex > -1) then
                    break
                end

            end

            -- Run Identified Program
            if (commandProgramIndex > -1) then -- Maybe add option for searching args later
                print("[DEBUG] Running Program: " .. Programs[programIndex])
                RunProgram(Programs[programIndex])
                return true
            end

        end

        os.sleep(0) -- Allow for thread to yield
    end

    return false
end


-- Runs given program
function RunProgram(text)

    if (text ~= nil) then
        -- ToDo
    end

end


-- Refreshes Display
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