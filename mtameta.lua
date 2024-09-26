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
---| "onClientResourceStop" triggers when the resource is turned off client side

---@alias ServerEvents
---| "onResourceStart" # triggers when the resource is turned on the server side
---| "onResourceStop" # triggers when the resource is turned off server side

---@param eventName (ClientEvents | ServerEvents | string)
---@param target Element # the element the event will be listening on
---@param callback function
---@param propagate? boolean # can this handler be trigger by others elements down or up the tree, or only by the specified target. default: true
---@param priority? ("high" | "normal" | "low" | string) # the lower priority, the last it will run. default: normal
---@return boolean # true if was attached successfully. false if event could not be found or any parameters were invalid.
function addEventHandler(eventName, target, callback, propagate, priority) end

-- >> Shared Function
-- This functions removes a handler function from an event, so that the function is not called anymore when the event is triggered. See event system for more information on how the event system works.
---@param eventName ClientEvents|ServerEvents|string
---@param target Element
---@param callback function
---@return boolean # Returns true if the event handler was removed successfully. Returns false if the specified event handler could not be found or invalid parameters were passed.
function removeEventHandler(eventName, target, callback) end

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
---@param ... (Material|boolean|number) the value to set, when using list of numbers, 16 is the maximum length.
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

-- This function gets the dimensions of pixels contained in a string. It works with all pixel formats.
---@param pixels string pixels to get the dimensions of, f.e: the data you got using fileRead from an image file
---@return integer width, integer height
function dxGetPixelsSize(pixels) end

---@alias fonts ("default"|"default-bold"|"clear"|"arial"|"sans"|"pricedown"|"bankgothic"|"diploma"|"beckett"|"unifont")

---@class Vec2
local Vec2 = {}

---@class DxFont : Element
local DxFont = {}

---@alias font_quality "default"|"draft"|"proof"|"nonantialiased"|"antialiased"|"cleartype"|"cleartype_natural"

-- >> Client Function
-- > Note: The size can't be less than 5 or more than 150. Use this function after onClientResourceStart, otherwise some characters may be displayed incorrectly.
-- This function creates a DX font element that can be used in dxDrawText. Successful font creation is not guaranteed, and may fail due to hardware or memory limitations.
-- To see if creation is likely to fail, use dxGetStatus. (When VideoMemoryFreeForMTA is zero, failure is guaranteed.)
-- It is highly recommended that dxSetTestMode is used when writing and testing scripts using dxCreateFont.
---@param path string the path for a ttf font.
---@param size? integer size of the font
---@param bold? boolean if the font should be bold
---@param quality? font_quality the font quality
---@return DxFont|false # false if invalid arguments were passed to the function, or there is insufficient resources available.
function dxCreateFont(path, size, bold, quality) end

-- This function retrieves the theoretical width and height (in pixels) of a certain piece of text, if it were to be drawn using dxDrawText.
-- NOTE This function already takes the client's screen resolution into account.
---@param text string
---@param width? number The width of the text. Use with wordBreak = true.
---@param scaleXY? (number|Vec2) The scale of the text.
---@param font? (DxFont|fonts)
---@param wordBreak? boolean If set to true, the text will wrap to a new line whenever it reaches the right side of the bounding box. If false, the text will always be completely on one line.
---@param colorCoded? boolean Should we exclude color codes from the width? False will include the hex in the length.
---@return number width, number height
function dxGetTextSize(text, width, scaleXY, font, wordBreak, colorCoded) end
-- TODO: add the scaleX and scaleY variation.

---@class DxRenderTarget : Element, Material

-- This function creates a render target element, which is a special type of texture that can be drawn on with the dx functions. Successful render target creation is not guaranteed, and may fail due to hardware or memory limitations.
-- To see if creation is likely to fail, use dxGetStatus. (When VideoMemoryFreeForMTA is zero, failure is guaranteed.)
---@param width integer
---@param height integer
---@param withAlpha? boolean false; 'false' will turn image's alpha channels to black color
---@return DxRenderTarget | false # false if the system is unable to create a render target.
function dxCreateRenderTarget(width, height, withAlpha) end

-- This function retrieves the local screen size according to the resolution they are using.
---@return number width, number height
function guiGetScreenSize() end

---@class File
local File = {}

-- > Note: To prevent memory leaks, ensure each successful call to fileOpen has a matching call to fileClose.
-- > Tip: The file functions should not be used to implement configuration files. It is encouraged to use the XML functions for this instead.
---@param path string cross resource file opening can be done using ":resourceName/path"
---@param readOnly? boolean false; specify true for this parameter if you only need reading access
---@return (File|false) # returns false (f.e. if the file doesn't exist).
function fileOpen(path, readOnly) end

-- Closes a file handle obtained by fileCreate or fileOpen.
---@param file File file handle to close.
---@return boolean didClose
function fileClose(file) end

-- Reads the specified number of bytes from the given file starting at its current read/write position, and returns them as a string.
---@param file File file you wish to read from. Use fileOpen to obtain this handle.
---@param size integer number of bytes you wish to read.
---@return string # Returns the bytes that were read in a string. Note that this string might not contain as many bytes as you specified if an error occured, i.e. end of file.
function fileRead(file, size) end

-- Returns the total size in bytes of the given file.
---@param file File the file handle you wish to get the size of.
---@return (integer|false) # false if an error occured (e.g. an invalid file handle was passed).
function fileGetSize(file) end

-- > Important Note: The value returned by this function client-side may not be reliable if a client is maliciously modifying their operating system speed.
-- This function returns amount of time that your system has been running in milliseconds. By comparing two values of getTickCount, you can determine how much time has passed (in milliseconds) between two events. This could be used to determine how efficient your code is, or to time how long a player takes to complete a task.
---@return integer # containing the number of milliseconds since the system the server is running on started. This has the potential to wrap-around.
function getTickCount() end

-- This function gets the current position of the mouse cursor. Note that for performance reasons, the world position returned is always 300 units away. If you want the exact world point (similar to onClientClick), use processLineOfSight between the camera position and the worldX/Y/Z result of this function. (See example below)
---@return (number|false) sx, number sy, number wx, number wy, number wz Returns 5 values: cursorX, cursorY, worldX, worldY, worldZ. The first two values are the 2D relative screen coordinates of the cursor. The 3 values that follow are the 3D world map coordinates that the cursor points at. If the cursor isn't showing, returns false as the first value.
function getCursorPosition() end

---@class Sound : Element

-- Creates a sound element and plays it immediately after creation for the local player.
-- > supported audio formats are MP3, WAV, OGG, FLAC, RIFF, MOD, WEBM, XM, IT, S3M and PLS.
-- > For performance reasons, when using playSound for effects that will be played lots (i.e. weapon fire), it is recommend that you convert your audio file to a one channel (mono) WAV with sample rate of 22050 Hz or less. Also consider adding a limit on how often the effect can be played e.g. once every 50ms.
---@param path string or URL (http://, https:// or ftp://) of the sound file you want to play.
---@param looped? boolean false; whether the sound will be looped. streams can't be looped for obvious reason.
---@param throttled? boolean true; the sound will be throttled (i.e. given reduced download bandwidth). To throttle the sound, use true. Sounds will be throttled per default and only for URLs.
---@return Sound|false
function playSound(path, looped, throttled) end

---@class Player : Element

-- >> Server Function; client also available without player parameter.
-- This function is used to show or hide a player's cursor.
-- > Note: Be aware of that if showCursor enbaled by a resource you can't disabled it from a different ressource showCursor(false) will not works, in order to make it works, disable it from the original resource that enabled it or use export
---@param player Player
---@param show boolean
---@param toggleControls? boolean true; whether to disable controls whilst the cursor is showing. true implies controls are disabled, false implies controls remain enabled.
---@return boolean
function showCursor(player, show, toggleControls) end

-- >> Client Function; server also available with player parameter.
-- This function is used to show or hide a player's cursor.
-- > Note: Be aware of that if showCursor enbaled by a resource you can't disabled it from a different ressource showCursor(false) will not works, in order to make it works, disable it from the original resource that enabled it or use export
---@param show boolean
---@param toggleControls? boolean true; whether to disable controls whilst the cursor is showing. true implies controls are disabled, false implies controls remain enabled.
---@return boolean
function showCursor(show, toggleControls) end

-- >> Client Function
-- This function sets the current position of the mouse cursor.
---@param x integer x absolute position
---@param y integer y absolute position
---@return boolean
function setCursorPosition(x, y) end
