------------------------------------------------------
-- # Title : Winston 
------------------------------------------------------
-- # Description : A Modded-Minecraft Automation Assistant 
-- #             - built in 'Computer Craft'/'CC: Tweaked' and 'Advanced Peripherals'.
------------------------------------------------------



---------------------------
-- # Member Variable Declarations 
---------------------------

-- Change to direction or find
Monitor = nil --peripheral.find("monitor")

Scale = 1

PosX = Scale
PosY = Scale

CommandUser = "Broomfields"
CommandPhrase = "Winston"
CommandPhraseLength = string.len(CommandPhrase)



---------------------------
-- # Functions 
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

            if (comparison == CommandPhrase) then
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
    -- TODO
    return false
end


-- Main Process Function (TODO : Turn in to State Machine)
function MainProcess()

    AssertMonitorPresent()

    local box = peripheral.find("chatBox") -- Finds the peripheral if one is connected

    if (box == nil) then
    ErrorLine("chatBox not found")
    end

    ComputerLine("Waiting for messages...")
    NewLine()

    local inError = false
    while inError == false do

        local eventData = {os.pullEvent("chat")}
        local event = eventData[1]
        local username = eventData[2]
        local message = eventData[3]
            
        ChatLine("<" .. username .. "> " .. message)

        --Change to your username    
        if (username == CommandUser) then
            if (AssertCommand(message)) then
                
                ComputerLine("### Command Identified ###")
                box.sendMessage("Command Identified")
                
                if (ParseCommand(message)) then
                    ComputerLine("### Command Parsed ###")
                    box.sendMessage("Command Parsed")
                else
                    ComputerLine("### Command Not Parsed ### ")
                    box.sendMessage("Command Not Parsed")
                end
            end
        end
    end

    ComputerLine("Terminating Instance.") 
end



---------------------------
-- # Start Main Process 
---------------------------

MainProcess()