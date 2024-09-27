# Auto Completions
The file `mta.d.lua` holds the most of the definitions for the MTA runtime library, to get the `luals` auto completion working: download the file, on the luals settings add the path of the definitions file to the `workspace.library` option.

# Tooling
table to alias
```lua
local list = {}
local out = "---";
 
for i, v in ipairs(list) do
   out = out..'| "'..v..'"'
   if i % 4 == 0 then
      out = out..'\n---'
   end
end

print(out)
```