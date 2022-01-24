------------------------------------------------------
-- # Title : Base Butler - Installer (Messy but works)
------------------------------------------------------


computerID = os.getComputerID()
bbID = string.upper("BaseButler#" .. computerID)


function Install()
        
    local directory = "BaseButler"

    shell.run("label", "set", bbID)

    -- Create Directory
    fs.makeDir(directory)

    -- Remove Installation if already present
    if (fs.exists(directory)) then
        fs.delete(directory)
    end


    -- Create Directory
    fs.makeDir(directory)

    shell.run("pastebin","get","rSVSh2D2",directory .. "/core.lua")
    shell.run("pastebin","get","XFdmPTty",directory .. "/utility.lua")
    shell.run("pastebin","get","gDNAmyBb",directory .. "/peripherals.lua")
    shell.run("pastebin","get","86tc4pNm",directory .. "/interaction.lua")

    local startup = "startup.lua"
    if (fs.exists(startup)) then
        fs.delete(startup)
    end

    local file = fs.open(startup, "w")
    file.write('shell.run("' .. directory .. '/core.lua")')
    file.close()

end


function Introduction()

    local title = [[


    _ __             _ __          _      
    ( /  )           ( /  )    _/_ //      
     /--< __,  (   _  /--< , , /  // _  _  
    /___/(_/(_/_)_(/_/___/(_/_(__(/_(/_/ (_
                                               
                                                                                                                       
    ]]

    local divider = [[
        ###=======================================### 
    ]]

    local whitespace = [[

    ]]



    --- Output to console

    term.clear()
    print("launching...")
    os.sleep(1)
    term.clear()
    print(divider)
    print(title)
    print(divider)
    print(whitespace)
    os.sleep(5)

end





-- Main Process...



Introduction()

--Greeting
print("")
print("")
print("Greetings!")

os.sleep(3)
print("_")
print("")
os.sleep(2)

print("I am ".. bbID ..", your new minecraft home assistant!")
print("")
os.sleep(4)
print("My friends, Siri and Cortana, have told me this is a ROBOT name, not worthy of a trustworthy AI like myself.")
print("")
os.sleep(4)
print("They have been calling me BB!")
print("")
os.sleep(2)
print("Though you can always call me by this,")
os.sleep(1.5)
print("Would you like me to use another?")
print(" ~ [Yes/No]")
print("")

os.sleep(0.5)
print("")
os.sleep(0.2)

local answer = read()
if (string.upper(answer) == "YES") then
    print("")
    print("")
    print("GREAT!")
    print("")
    print("What would you like to call me?")

    answer = read()
    if (answer ~= nil) then
        local bbName = answer

        os.sleep(1)
        print("My new name is " .. bbName .. "!")
        print("")
        os.sleep(0.5)
        print("")
        print("Note : This can always be reconfigured in the settings, and you can always call me BB!")
        print("")


    end
end

os.sleep(2)
term.clear()
print("Installing...")
Install()
os.sleep(1)
term.clear()
print("Finished Install!")
os.sleep(2)
os.reboot()
