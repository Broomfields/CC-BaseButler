------------------------------------------------------
-- # Title : Base Butler 
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
CommandPhrase = "BB"       --Change to your assistant name

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


os.loadAPI("Utility")
os.loadAPI("Peripherals")
os.loadAPI("Interaction")


---------------------------
-- # Assistant Core Functions 
---------------------------

-- Parses identified command line in chat and calls relevant program
function ParseCommand(text)
    
    if (text ~= nil) then
        local parts = Split(text)
        local commandPhraseIndex = -1
        local commandProgramIndex = -1
        local matchedProgram = nil
        
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
                        matchedProgram = Programs[programIndex]
                        print("[DEBUG] Program Matched!")
                        break
                    end

                    os.sleep(0) -- Allow for thread to yield
                end

                if (matchedProgram ~= nil) then
                    break
                end

            end

            -- Run Identified Program
            if (matchedProgram ~= nil) then -- Maybe add option for searching args later
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
        -- Find Program Location (Probably just a programs folder)
        -- Run Program
    end

end



-- Main Process Function (TODO : Turn in to State Machine)
function MainProcess()


    Interaction.ComputerLine("Waiting for messages...")
    Interaction.NewLine()

    local inError = false
    while inError == false do

        Peripherals.AssertChatBoxPresent(ChatBox)
        Peripherals.AssertMonitorPresent(Monitor)
        Interaction.RefreshDisplay(Monitor)

        local eventData = {os.pullEvent("chat")}
        local event = eventData[1]
        local username = eventData[2]
        local message = eventData[3]
            
        Interaction.ChatLine("<" .. username .. "> " .. message)

        if (username == CommandUser) then
            if (AssertCommand(message)) then
                
                Interaction.ComputerLine("~ Command Identified")
                
                if (ParseCommand(message)) then
                    Interaction.ComputerLine("~ Command Parsed")
                else
                    Interaction.ComputerLine("~ Command Not Parsed")
                end
            end
        end

        os.sleep(1)

    end

    Interaction.ComputerLine("~ Terminating Instance") 
end



---------------------------
-- # Start Main Process 
---------------------------

MainProcess()