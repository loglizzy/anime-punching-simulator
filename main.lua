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

function get(k,r,f,c)
    local l,x
    for i,v in next,mods[k] do
        l = (not f and (not l and v)) or ((not f or v[c] <= f) and (not l or v[r] > l[r]) and v) or l
        x = (l == v and i) or x
    end; return table.find(scr[k],l)
end

local tr = game.Players.LocalPlayer.PlayerGui.Ui.CenterFrame.Travel.Frame
function has()
    local tbl = {}
    for i,v in next, tr:GetChildren() do
        if not v:FindFirstChild('Purchase') then continue end
        tbl[v.Name] = v.Purchase.Texto.Text == 'Travel'
    end; return tbl
end

local pr
for i,v in next, game.Workspace["__SETTINGS"]["__INTERACT"]:GetChildren() do
    if v.Name == 'Practice' then
        pr = (not pr and v) or ((has()[v.Area.Value] and (v.Boost.Value > pr.Boost.Value)) and v) or pr
    end
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
                    re:InvokeServer('Rebirths',get('Rebirths','Amount',e.Value,'Cost'))
                    task.wait()
                end
            end,
        },
        {
            'auto practice','practice',
            function()
                local e = ls.Gems
                while flag.practice do
                    if nx and e.Value > nx then continue end
                    local r = pl.Character and pl.Character.PrimaryPart
                    r.CFrame = pr.CFrame
                    nx = re:InvokeServer('Practice',pr)*1.05
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
