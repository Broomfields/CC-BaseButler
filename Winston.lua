-- Change to direction or find
monitor = peripheral.find("monitor")

scale = 1

posX = scale
posY = scale

commandPhrase = "Winston"
commandPhraseLength = string.len(commandPhrase)


-- Functions


-- Initialises a connected monitor
function InitialiseMonitor()    --Called only by AssertMonitorPresent()
    monitor.setBackgroundColour(colors.gray)
    monitor.setTextColour(1)
    monitor.setTextScale(1)
    monitor.setCursorPos(1,1)
    monitor.clear()
end


-- Outputs any given text, and if specified, any give text type to the computer and a connected monitor
function WriteLine(text, typeText = "")

    print("cursorPosY = " .. posY)
    if text == nil then
        print("Error - WriteLine(text) - text == nil")
    else

        -- Outputs to computer
        if (typeText == nil) then
            print(text)
        else
            print(typeText .. " - " .. text)
        end    

        -- Outputs to the monitor if one is present
        if (AssertMonitorPresent() == true)

            monitor.write(text)
        
            posY = posY + scale
            monitor.setCursorPos(posX, posY)
        end
    end
end


-- Outputs a new line to the computer
function NewLine()
    WriteLine("")
end


-- Outputs a formatted message from the program to the computer and a connected monitor
function ComputerLine(text)
    monitor.setTextColour(colors.lightBlue)
    WriteLine(text, "Computer")
end


-- Outputs a formatted message from chat to the computer and a connected monitor
function ChatLine(text)
    monitor.setTextColour(colors.white)
    WriteLine(text, "Chat")
end


-- Outputs a formatted error message to the computer and a connected monitor
function ErrorLine(text)
    monitor.setTextColour(colors.red)
    WriteLine(text, "Error")
end


-- Asserts if a monitor is connected, relaying a relative message if this is a new change and initialising a monitor it was just connected
function AssertMonitorPresent() -- Called in MainProcess()

    local monitorWasPresent = !(monitor == nil)

    monitor = peripheral.find("monitor")

    if (monitor == nil) then
        
        if (monitorWasPresent == true) then
            ErrorLine("Monitor has been disconnected!")
        end

        return false
    else
        
        if (monitorWasPresent == false) then
            ComputerLine("Monitor has been connected!")
            InitialiseMonitor()
        end

        return true
    end
end


-- Asserts that a command is present in the given text
function AssertCommand(text)

    if text == nil then
        print("Error - AssertCommand(text) - text == nil")
    else
        if string.len(text) >= commandPhraseLength then
            
            local comparison = string.sub(text, 1, commandPhraseLength)
            print("### Command Assertion ###")
            print("Text: '" .. text .. "'")
            print("Subbed Comparison: '" .. comparison .. "'")
            print("Command Phrase: '" .. commandPhrase .. "'")
            print("### End Command Assertion ###")

            if comparison == commandPhrase then
                -- Command Found
                return true
            end 
        end
    end
    
    -- Command Not Found
    return false
end


function ParseCommand(text)
    -- TODO
    return false
end



-- \\\\\\\\\\\\\\\\\\\\\\\\\-
-- # Start Main Process (Will be moved to a state machine at somepoint)
-- \\\\\\\\\\\\\\\\\\\\\\\\\-

local box = peripheral.find("chatBox") -- Finds the peripheral if one is connected

if box == nil then
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
    if username == "Broomfields" then
        if AssertCommand(message) then
            
            ComputerLine("### Command Identified ###")
            box.sendMessage("Command Identified")
            
            if ParseCommand(message) then
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
