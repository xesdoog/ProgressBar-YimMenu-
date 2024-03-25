---@diagnostic disable: undefined-global, lowercase-global
local test_tab = gui.get_tab("Test Stuff")
--//main
local x = 0
local counter = 0
function progressBar()
    x = x + 0.01 -- adjusting this float adjusts the speed at which the progress bar reaches the max (higher = faster). values are between 0 and 1.
    if x > 1 then
        x = 1
        progessMessage = "Done!" -- just a simple message that changes depending on the progress--
    else
        progessMessage = "Loading..." ------------------------------------------------------------
    end
end
function displayProgressBar()
    ImGui.Text(progessMessage) -- we can either display the message above the progress bar or inside it. in this example it is above it.
    progressBar() -- we execute the function that calculates x and changes the message.
    ImGui.ProgressBar(x, 250, 25) -- here we have several choices: index 1 is always x, idex 2 is the width of the bar, index 3 is the height. this function can take 2 more parameters: the text that I chose to display above it can actually go here at index 4 and we can get rid of ImGui.Text(). the value of x can be displayed here too by adding it after the text (..x) if you choose not to use x here, the progressBar function will automatically display 0% to 100% synced with the progress.
end
-- //usage example: //here I'm using it inside a modal but maybe we can display it in some other custom window?
test_tab:add_imgui(function()
    if ImGui.Button("Load Something") then
        ImGui.OpenPopup("##Progress Bar")
    end
    ImGui.SetNextWindowBgAlpha(0)
    if ImGui.BeginPopupModal("##Progress Bar", ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoScrollbar | ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoScrollWithMouse | ImGuiWindowFlags.AlwaysAutoResize) then
            displayProgressBar()
            counter = counter + 1
            if x == 1 then
                if counter > 150 then -- used as sort of a timer to automatically close the ImGui popup. if you maka a progressBar that loads fast, use a lower number.
                    ImGui.CloseCurrentPopup()
                    counter = 0 -- reset the counter otherwise the popup will display for one frame then close immediately.
                    x = 0 -- reset x otherwise pessing the button again will just display a full bar that does nothing.
                else return
                end
            end
        ImGui.EndPopup()
    end
end)
