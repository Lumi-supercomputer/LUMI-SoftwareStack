#!/usr/bin/env lua

local args = {...}

input_version = args[1]
table.remove( args, 1 )

if not string.find( input_version, 'versions%-%d%d%.%d%d%.txt' ) and not string.find( input_version, 'versions%-contrib%-%d%d%.%d%d%.txt' ) then
    io.stderr:write( 'ERROR: ' .. input_version .. ' is an unexpected name for the versions file\n' )
    os.exit( 1 )
end

local version_table = {}

-- Open the file with all the local_ variables
local fp = assert( io.open( input_version, 'r' ) )
if fp == nil then os.exit( 1 ) end

-- Process the file: Read the lines and build search expressions from those that start with local_.
for line in fp:lines()
do
    if string.find( line, '^local_[%a%d_]+%s*=' ) then
        local varname = string.sub( line, string.find( line, '^local_[%a%d_]+%S' ) )
        table.insert( version_table, { ['pattern'] = varname .. '%s+=%C*', ['repl'] = line} )
    end
end

-- Close the version file
fp:close()

-- Debug info:
-- for i, repl_pattern in ipairs( version_table ) do print( 'pattern ' .. repl_pattern.pattern .. ',  replacement: ' .. repl_pattern.repl ) end

for i, file in ipairs( args )
do

    print( '\nprocessing ' .. file )

    -- Check if the filename has the extension .eb before processing!
    if string.find( file, '%.eb$' ) then

        -- Read the EB file.
        local fp = assert( io.open( file, 'r' ) )
        if fp == nil then os.exit( 1 ) end
        local ebfile = fp:read( '*all' )
        fp:close()

        -- Do all replacements
        for i, repl_pattern in ipairs( version_table ) 
        do 
            ebfile = ebfile:gsub( repl_pattern.pattern, repl_pattern.repl )
        end

        -- os.rename( file, file .. '.orig' )
        local fp = assert( io.open( file, 'w' ) )
        if fp == nil then os.exit( 1 ) end
        fp:write( ebfile )
        fp:close()

    else

        print( file .. ' is not recognized as an EasyConfig file (no extension .eb), skipping...' )
        
    end


end
