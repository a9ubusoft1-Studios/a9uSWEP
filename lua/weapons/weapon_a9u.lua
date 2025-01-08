--MADE BY KNUCKLES COMBINE
--FIXED BY A9UBUSOFT1REAL
--        _____       _                      __ _   __                 _ 
--       |  _  |     | |                    / _| | /  |               | |
--  __ _ | |_| |_   _| |__  _   _ ___  ___ | |_| |_`| | _ __ ___  __ _| |
-- / _` |\____ | | | | '_ \| | | / __|/ _ \|  _| __|| || '__/ _ \/ _` | |
--| (_| |.___/ / |_| | |_) | |_| \__ \ (_) | | | |__| || | |  __/ (_| | |
-- \__,_|\____/ \__,_|_.__/ \__,_|___/\___/|_|  \__\___/_|  \___|\__,_|_|2025

SWEP.PrintName = "a9ubusoft1real SMG"
SWEP.Author = "Knuckles Combine and a9ubusoft1real"
SWEP.Purpose = "Shoot and open Screen in full-screen."
SWEP.Category = "Knuckles and a9u SWEPS"

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Spawnable = true

SWEP.ViewModel = Model("models/weapons/c_smg1.mdl")
SWEP.WorldModel = Model("models/weapons/w_smg1.mdl")
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

local ShootSound = Sound("Weapon_SMG1.Single")
local CanShoot = true
local NextShootTime = 0

if SERVER then
    util.AddNetworkString("OpenFullScreen11")
end

function SWEP:Initialize()
    self:SetHoldType("smg")
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
    if not CanShoot or CurTime() < NextShootTime then return end

    self:SetNextPrimaryFire(CurTime() + 0.1)

    self:EmitSound(ShootSound)
    self:ShootEffects()

    if (CLIENT) then return end

    NextShootTime = CurTime() + 0.1

    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    net.Start("OpenFullScreen11")
    net.Send(ply)
end

function SWEP:SecondaryAttack()
end

function SWEP:ShouldDropOnDie()
    return false
end

function SWEP:GetNPCRestTimes()
    return 0.3, 0.6
end

function SWEP:GetNPCBurstSettings()
    return 1, 6, 0.1
end

function SWEP:GetNPCBulletSpread(proficiency)
    return 1
end

if CLIENT then
    net.Receive("OpenFullScreen11", function()
        CanShoot = false

        local screenWidth, screenHeight = ScrW(), ScrH()
        local frame = vgui.Create("DFrame")
        frame:SetTitle("")
        frame:SetSize(screenWidth, screenHeight)
        frame:SetPos(0, 0)
        frame:SetDraggable(false)
        frame:ShowCloseButton(true)
        frame:MakePopup()
        frame.Paint = function(self, w, h)
            surface.SetDrawColor(0, 0, 0, 240)
            surface.DrawRect(0, 0, w, h)
        end

        local html = vgui.Create("DHTML", frame)
        html:Dock(FILL)
        html:OpenURL("https://steamuserimages-a.akamaihd.net/ugc/27683556138532191/CEA4133830A784310353DC7CC53B96BB3FDED3E7/")

        frame.OnClose = function()
            CanShoot = true
        end
    end)

    hook.Add("Think", "CheckMouseHold", function()
        if input.IsMouseDown(MOUSE_LEFT) and CanShoot then
            CanShoot = false
        elseif not input.IsMouseDown(MOUSE_LEFT) and not CanShoot then
            CanShoot = true
        end
    end)
end
