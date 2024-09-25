---@meta

---@class Element
local Element = {}

---@type Element the root element
root = {}

---@type Element the root element for the current resource
resourceRoot = {}

-- THE FOLLOWING GLOBALS ARE ONLY AVAILABLE INSIDE AN addEventHandler callback FUNCTION

---@type string the name of the event that triggered this callback, eg. onClientRender
eventName = ""

---@type Element the element that triggered this event, eg. a Player, Vehicle, Marker. etc...
source = {}

---@type Element the element you attached this listener to, eg. root, resourceRoot, a Marker, a Vehicle. etc...
this = {}

---@alias ClientEvents
---| "onClientRender" # triggers on every screen update, aka: frame
---| "onClientResourceStart" # triggers when the resource is turned on the client side

---@alias ServerEvents
---| "onResourceStart" # triggers when the resource is turned on the server side

---@param eventName (ClientEvents | ServerEvents)
---@param target Element # the element the event will be listening on
---@param callback function
---@param propagate? boolean # can this handler be trigger by others elements down or up the tree, or only by the specified target. default: true
---@param priority? ("high" | "normal" | "low" | string) # the lower priority, the last it will run. default: normal
---@return boolean # true if was attached successfully. false if event could not be found or any parameters were invalid.
function addEventHandler(eventName, target, callback, propagate, priority) end

---@class Material
local Material = {}

---@class Texture : Material
local Texture = {}

---@class DxScreenSource : Element, Texture
local DxScreenSource = {}

-- see the params as the quality of the screen and not a section of the screen.
---@param width integer
---@param height integer
---@return (DxScreenSource | false) # the screenSource or false if arguments were invalids.
function dxCreateScreenSource(width, height) end

---@param screenSource DxScreenSource the screen source you want to update
---@param resampleNow? boolean force immediately screen capture. default: false
---@return boolean # true if screen was captured, false otherwise
function dxUpdateScreenSource(screenSource, resampleNow) end

---@class Shader : Element, Material
local Shader = {}

---@param pathORdata string the path for a HLSL shader file (.fx) or the data buffer of the shader file
---@param priority? number if more than one shader is transforming the same world texture the one with highest priority will be used, if duplicates the most recent one will be used.
---@param maxDistance? number If non-zero, the shader will be applied to textures nearer than maxDistance only.
---@param layered? boolean When set to true, the shader will be drawn in a separate render pass. Several layered shaders can be drawn on the same world texture.
---@param elementTypes? string A comma seperated list of element types to restrict this shader to. Valid: "world,ped,vehicle,object,other,all"
---@return (Shader|false), string
function dxCreateShader(pathORdata, priority, maxDistance, layered, elementTypes) end

--- > Important Note: It's enough to set the texture only once if it's a render target
---@param theShader Shader the shader element whose parameter is to be changed.
---@param parameterName string
---@param ... (Texture|boolean|number) the value to set, when using list of numbers, 16 is the maximum length.
---@return boolean didChange
function dxSetShaderValue(theShader, parameterName, ...) end

---@param red integer the amount of red in the color (0-255)
---@param green integer the amount of green in the color (0-255)
---@param blue integer the amount of blue in the color (0-255)
---@param alpha integer the amount of alpha/lack of transparency in the color (0-255)
---@return integer color
function tocolor(red, green, blue, alpha) end

-- > Important Note: Do not draw image from path. Use a texture created with dxCreateTexture instead to efficiently draw image.
-- > Important Note: For further optimising your DX code, see dxCreateRenderTarget. You should use render target whenever possible, in order to dramatically reduce CPU usage caused by many dxDraw* calls.
-- > Tip: To help prevent edge artifacts when drawing textures, set textureEdge to "clamp" when calling dxCreateTexture.
---@param x number the absolute x position
---@param y number absolute y
---@param width number
---@param height number
---@param image (Material|string) a material or a path to an image file such as: png, jpg, dds.
---@param rotation? number in degrees
---@param pivotX? number the absolute X offset from the image center for which to rotate the image from.
---@param pivotY? number Y offset
---@param color? integer tints the image with the color represented by 0xAARRGGBB. see: [tocolor](lua://tocolor)
---@param postGUI? boolean whether the image should be drawn on top of or behind any ingame GUI
---@return boolean success indicating if the operation was successfull.
function dxDrawImage(x, y, width, height, image, rotation, pivotX, pivotY, color, postGUI) end
