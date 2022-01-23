local repl = game.ReplicatedStorage
local ls = game.Players.LocalPlayer.leaderstats
local re = game.ReplicatedStorage.Remotes.ClientRemote

local scr = {}
for i,v in next,repl.Modules:GetChildren() do
    scr[v.Name] = require(v)
end

local mods = {}
for i,v in next,scr do
    local tbl = {}
    for i,v in next,v do
        tbl[i] = v
    end; table.sort(tbl, function(v,e)
        return v.Cost > e.Cost
    end); mods[i] = tbl
end

function get(k,r,f,c)
    local l,x
    for i,v in next,mods[k] do
        l = (not f and (not l and v)) or ((not f or v[c] <= f) and (not l or v[r] > l[r]) and v) or l
        x = (l == v and i) or x
    end; return table.find(scr[k],l)
end

local ui = loadstring(game:HttpGet('https://raw.githubusercontent.com/loglizzy/Elerium-lib/main/lib.min.lua'))()
local win,flag = ui:AddWindow('8====D anime cum'),{}

local features = {
    farm = {
        {
            'auto energy','energy',
            function()
                while flag.energy do
                    re:InvokeServer('Tapping')
                    task.wait()
                end
            end
        },
        {
            'auto rebirth','rebirth',
            function()
                local e = ls.Energy
                while flag.rebirth do
                    re:InvokeServer('Rebirths',get('Rebirths','Amount',e.Value,'Cost'))
                    task.wait()
                end
            end,
        },
        {
            'auto practice','practice',
            function(v)
                print(v)
            end
        }
    }
}

local first
for i,r in next,features do
    local p = win:AddTab(i)
    first = first or p
    for _,v in next, r do
        p:AddSwitch(v[1],function(f)
            flag[v[2]] = f; v[3](f)
        end)
    end
end; first:Show()
