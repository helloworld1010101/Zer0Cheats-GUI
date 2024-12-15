-- Create a ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "VeryCoolGUI"
gui.Parent = game.Players.LocalPlayer.PlayerGui

-- Create a Frame for the GUI
local frame = Instance.new("Frame")
frame.Name = "ExploitMenuFrame"
frame.Parent = gui
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundTransparency = 0.5

-- Create a Flying Button
local flyingButton = Instance.new("TextButton")
flyingButton.Name = "FlyingButton"
flyingButton.Parent = frame
flyingButton.Text = "Flying"
flyingButton.Size = UDim2.new(0, 100, 0, 50)
flyingButton.Position = UDim2.new(0, 0, 0, 0)
flyingButton.MouseButton1Click:Connect(function()
    -- Create a part to attach the camera to
    local camera = Instance.new("Part")
    camera.Anchored = true
    camera.CanCollide = false

    -- Create a camera and attach it to the part
    local cam = workspace.CurrentCamera
    cam.CameraType = Enum.CameraType.Scriptable
    cam:SetAttribute("IsFlyingCamera", true)
    cam.CFrame = camera.CFrame
    cam.Parent = camera

    -- Set up the flying controls
    local flying = false
    local speed = 50
    local maxSpeed = 500
    local acceleration = 50

    local function updateFlying(player)
        if flying then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true
            end
            player.Character.Humanoid.WalkSpeed = speed
        else
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            player.Character.Humanoid.WalkSpeed = 16
        end
    }

    local function onKeyDown(player, input)
        if input.KeyCode == Enum.KeyCode.W then
            speed = math.min(speed + acceleration, maxSpeed)
        elseif input.KeyCode == Enum.KeyCode.S then
            speed = math.max(speed - acceleration, -maxSpeed)
        elseif input.KeyCode == Enum.KeyCode.A then
            camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(acceleration), 0)
        elseif input.KeyCode == Enum.KeyCode.D then
            camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(-acceleration), 0)
        end
        updateFlying(player)
    end

    local function onKeyUp(player, input)
        if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S then
            speed = 0
        elseif input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
            camera.CFrame = camera.CFrame * CFrame.Angles(0, 0, 0)
        end
        updateFlying(player)
    end

    -- Connect the input events
    game.Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            camera.Parent = character
            updateFlying(player)
        end)
    end)

    game.Players.PlayerRemoving:Connect(function(player)
        flying = false
        updateFlying(player)
    end)

    game:GetService("UserInputService").InputBegan:Connect(onKeyDown)
    game:GetService