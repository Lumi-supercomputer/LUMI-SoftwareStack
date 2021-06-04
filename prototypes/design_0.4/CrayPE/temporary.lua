cpe_file = '/users/klust/appltest/design_0.4/modules/../SystemRepo/CrayPE/21.04.csv'
package = 'craype-targets'
module_file_name = '/users/klust/appltest/design_0.4/modules/SystemPartition/LUMI/21.04/partition/L.lua'
CPE_version = '21.04'

install_root = module_file_name:match( '(.*)/modules/.*' )


function get_CPE_component( module_file_name, package, CPE_version )

    -- Limitation of this implementation: If the path would contain
    -- multiple times /modules/, this will stop at the first occurence
    -- as this is likely the most relevant.
    local install_root = module_file_name:match( '(.-)/modules/.*' )

    local fp = io.open( cpe_file, 'r' )
    if fp == nil then
        return nil;
    end
    local fc = fp:read('*a')
    fp:close()

    -- Omit the first line which is the title line
    -- fc:gsub('[^\n]+\n', '', 1)

    search_string = package:gsub(  '%-', '%%-' )
    start, finish = fc:find( search_string .. '%s*,[^%c]*' )
    line = fc:sub( start, finish )
    if start ~= nil then
        local package_version = fc:sub( start, finish ):gsub( '%s', ''):gsub( search_string .. ',', '')
        return package_version
    else
        return nil
    end
end




fp = io.open('/etc/cray-pe.d/cray-pe-configuration.sh', 'r')
fc = fp:read('*a')
fp:close()
start, finish = string.find(fc, 'module_list=%b\"\"')
definition = string.sub(fc, start, finish)
start,finish = string.find(definition, '%b\"\"')
list = string.sub(definition, start + 1, finish - 1)
list = list:gsub("\\","")
for module in string.gmatch(list, "%S+") do
    print(module)
end
