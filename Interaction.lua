------------------------------------------------------
-- # Title : Base Butler - Interaction Functions  
------------------------------------------------------

---------------------------
-- # Member Variable Declarations 
---------------------------

Scale = 1

PosX = Scale
PosY = Scale
    


-- Outputs any given text, and if specified, any give text type to the computer and a connected Monitor
function WriteLine(monitor, text, typeText) -- monitor essential so place at beginning

    print("cursorPosY = " .. PosY)

    if (text == nil) then
        print("Error - WriteLine(monitor, text) - text == nil")
    else

        -- Outputs to computer
        if (typeText == nil) then
            print(text)
        else
            print(typeText .. " - " .. text)
        end    

        -- Outputs to the Monitor if one is present
        if (monitor ~= nil) then

            monitor.write(text)        
            monitor.setCursorPos(PosX, PosY)
            PosY = PosY + Scale
        end
    end
end


-- Outputs any given text, and if specified, any give text type to the computer and a connected ChatBox
function SendChat(chatBox, text, prefix) -- chatBox essential so place at beginning

    if (text == nil) then
        print("Error - SendChat(text) - text == nil")
    else
        -- Outputs to the Monitor if one is present
        if (chatBox ~= nil) then
            chatBox.sendMessage(text, prefix)
            print("Sent to chat : " .. text)
            os.sleep(1)
        end
    end
end


-- Outputs a new line to the computer
function NewLine(monitor)
    WriteLine(monitor, "")
end


-- Outputs a formatted message from the program to the computer and a connected Monitor
function ComputerLine(text, monitor, chatBox) -- peripherals allowed to be null so place at end
    
    if (monitor ~= nil) then
        monitor.setTextColour(colors.lightBlue)
    end

    WriteLine(monitor, text, "Computer")
    SendChat(chatBox, text, CommandPhrase)

end


-- Outputs a formatted message from chat to the computer and a connected Monitor
function ChatLine(text, monitor) -- monitor allowed to be null so place at end
    
    if (monitor ~= nil) then
        monitor.setTextColour(colors.white)
    end

    WriteLine(monitor, text, "Chat")

end


-- Outputs a formatted error message to the computer and a connected Monitor
function ErrorLine(text, monitor) -- monitor allowed to be null so place at end
    
    if (monitor ~= nil) then
        monitor.setTextColour(colors.red)
    end
    
    WriteLine(monitor, text, "Error")

end


-- Refreshes Display
function RefreshDisplay(monitor)
    
    if (monitor ~= nil) then

        local monitorWidth = nil
        local monitorHeight = nil
        monitorWidth, monitorHeight = Monitor.getSize()

        if (PosY > monitorHeight) then
            monitor.scroll(PosY - monitorHeight)      
        end
    end

end