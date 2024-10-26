-- Enhanced Vulnerability Scanner GUI Script for Synapse X

-- Create the ScreenGui
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ScanButton = Instance.new("TextButton")
local OutputLabel = Instance.new("TextLabel")
local ScanHistoryLabel = Instance.new("TextLabel")
local NotificationLabel = Instance.new("TextLabel")
local CopyButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")

-- Properties for GUI elements
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Size = UDim2.new(0.25, 0, 0.4, 0) -- Adjusted size to make it smaller
Frame.Position = UDim2.new(0.375, 0, 0.325, 0) -- Centered position
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(255, 0, 255) -- Rainbow Border

-- Title Label
TitleLabel.Parent = Frame
TitleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.Size = UDim2.new(1, 0, 0.15, 0)
TitleLabel.Text = "Self Hub Vulnerability Scanner"
TitleLabel.TextColor3 = Color3.fromRGB(255, 0, 255) -- Rainbow color for title
TitleLabel.TextScaled = true
TitleLabel.BorderSizePixel = 0

-- Scan Button
ScanButton.Parent = Frame
ScanButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128) -- Grey
ScanButton.Size = UDim2.new(0.5, 0, 0.15, 0)
ScanButton.Position = UDim2.new(0.25, 0, 0.2, 0)
ScanButton.Text = "Scan for Vulnerabilities"
ScanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanButton.TextScaled = true

-- Output Label
OutputLabel.Parent = Frame
OutputLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OutputLabel.Size = UDim2.new(1, 0, 0.25, 0)
OutputLabel.Position = UDim2.new(0, 0, 0.35, 0)
OutputLabel.Text = "Output will appear here."
OutputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
OutputLabel.TextWrapped = true
OutputLabel.TextScaled = true

-- Scan History Label
ScanHistoryLabel.Parent = Frame
ScanHistoryLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ScanHistoryLabel.Size = UDim2.new(1, 0, 0.1, 0)
ScanHistoryLabel.Position = UDim2.new(0, 0, 0.6, 0)
ScanHistoryLabel.Text = "Scan History: "
ScanHistoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanHistoryLabel.TextWrapped = true
ScanHistoryLabel.TextScaled = true

-- Notification Label
NotificationLabel.Parent = Frame
NotificationLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
NotificationLabel.Size = UDim2.new(1, 0, 0.1, 0)
NotificationLabel.Position = UDim2.new(0, 0, 0.7, 0)
NotificationLabel.Text = ""
NotificationLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red for notifications
NotificationLabel.TextScaled = true
NotificationLabel.TextWrapped = true

-- Copy Button
CopyButton.Parent = Frame
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green
CopyButton.Size = UDim2.new(0.5, 0, 0.15, 0)
CopyButton.Position = UDim2.new(0.25, 0, 0.8, 0)
CopyButton.Text = "Copy Results"
CopyButton.TextColor3 = Color3.fromRGB(0, 0, 0)
CopyButton.TextScaled = true

-- Close Button
CloseButton.Parent = Frame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Size = UDim2.new(0.08, 0, 0.08, 0) -- Made smaller
CloseButton.Position = UDim2.new(0.92, 0, 0, 0) -- Adjusted position
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true

-- Smooth GUI Dragging Function
local dragging = false
local dragStart = Vector2.new()
local startPos = UDim2.new()

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Close Button Functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Copy Results to Clipboard Functionality
local function copyToClipboard(text)
    setclipboard(text)
end

-- Enhanced Vulnerability Scanner Function
local function scanForVulnerabilities()
    OutputLabel.Text = "Scanning for vulnerabilities...\n"
    NotificationLabel.Text = "Scan in progress..."

    -- Clear previous output
    OutputLabel.Text = "Output will appear here."

    -- Scan history
    local scanHistory = ""
    local foundVulnerabilities = ""
    
    -- Check for unsecured RemoteEvents and RemoteFunctions
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            foundVulnerabilities = foundVulnerabilities .. "Unsecured: " .. obj:GetFullName() .. "\n"
        end
    end

    -- Check for unused services
    local services = game:GetService("ReplicatedStorage"):GetChildren()
    for _, service in pairs(services) do
        if not service:IsA("RemoteEvent") and not service:IsA("RemoteFunction") and not service:IsA("ModuleScript") then
            foundVulnerabilities = foundVulnerabilities .. "Unused Service: " .. service:GetFullName() .. "\n"
        end
    end

    -- Check for unsecured Proximity Prompts and Screen GUIs
    for _, gui in pairs(game:GetDescendants()) do
        if gui:IsA("ProximityPrompt") and not gui.RequiresLineOfSight then
            foundVulnerabilities = foundVulnerabilities .. "Unsecured Proximity Prompt: " .. gui:GetFullName() .. "\n"
        elseif gui:IsA("ScreenGui") and gui.Enabled then
            foundVulnerabilities = foundVulnerabilities .. "Enabled Screen GUI: " .. gui:GetFullName() .. "\n"
        end
    end

    -- Check for exploitable properties
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Part") and not obj.CanCollide then
            foundVulnerabilities = foundVulnerabilities .. "Exploitable Part: " .. obj:GetFullName() .. " (CanCollide is false)\n"
        elseif obj:IsA("Model") and not obj.Archivable then
            foundVulnerabilities = foundVulnerabilities .. "Non-archivable Model: " .. obj:GetFullName() .. "\n"
        end
    end

    -- Display results
    if foundVulnerabilities == "" then
        OutputLabel.Text = "No vulnerabilities found."
        NotificationLabel.Text = "Scan completed."
    else
        OutputLabel.Text = foundVulnerabilities
        NotificationLabel.Text = "Scan completed with vulnerabilities found!"
    end

    -- Update scan history
    scanHistory = scanHistory .. os.date("%Y-%m-%d %H:%M:%S") .. ": Scan completed.\n"
    ScanHistoryLabel.Text = "Scan History: " .. scanHistory
end

ScanButton.MouseButton1Click:Connect(scanForVulnerabilities)
CopyButton.MouseButton1Click:Connect(function()
    copyToClipboard(OutputLabel.Text)
end)
