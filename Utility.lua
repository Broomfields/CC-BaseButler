------------------------------------------------------
-- # Title : Base Butler - General Utility Functions 
------------------------------------------------------

-- Splits a string by a delimiter, defaults to whitespace
function Split(s, delimiter)
    local result = {};

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
