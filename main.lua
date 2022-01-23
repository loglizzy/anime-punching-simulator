-- main
local repl = game.ReplicatedStorage
local pl = game.Players.LocalPlayer
local ls = pl.leaderstats
local re = game.ReplicatedStorage.Remotes.ClientRemote
local nx

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

function get(k,f,c)
    local l,x
    for i,v in next,mods[k] do
        l = (v[c] <= f and v) or l
        x = (l == v and i) or x
        if l and x then break end
    end; return table.find(scr[k],l) or x
end

local tr = game.Players.LocalPlayer.PlayerGui.Ui.CenterFrame.Travel.Frame
function has()
    local tbl = {}
    for i,v in next, tr:GetChildren() do
        if not v:FindFirstChild('Purchase') then continue end
        tbl[v.Name] = v.Purchase.Texto.Text == 'Travel'
    end; return tbl
end

-- gui
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
                    re:InvokeServer('Rebirths',get('Rebirths',e.Value,'Cost'))
                    task.wait()
                end
            end,
        },
        {
            'auto practice','practice',
            function()
                local e = ls.Gems
                while flag.practice do
                    if nx and e.Value < nx then task.wait() continue end
                    local r = pl.Character and pl.Character.PrimaryPart
                    if not r then task.wait() continue end
                    
                    local pr
                    for i,v in next, game.Workspace["__SETTINGS"]["__INTERACT"]:GetChildren() do
                        if v.Name == 'Practice' then
                            pr = (not pr and v) or ((has()[v.Area.Value] and (v.Boost.Value > pr.Boost.Value)) and v) or pr
                        end
                    end
                    
                    r.CFrame = pr.CFrame
                    nx = (re:InvokeServer('Practice',pr) or 0)*1.05
                    task.wait()
                end
            end
        },
        {
            'auto buy worlds','worlds',
            function()
                local e = ls.Gems
                while flag.worlds do
                    local x = get('Areas',e.Value,'Cost')
                    if not has()[x] then
                        re:InvokeServer('Areas',x)
                    end
                    task.wait()
                end
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
