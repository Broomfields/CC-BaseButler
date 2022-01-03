-- Change to direction or find
monitor = peripheral.find("monitor")
monitor.setBackgroundColour(colors.gray)
monitor.setTextColour(1)
monitor.setTextScale(1)
monitor.setCursorPos(1,1)
monitor.clear()

scale = 1

posX = scale
posY = scale

commandPhrase = "Winston"
commandPhraseLength = string.len(commandPhrase)


-- Functions

function writeLine(text)

    print("cursorPosY = " .. posY)
    if text == nil then
        print("Error - writeline(text) - text == nil")
    else
        monitor.write(text)
        
        posY = posY + scale
        monitor.setCursorPos(posX, posY)
    end
end


function newLine()
    writeLine("")
end


function computerLine(text)
    monitor.setTextColour(colors.lightBlue)
    writeLine(text)
end


function chatLine(text)
    monitor.setTextColour(colors.white)
    writeLine(text)
end


function errorLine(text)
    monitor.setTextColour(colors.red)
    writeLine(text)
end


function assertCommand(text)

    if text == nil then
        print("Error - assertCommand(text) - text == nil")
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


function parseCommand(text)
    -- TODO
    return false
end


-- Start Main Process

local box = peripheral.find("chatBox") -- Finds the peripheral if one is connected

if box == nil then
   errorLine("chatBox not found")
   
end

computerLine("Waiting for messages...")
newLine()

local inError = false
while inError == false do

    local eventData = {os.pullEvent("chat")}
    local event = eventData[1]
    local username = eventData[2]
    local message = eventData[3]
        
    chatLine("<" .. username .. "> " .. message)

    --Change to your username    
    if username == "Broomfields" then
        if assertCommand(message) then
            
            computerLine("### Command Identified ###")
            box.sendMessage("Command Identified")
            
            if parseCommand(message) then
                computerLine("### Command Parsed ###")
                box.sendMessage("Command Parsed")
            else
                computerLine("### Command Not Parsed ### ")
                box.sendMessage("Command Not Parsed")
            end
        end
    end
end

computerLine("Terminating Instance.") 
