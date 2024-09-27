---@meta

---@class Element
---@class RootElement : Element
---@class ResourceRootElement : Element

---@type RootElement the root element
root = {}

---@type ResourceRootElement the root element for the current resource
resourceRoot = {}

---@type Player player element of the client running the current script.
localPlayer = {}

-- THE FOLLOWING GLOBALS ARE ONLY AVAILABLE INSIDE AN addEventHandler callback FUNCTION

---@type string the name of the event that triggered this callback, eg. onClientRender
eventName = ""

---@type Element the element that triggered this event.
source = {}

---@type Element the element this listener is attached to.
this = {}

-- 💻 Client and 🖥 Server Function
---
-- This function allows you to register a custom event. Custom events function exactly like the built-in events. See event system for more information on the event system.
---@param name string
---@param allowRemote? boolean false; whether this event can be called remotely using [triggerClientEvent](lua://triggerClientEvent) / [triggerServerEvent](lua://triggerServerEvent) or not.
---@return boolean success true if the event was added successfully, false if the event was already added.
function addEvent(name, allowRemote) end

-- 💻 Client Function
---
-- This function triggers an event previously registered on the server. This is the primary means of passing information between the client and the server. Servers have a similar triggerClientEvent function that can do the reverse. You can treat this function as if it was an asynchronous function call, using triggerClientEvent to pass back any returned information if necessary.
---
-- Almost any data types can be passed as expected, including elements and complex nested tables. Non-element MTA data types like xmlNodes or resource pointers will not be able to be passed as they do not necessarily have a valid representation on the client. Elements of the Vector or Matrix classes cannot be passed!
---
-- Events are sent reliably, so the server will receive them, but there may be (but shouldn't be) a significant delay before they are received. You should take this into account when using them.
---
-- Keep in mind the bandwidth issues when using events - don't pass a large list of arguments unless you really need to. It is marginally more efficient to pass one large event than two smaller ones.
---
-- **_IMPORTANT:_** You should use the global variable client server-side instead of passing the localPlayer by parameter or source. Otherwise event faking (passing another player instead of the localPlayer) would be possible. For more information see: Script security article.
---
-- **_SAVE SERVER CPU:_** To save server CPU, you should avoid setting source to the root element where possible - it should be used as a last resort (rather questionable thing to do, limited to very specific tasks, if any). Using localPlayer is preferred and highly advisable. resourceRoot can also be used as alternative choice, if addEventHandler is bound to root element, or to resourceRoot when there is need to restrict event to single certain resource (although cheater could still trigger it from different resource, by using getResourceRootElement and passing respective resource root element)
---@param event string
---@param source Element
---@param ... Element | string | number | table
---@return boolean success false if a client side element was a parameter.
function triggerServerEvent(event, source, ...) end

---@alias ClientEvents
---| "onClientRender" # triggers on every screen update, aka: frame
---| "onClientResourceStart" # triggers when the resource is turned on the client side
---| "onClientResourceStop" triggers when the resource is turned off client side

---@alias ServerEvents
---| "onResourceStart" # triggers when the resource is turned on the server side
---| "onResourceStop" # triggers when the resource is turned off server side

-- 💻 Client and 🖥 Server Function
---
---@param eventName (ClientEvents | ServerEvents | string)
---@param target Element the element the event will be listening on.
---@param callback function
---@param propagate? boolean true; can this handler be trigger by others elements down or up the tree, or only by the specified target.
---@param priority? "high" | "normal" | "low" | string normal; the lower priority, the last it will run.
---@return boolean success false if event could not be found or any parameters were invalid.
function addEventHandler(eventName, target, callback, propagate, priority) end

-- 🖥 Server Event
---
-- **_CANCELLING:_** the player will not be logged in.
---
-- **_SOURCE:_** the [Player](lua://Player) element that just logged in.
---@param event "onPlayerLogin"
---@param target RootElement | Player
---@param callback fun(previous: Account, current: Account)
function addEventHandler(event, target, callback) end

---@alias quit_types
---| "Unknown"
---| "Quit"
---| "Kicked"
---| "Banned"
---| "Bad Connection"
---| "Timed out"

-- 🖥 Server Event
---
-- **_CANCELLING:_** This event cannot be cancelled.
---
---**_SOURCE:_** the [Player](lua://Player) that left the server.
---@param event "onPlayerQuit"
---@param target RootElement | Player
---@param callback fun(type: quit_types, reason: string | false, responsable: Player | Console)
function addEventHandler(event, target, callback) end

---@class Object : Element

---@alias body_parts
---| 3 Torso
---| 4 Ass
---| 5 Left Arm
---| 6 Right Arm
---| 7 Left Leg
---| 8 Right Leg
---| 9 Head

---@alias damage_types
---| 19 Rocket
---| 37 Burnt, used by a damage by fire, even when the fire is created by a rocket explosion or a molotov.
---| 49 Rammed
---| 50 Ranover, also called when damaged because of helicopter blades.
---| 51 Explosion, may sometimes also be used at an indirect damage through an exploding rocket.
---| 52 Driveby, NOT used for a driveby kill with e.g. the 'realdriveby' resource.
---| 53 Drowned
---| 54 Fall
---| 55 Unknown
---| 56 Melee, seems to be never called (?); for an actual melee damage, the fist weapon ID (0) is used.
---| 57 Weapon, seems to be never called (?)
---| 59 Tank Grenade
---| 63 Blown, when dying in a vehicle explosion.

---@alias weapons
---| 0 Fist
---| 1 Brassnuckle
---| 2 Golfclub
---| 3 Nightstick
---| 4 Knife
---| 5 Bat
---| 6 Shovel
---| 7 Poolstick
---| 8 Katana
---| 9 Chainsaw
---| 22 Colt 45
---| 23 Silenced
---| 24 Deagle
---| 25 Shotgun
---| 26 Sawed-off
---| 27 Combat Shotgun
---| 28 Uzi
---| 29 MP5
---| 32 Tec-9
---| 30 AK
---| 31 M4
---| 33 Rifle
---| 34 Sniper
---| 35 Rocket Launcher
---| 36 Rocket Launcher HS
---| 37 Flamethrower
---| 38 Minigun
---| 16 Grenade
---| 17 Teargas
---| 18 Molotov
---| 39 Satchel
---| 41 Spraycan
---| 42 Fire Extinguisher
---| 43 Camera
---| 10 Thin Dildo
---| 11 Thick Dildo
---| 12 Vibrator
---| 14 Flower
---| 15 Cane
---| 44 Nightvision
---| 45 Infrared
---| 46 Parachute
---| 40 Satchel Detonator (Bomb)

-- 🖥 Server Event
---
-- This event is triggered when a player is killed or dies.
---
-- **_CANCELLING:_** non cancellable; no explicit state by the wiki; untested.
---
---**_SOURCE:_** the [Player](lua://Player) that died or got killed.
---@param event "onPlayerWasted"
---@param target RootElement | Player
---@param callback fun(ammo: integer, killer: Player | Ped | Vehicle | Object | false, weapon: weapons | damage_types, bodypart: body_parts, stealth: boolean, animGroup: integer, animID: integer)
function addEventHandler(event, target, callback) end

---@class Resource

-- 🖥 Server Event
---
-- This event is triggered when a resource is started.
---
-- **_CANCELLING:_** the resource starting is aborted and is stopped again.
---
---**_SOURCE:_** the [resource root element](lua://ResourceRootElement) in the resource that started.
---@param event "onResourceStart"
---@param target RootElement | ResourceRootElement
---@param callback fun(resource: Resource)
function addEventHandler(event, target, callback) end

-- 💻 Client and 🖥 Server Function
---
-- This functions removes a handler function from an event, so that the function is not called anymore when the event is triggered. See event system for more information on how the event system works.
---@param eventName ClientEvents | ServerEvents | string
---@param target Element
---@param callback function
---@return boolean success false if the specified event handler could not be found or invalid parameters were passed.
function removeEventHandler(eventName, target, callback) end

---@class Material

---@class DxScreenSource : Element, Texture

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

---@class Texture : Material

---@alias texture_formats
---| "argb" ARGB uncompressed 32 bit color (default).
---| "dxt1" Can take a fraction of a second longer to load, Uses 8 times less video memory than ARGB and can speed up drawing. Quality not as good as ARGB. It supports alpha blending, but it can only be on or off, that is: either 0 or 255.
---| "dxt3" Can take a fraction of a second longer to load (unless the file is already a DXT3 .dds). Uses 4 times less video memory than ARGB and can speed up drawing. Quality slightly better than DXT1 and supports crisp alpha blending.
---| "dxt5" Can take a fraction of a second longer to load (unless the file is already a DXT5 .dds). Uses 4 times less video memory than ARGB and can speed up drawing. Quality slightly better than DXT1 and supports smooth alpha blending.

---@alias texture_edges
---| "wrap" Wrap the texture at the edges (default)
---| "clamp" Clamp the texture at the edges. This may help avoid edge artifacts.
---| "mirror" Mirror the texture at the edges.

---@alias texture_types
---| "2d" Standard texture (default)
---| "3d" Volume texture
---| "cube" Cube map

-- This function creates a texture element that can be used in the dxDraw functions.
---
-- **_NOTE:_** This function uses significant process RAM, make sure you don't load a lot of textures, because you'll run out of memory and crash MTA on your gaming PC beyond the technical limit of 3.5 GB (weak PC users much earlier). Besides that, don't make the common mistake of causing a memory leak by not destroying textures (causing dxTextures to pile up) when they should no longer display per your script, which causes FPS lag and crashes all over MTA due to so many scripters missing it.
---
-- **_TIP:_** It is recommended to pre-convert textures to whatever format you want to load them as. ARGB should be PNG, all other formats are self explanatory. By doing this you can load textures on the fly without any hickups (Note: There might still be some if the user has a slow HHD). See [DirectXTex texconv tool](https://github.com/microsoft/DirectXTex/releases).
---
-- **_NOTE:_** It is possible to use dxCreateTexture to load cubemaps and volume textures, but these will only be useable as inputs for a shader. The Microsoft utility [DxTex](http://nightly.mtasa.com/files/shaders/DxTex.zip) can view and change cubemaps and volume textures. DxTex can also convert standard textures into DXT1/3/5 compressed .dds which should reduce file sizes.
---@param pathORpixels string (.bmp, .dds, .jpg, .png, and .tga images are supported). Image files should ideally have dimensions that are a power of two, to prevent possible blurring. _or_ pixels containing image data. ('plain', 'jpeg' or 'png' pixels can be used here)
---@param textureFormat? texture_formats argb; string representing the desired texture format.
---@param mipmaps? boolean true; create a mip-map chain so the texture looks good when drawn at various sizes.
---@param textureEdge? texture_edges wrap; string representing the desired texture edge handling.
---@return Texture | false
function dxCreateTexture(pathORpixels, textureFormat, mipmaps, textureEdge) end

---@param width integer
---@param height integer
---@param textureFormat texture_formats
---@param textureEdge texture_edges
---@param textureType texture_types
---@param depth integer
---@return Texture | false
function dxCreateTexture(width, height, textureFormat, textureEdge, textureType, depth) end

-- **_NOTE:_** Do not draw image from path. Use a texture created with [dxCreateTexture](lua://dxCreateTexture) instead to efficiently draw image.
---
-- **_NOTE:_** For further optimising your DX code, see [dxCreateRenderTarget](lua://dxCreateRenderTarget). You should use render target whenever possible, in order to dramatically reduce CPU usage caused by many dxDraw* calls.
---
-- **_TIP:_** To help prevent edge artifacts when drawing textures, set **textureEdge** to `clamp` when calling [dxCreateTexture](lua://dxCreateTexture).
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

---@class DxFont : Element

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
---@param pathORurl string or URL (http://, https:// or ftp://) of the sound file you want to play.
---@param looped? boolean false; whether the sound will be looped. streams can't be looped for obvious reason.
---@param throttled? boolean true; the sound will be throttled (i.e. given reduced download bandwidth). To throttle the sound, use true. Sounds will be throttled per default and only for URLs.
---@return Sound
function playSound(pathORurl, looped, throttled) end

-- Creates a sound element in the GTA world and plays it immediately after creation for the local player. [setElementPosition](lua://setElementPosition) can be used to move the sound element around after it has been created. Remember to use setElementDimension after creating the sound to play it outside of dimension 0.
---
-- **_NOTE:_** The only supported audio formats are MP3, WAV, OGG, FLAC, RIFF, MOD, WEBM, XM, IT and S3M.
---
-- **_NOTE:_** For performance reasons, when using playSound3D for effects that will be played lots (i.e. weapon fire), it is recommend that you convert your audio file to a one channel (mono) WAV with sample rate of 22050 Hz or less. Also consider adding a limit on how often the effect can be played e.g. once every 50ms.
---@param pathORurl string filepath, url or raw data of the sound you want to play.
---@param x number
---@param y number
---@param z number
---@param looped? boolean whether the sound will be looped.
---@param throttled? boolean whether the sound will be throttled (i.e. given reduced download bandwidth).
---@return Sound
function playSound3D(pathORurl, x, y, z, looped, throttled) end

-- Sets a custom sound max distance at which the sound stops.
---@param sound Sound
---@param distance integer the default value for this is 20
---@return boolean success
function setSoundMaxDistance(sound, distance) end

-- 💻 Client Function
---
-- This function is used to change the volume level of the specified sound element. Use a player element to control a players voice with this function.
---
---@param speaker Sound | Player
---@param volume number 0.0-2.0 (1.0 is the base volume)
---@return boolean success
function setSoundVolume(speaker, volume) end

---@alias sound_effects
---| "gargle" 
---| "compressor" quieter signals gets louder and louder ones gets quieter.
---| "echo"
---| "i3dl2reverb"
---| "distortion" adds more harmonics to the sound.
---| "chorus"
---| "parameq" make a specific freq. range louder or quieter.
---| "reverb"
---| "flanger"

-- 💻 Client Function
---
-- Used to enable or disable specific sound effects. Use a player element to control a players voice with this function.
---
---@param speaker Sound | Player
---@param fxname sound_effects
---@param enabled boolean
---@return boolean success
function setSoundEffectEnabled(speaker, fxname, enabled) end

-- 💻 Client Function
---
-- This function sets the parameter of a sound effect.
---
-- **_NOTE:_** Using this function on a player voice sound element is not supported at this time.
---@param speaker Sound
---@param fxname sound_effects
---@param fxparam string
---@param value number | boolean
---@return boolean success
function setSoundEffectParameter(speaker, fxname, fxparam, value) end

---@alias parameq_params
---| "center" 0; 80...16000; the center frequency.
---| "bandwidth" 12; 1...36; how wide the band will affect frequencies around the center.
---| "gain" 0; -15...15; turn down or up the volume of the frequencies affected.

---@param fxname "parameq"
---@param fxparam parameq_params
function setSoundEffectParameter(speaker, fxname, fxparam, value) end

-- 💻 Client Function
---
-- This function is used to change the seek position of the specified sound element. Use a player element to control a players voice with this function.
---
-- **_NOTE:_** To set position of a remote audio file, you must pause the sound within an onClientSoundStream event after creation, set the sound position and then unpause it again. The sound can also not be throttled (see playSound arguments)
---@param speaker Sound | Player
---@param position number the new seek position of the sound element in seconds.
---@return boolean success
function setSoundPosition(speaker, position) end

-- 💻 Client Function
---
-- This function is used to return the playback length of the specified sound element. If the element is a player, this function will use the players voice.
---
---@param speaker Sound | Player
---@return number length playback length of the sound element in seconds.
function getSoundLength(speaker) end

---@class Ped : Element

-- Returns the world position of the muzzle of the weapon that a ped is currently carrying. The weapon muzzle is the end of the gun barrel where the bullets/rockets/... come out.
---
-- **_NOTE:_** The position may not be accurate if the ped is off screen.
---@param ped Ped the ped whose weapon muzzle position to retrieve.
---@return (number|false) x, number y, number z
function getPedWeaponMuzzlePosition(ped) end

-- 💻 Client and 🖥 Server Function
---
-- This function tells you which weapon type is in a certain [weapon slot](https://wiki.multitheftauto.com/wiki/Weapon) of a ped.
---
-- **_NOTE:_** It should be noted that if a ped runs out of ammo for a weapon, it will still return the ID of that weapon in the slot (even if it appears as if the ped does not have a weapon at all), though [getPedTotalAmmo](lua://getPedTotalAmmo) will return 0. Therefore, [getPedTotalAmmo](lua://getPedTotalAmmo) should be used in conjunction with [getPedWeapon](lua://getPedWeapon) in order to check if a ped has a weapon.
---@param ped Ped
---@param slot? integer current;
---@return integer id the type of the weapon the ped has in the specified slot. If the slot is empty, it returns 0.
function getPedWeapon(ped, slot) end

---@class Player : Ped

-- 💻 Client Function
---
-- This function gets the player element of the client running the current script.
---
-- **_NOTE:_** You should use predefined variable `localPlayer` instead of typing getLocalPlayer() for better readability.
---@return Player
function getLocalPlayer() end

-- 💻 Client and 🖥 Server Function
---
-- This function is used to show or hide a player's cursor.
---
-- **_NOTE:_** Be aware of that if showCursor enbaled by a resource you can't disabled it from a different ressource showCursor(false) will not works, in order to make it works, disable it from the original resource that enabled it or use export
---@param show boolean
---@param toggleControls? boolean true; whether to disable controls whilst the cursor is showing. true implies controls are disabled, false implies controls remain enabled.
---@return boolean
---@overload fun(player: Player, show: boolean, toggleControls?: boolean)
function showCursor(show, toggleControls) end

-- 💻 Client and 🖥 Server (server needs the player param first)
---
-- This function is used to show or hide the player's chat.
---@param show boolean
---@param inputBlocked? boolean whether chat input is blocked/hidden, regardless of chat visibility.
---@return boolean success true if the player's chat was shown or hidden successfully, false otherwise.
---@overload fun(player: Player, show: boolean, inputBlocked?: boolean): boolean
function showChat(show, inputBlocked) end

-- 💻 Client Function
---
-- This function sets the current position of the mouse cursor.
---@param x integer x absolute position
---@param y integer y absolute position
---@return boolean
function setCursorPosition(x, y) end

---@alias hud_component "all"|"ammo"|"area_name"|"armour"|"breath"|"clock"|"health"|"money"|"radar"|"vehicle_name"|"weapon"|"radio"|"wanted"|"crosshair"

-- 💻 Client and 🖥 Server Function
---
-- This function will show or hide a part of the player's HUD.
---@param component hud_component component you wish to show or hide.
---@param show boolean if the component should be shown (true) or hidden (false).
---@return boolean success
function setPlayerHudComponentVisible(component, show) end

-- 💻 Client and 🖥 Server Function
---
-- This function will show or hide a part of the player's HUD.
---@param player Player player element for which you wish to show/hide a HUD component.
---@param component hud_component component you wish to show or hide.
---@param show boolean if the component should be shown (true) or hidden (false).
---@return boolean success
function setPlayerHudComponentVisible(player, component, show) end

-- 💻 Client Function
---
-- This function allows you to disable some background sound effects. See also: [setWorldSoundEnabled](lua://setWorldSoundEnabled).
---@param type "gunfire"|"general" type of ambient sound to toggle.
---@param enabled boolean on or off
---@return boolean success
function setAmbientSoundEnabled(type, enabled) end

-- 💻 Client Function
---
-- This function allows you to disable world sounds. A world sound is a sound effect which has not been caused by [playSound](lua://playSound) or [playSound3D](lua://playSound3D).
---@param group integer the world sound group.
---@param index? integer -1; index of a individual sound within the group.
---@param enabled boolean
---@param immediate? boolean false; if set to true will cancel the sound if it's already playing. This parameter only works for stopping the sound.
---@return boolean success
---@overload fun(group: integer, enabled: boolean): boolean
function setWorldSoundEnabled(group, index, enabled, immediate) end

---@class Timer

-- 💻 Client and 🖥 Server Function
---
-- **_NOTE:_** The speed at which a client side timer runs can be completely unreliable if a client is maliciously modifying their operating system speed, timers could run much faster or slower.
---
-- **_NOTE:_** Writing the following code can cause performance issues. Use `onClientPreRender` event instead.
--- ```lua
--- setTimer(theFunction, 0, 0)
--- ```
-- This function allows you to trigger a function after a number of milliseconds have elapsed. You can call one of your own functions or a built-in function. For example, you could set a timer to spawn a player after a number of seconds have elapsed.
-- Once a timer has finished repeating, it no longer exists.
-- The minimum accepted interval is 0ms.
-- Multi Theft Auto guarantees that the timer will be triggered after at least the interval you specify. The resolution of the timer is tied to the frame rate (server side and client-side). All the overdue timers are triggered at a single point each frame. This means that if, for example, the player is running at 30 frames per second, then two timers specified to occur after 100ms and 110ms would more than likely occur during the same frame, as the difference in time between the two timers (10ms) is less than half the length of the frame (33ms). As with most timers provided by other languages, you shouldn't rely on the timer triggering at an exact point in the future.
---@param callback fun(...)
---@param interval integer milliseconds that should elapse before the function is called. The minimum is 0 ms; 1000 milliseconds = 1 second)
---@param times integer number of times you want the timer to execute, or 0 for infinite repetitions.
---@param ... any arguments you wish to pass to the function can be listed here. Note that any tables you want to pass will get cloned, whereas metatables and functions/function references in that passed table will get lost. Also changes you make in the original table before the function gets called won't get transferred.
---@return Timer | false
function setTimer(callback, interval, times, ...) end

---@class Console : Element

-- 💻 Client and 🖥 Server Function
---
-- **_NOTE:_** Do NOT use the same name for your handler function as the command name, as this can lead to confusion if multiple handler functions are used. Use a name that describes your handler's purpose more specifically.
---
-- **_RESERVED:_** You can't use "check", "list", "test" and "help" as a command name.
---
-- This function will attach a scripting function (handler) to a console command, so that whenever a player or administrator uses the command the function is called.
-- Multiple command handlers can be attached to a single command, and they will be called in the order that the handlers were attached. Equally, multiple commands can be handled by a single function, and the `commandName` parameter used to decide the course of action.
-- This can be triggered from the player's console or directly from the chat box by prefixing the message with a forward slash (/). For server side handlers, the server admin is also able to trigger these directly from the server's console in the same way as they are triggered from a player's console. 
---@param name string
---@param handler fun(source: Player|Console, command: string, ...: string)
---@param restricted? boolean false; whether or not this command should be restricted by default.
---@param caseSensitive? boolean true; if the command handler will ignore the case for this command name.
---@overload fun(name: string, handler: fun(command: string, ...: string), caseSensitive?: boolean): boolean
---@return boolean success
function addCommandHandler(name, handler, restricted, caseSensitive) end

-- 💻 Client and 🖥 Server Function
---
-- Allows you to retrieve the position coordinates of an element.
---@param element Player | Vehicle | Object | Sound
---@return number x, number y, number z
function getElementPosition(element) end

-- 💻 Client and 🖥 Server Function
---
-- This function sets the position of an element to the specified coordinates.
---
-- **_WARNING:_** Do not use this function to spawn a player. It will cause problems with other functions like [warpPedIntoVehicle](lua://warpPedIntoVehicle). Use [spawnPlayer](lua://spawnPlayer) instead.
---@param element Player | Vehicle | Object | Sound
---@param x number
---@param y number
---@param z number
---@param warp? boolean true; teleports players, resetting any animations they were doing. Setting this to false preserves the current animation.
---@return boolean success
function setElementPosition(element, x, y, z, warp) end

-- 💻 Client and 🖥 Server Function
---
-- This outputs the specified text string to the chatbox. It can be specified as a message to certain player(s) or all players.
---
-- It can optionally allow you to embed color changes into the string by setting the colored to true. This allows:
-- ```lua
-- outputChatBox("#FF0000Hello #00FF00World", root, 255, 255, 255, true)
-- ```
-- This will display as: ![#f03c15](https://placehold.co/15x15/f03c15/f03c15.png) `Hello` ![#c5f015](https://placehold.co/15x15/c5f015/c5f015.png) `World` (the words)
---
-- **_NOTE:_** The #RRGGBB format must contain capital letters a-f is not acceptable but A-F is. Default RGB values in this format are: '#E7D9B0'.
---@param text string text string that you wish to send to the chat window. If more than 256 characters it will not be showed in chat.
---@param targets? Element[] | Element root; specifies who the chat is visible to. Any players in this element will see the chat message. See [visibility](https://wiki.multitheftauto.com/wiki/Visibility).
---@param r? integer 231; Amount of red in the color of the text.
---@param g? integer 217; Amount of green in the color of the text.
---@param b? integer 176; Amount of blue in the color of the text.
---@param colored? boolean false; determining whether or not '#RRGGBB' tags should be used.
---@overload fun(text: string, r?: integer, g?: integer, b?: integer, colored?: boolean): boolean
---@return boolean success
function outputChatBox(text, targets, r, g, b, colored) end

-- 💻 Client Function
---
-- This function sets the players clipboard text (what appears when you paste with CTRL + V)
---@param text string
---@return boolean success
function setClipboard(text) end

---@alias radio_ids
---| 0 Radio OFF
---| 1 Playback FM
---| 2 K-Rose
---| 3 K-DST
---| 4 Bounce FM
---| 5 SF-UR
---| 6 Radio Los Santos
---| 7 Radio X
---| 8 CSR 103.9
---| 9 K-Jah West
---| 10 Master Sounds 98.3
---| 11 WCTR
---| 12 User Track Player

-- 💻 Client Function
---
-- This function sets the heard radio channel, even while not in a vehicle.
---
-- **_NOTE:_** This function sometimes doesn't work when setting the radio channel to another different from the current one due to unknown reasons. If you experience this issue, simply add setRadioChannel(0) at the beginning of the script, outside any function.
---@param id radio_ids ID of the radio station you want to play.
---@return boolean success
function setRadioChannel(id) end

-- 💻 Client and 🖥 Server Function
---
-- This function is used to stop the automatic internal handling of events, for example this can be used to prevent an item being given to a player when they walk over a pickup, by canceling the `onPickupUse` event.
---
-- cancelEvent does not have an effect on all events, see the individual event's pages for information on what happens when the event is canceled. cancelEvent does not stop further event handlers from being called, as the order of event handlers being called is undefined in many cases. Instead, you can see if the currently active event has been cancelled using [wasEventCancelled](lua://wasEventCancelled).
---@param cancel? boolean
---@param reason? string
---@return true
function cancelEvent(cancel, reason) end

-- 💻 Client and 🖥 Server Function
---
---@param element Element
---@return all_elements type
function getElementType(element) end

---@class Vehicle : Element

-- 💻 Client and 🖥 Server Function
---
-- **_NOTE:_** Vehicles (and other elements) created client-side are only seen by the client that created them, aren't synced and players cannot enter them. They are essentially for display only.
---
-- **_LAG:_** Due to how GTA works, creating a lot of vehicles in the same place will cause lag. The more geometries and unique textures has model the bigger the lag is. Even a lot of default vehicles will cause lag if in the same place.
---
-- **_USING TRAINS:_** Trains are created using the [createVehicle](lua://createVehicle) function. They are placed at the nearest point of the GTASA train pathing (they usually are railroad tracks) from their spawning point.
---
-- Its worth nothing that the position of the vehicle is the center point of the vehicle, not its base. As such, you need to ensure that the z value (vertical axis) is some height above the ground. You can find the exact height using the client side function [getElementDistanceFromCentreOfMassToBaseOfModel](lua://getElementDistanceFromCentreOfMassToBaseOfModel), or you can estimate it yourself and just spawn the vehicle so it drops to the ground.
---@param model 411|415|integer see all [vehicle ids](https://wiki.multitheftauto.com/wiki/Vehicle_IDs).
---@param x number
---@param y number
---@param z number
---@param rx? number A floating point number representing the rotation about the X axis in degrees.
---@param ry? number A floating point number representing the rotation about the Y axis in degrees.
---@param rz? number A floating point number representing the rotation about the Z axis in degrees.
---@param numberplate? string string that will go on the number plate of the vehicle (max 8 characters).
---@param variant1? integer see [vehicle variants](https://wiki.multitheftauto.com/wiki/Vehicle_variants).
---@param variant2? integer see [vehicle variants](https://wiki.multitheftauto.com/wiki/Vehicle_variants).
---@param synced? boolean server-only; whether or not the vehicle will be synced. Disabling the sync might be useful for frozen or static vehicles to increase the server performance.
---@return Vehicle vehicle the vehicle or false if the arguments are incorrect, or if the vehicle limit of 65535 is exceeded.
function createVehicle(model, x, y, z, rx, ry, rz, numberplate, variant1, variant2, synced) end

---@alias vehicle_seats
---| 0 Driver; Front-Left
---| 1 Front-Right
---| 2 Rear-Left
---| 3 Rear-Right

-- 💻 Client and 🖥 Server Function
---
-- This function is used to warp or force a ped into a vehicle. There are no animations involved when this happens.
---
-- **_NOTE:_** If you used [setElementPosition](lua://setElementPosition) to spawn the ped/player, this function will not work and returns false.
---@param ped Ped ped which you wish to force inside the vehicle.
---@param vehicle Vehicle vehicle you wish to force the ped into.
---@param seat? vehicle_seats
---@return boolean success
function warpPedIntoVehicle(ped, vehicle, seat) end

---@alias vehicle_doors
---| 0 Hood
---| 1 Trunk
---| 2 Front-Left
---| 3 Front-Right
---| 4 Rear-Left
---| 5 Rear-Right

-- 💻 Client and 🖥 Server Function
---
-- This function tells you how open a door is (the 'open ratio'). Doors include boots/trunks and bonnets on vehicles that have them.
---@param vehicle Vehicle
---@param door vehicle_doors
---@return number ratio a number between 0 and 1 that indicates how open the door is. 0 is closed, and 1 is fully open.
function getVehicleDoorOpenRatio(vehicle, door) end

-- 💻 Client and 🖥 Server Function
---
-- This function gets the vehicle that the ped is currently in or is trying to enter, if any.
---@param ped Ped
---@return Vehicle | false
function getPedOccupiedVehicle(ped) end

---@class Team : Element

-- 🖥 Server Function
---
-- This function spawns the player at an arbitrary point on the map.
---
-- **_NOTE:_** [setCameraTarget](lua://setCameraTarget) must be used to focus on the player. Also, all players have their camera initially faded out after connect. To ensure that the camera is faded in, please do a [fadeCamera](lua://fadeCamera) after.
---@param player Player
---@param x number
---@param y number
---@param z number
---@param rotation? integer 0; in degrees.
---@param skin? integer 0; see all [skins](https://wiki.multitheftauto.com/wiki/Character_Skins).
---@param interior? integer 0; see all [interiors](https://wiki.multitheftauto.com/wiki/Interior_IDs).
---@param dimension? integer 0; multiverse id, [learn more](https://wiki.multitheftauto.com/wiki/Dimension).
---@param team? Team getPlayerTeam(player);
---@return boolean success
function spawnPlayer(player, x, y, z, rotation, skin, interior, dimension, team) end

-- 💻 Client and 🖥 Server Function
---
-- This function will fade a player's camera to a color or back to normal over a specified time period. This will also affect the sound volume for the player (50% faded = 50% volume, full fade = no sound). For clientside scripts you can perform 2 fade ins or fade outs in a row, but for serverside scripts you must use one then the other.
---
-- **_NOTE:_** The speed of the effect depends directly on the current gamespeed.
---@param player Player whose camera you wish to fade.
---@param fadein boolean should the camera be faded in or out? Pass true to fade the camera in, false to fade it out to a color.
---@param time? number 1.0; number of seconds it should take to fade.
---@param r? integer 0; amount of red in the color that the camera fades out to (0 - 255). Not required for fading in.
---@param g? integer 0; amount of green in the color that the camera fades out to (0 - 255). Not required for fading in.
---@param b? integer 0; amount of blue in the color that the camera fades out to (0 - 255). Not required for fading in.
---@return boolean success
---@overload fun(fadein: boolean, time?: number, r?: integer, g?: integer, b?: integer): boolean
function fadeCamera(player, fadein, time, r, g, b) end

-- 💻 Client and 🖥 Server Function
---
-- This function allows you to set a player's camera to follow other elements instead.
---@param player Player whose camera you wish to modify.
---@param target? Player | Ped | Vehicle element who you want the camera to follow. If none is specified, the camera will target the player.
---@return boolean success
---@overload fun(target: Player | Ped | Vehicle): boolean
---@overload fun(x: number, y: number, z: number): boolean
function setCameraTarget(player, target) end

-- 💻 Client and 🖥 Server Function
---
-- This function sets the current GTA time to the given time. 
---@param hour integer hour of the new time (range 0-23).
---@param minute integer minute of the new time (range 0-59).
---@return boolean success
function setTime(hour, minute) end

---@alias all_elements
---| "player"
---| "ped"
---| "water" water polygon
---| "sound"
---| "vehicle"
---| "object"
---| "pickup"
---| "marker"
---| "colshape" collision shape
---| "blip"
---| "radararea"
---| "team"
---| "spawnpoint"
---| "console" The Server Console
---| "projectile" clientside projectile
---| "effect" clientside effect
---| "light" clientside light
---| "searchlight" clientside searchlight
---| "shader"
---| "texture"
---| "gui-window" A GUI window (theres others like this for other GUI types)
---| "building" (client side only)

-- 💻 Client and 🖥 Server Function
---
-- This function is used to retrieve a list of all elements of the specified type. This can be useful, as it disregards where in the element tree it is. It can be used with either the built in types (listed below) or with any custom type used in a .map file. For example, if there is an element of type "flag" (e.g. <flag />) in the .map file, the using "flag" as the type argument would find it.
---@param type all_elements
---@param start_at? Element root; The element the search should start at. Children of this element are searched, siblings or parents will not be found. By default, this is the root element which should suit most uses.
---@param streamed_in? boolean false; client-only; If true, function will only return elements that are streamed in.
---@return Element[] # Returns a table containing all the elements of the specified type. Returns an empty table if there are no elements of the specified type. Returns false if the string specified is invalid (or not a string).
function getElementsByType(type, start_at, streamed_in) end

---@param type "player"
---@return Player[]
function getElementsByType(type) end

---@class Account

-- 🖥 Server Function
---
-- **_NOTE:_** You **MUST** use the standard `module.key` naming for your keys. This prevents collisions between different scripts.
---
-- This function sets a string to be stored in an account. This can then be retrieved using [getAccountData](lua://getAccountData). Data stored as account data is persistent across user's sessions and maps, unless they are logged into a guest account. Even if logged into a guest account, account data can be useful as a way to store a reference to your own account system, though it's persistence is equivalent to that of using setElementData on the player's element.
---@param account Account you wish to set the data to.
---@param key string key under which the data is stored.
---@param value string | integer value you wish to store. Set to false to remove the data. **_NOTE:_** you cannot store tables as values, but you can use [toJSON](lua://toJSON) strings.
---@return boolean success
function setAccountData(account, key, value) end

-- 🖥 Server Function
---
-- **_NOTE:_** You **MUST** use the standard `module.key` naming for your keys. This prevents collisions between different scripts.
---
-- This function retrieves a string that has been stored using [setAccountData](lua://setAccountData). Data stored as account data is persistent across user's sessions and maps, unless they are logged into a guest account.
---@param account Account you wish to retrieve the data from.
---@param key string key under which the data is stored.
---@return string | false # a string containing the stored data or false if no data was stored under that key.
function getAccountData(account, key) end

-- 🖥 Server Function
---
-- This function retrieves the ID of an account.
---@param account Account
---@return integer | false id # false if the account does not exist or an invalid argument was passed to the function.
function getAccountID(account) end

-- 🖥 Server Function
---
-- This function returns the specified player's account object.
---@param player Player
---@return Account | false account
function getPlayerAccount(player) end

-- 🖥 Server Function
---
-- This function checks to see if an account is a guest account. A guest account is an account automatically created for a user when they join the server and deleted when they quit or login to another account. Data stored in a guest account is not stored after the player has left the server. As a consequence, this function will check if a player is logged in or not.
---@param account Account
---@return boolean is_guest
function isGuestAccount(account) end

-- 💻 Client and 🖥 Server Function
---
-- Sets a player's money to a certain value, regardless of current player money. It should be noted that setting negative values does not work and in fact gives the player large amounts of money.
---
-- **_NOTE:_** Using this function client side (not recommended) will not change a players money server side.
---@param player Player
---@param amount integer
---@param instant? boolean false; If set to true money will be set instantly without counting up/down like in singleplayer.
---@return boolean success
---@overload fun(amount: integer, instant?: boolean): boolean
function setPlayerMoney(player, amount, instant) end

-- 💻 Client and 🖥 Server Function
---
-- Returns the amount of money a player currently has.
---
-- **_NOTE:_** The amount may vary between the server and client, you shouldn't trust the client side value to always be accurate.
---@param player Player
---@return integer money
function getPlayerMoney(player) end

-- 💻 Client and 🖥 Server Function
---
-- This function stores [element data](https://wiki.multitheftauto.com/wiki/Element_data) under a certain key, attached to an element. Element data set using this is then synced with all clients and the server. The data can contain server-created elements, but you should avoid passing data that is not able to be synced such as xmlnodes, acls, aclgroups etc.
---
-- As element data is synced to all clients, it can generate a lot of network traffic and be heavy on performance. Events are much more efficient for sending data from a client to the server only, or from the server to a specific client.
-- Usage of element data should be discouraged where your goal can be achieved with events like above, and tables for storing and retrieving data.
---
-- **_TIP:_** A simple and efficient way to make a variable known to the server and clients is to use setElementData on the root element.
---
-- **_SECURITY:_** See [Script security](https://wiki.multitheftauto.com/wiki/Script_security) for tips on preventing cheaters when using events and element data.
---
-- **_PERFORMANCE:_** For performance reasons, never use setElementData in events that fire often (like `onClientRender`) without further optimization or conditions. In fact, using element data in general, can take such a toll on performance that not using it unless strictly necessary (e.g use alternatives such as storing data in tables) is recommended.
---@param element Element
---@param key string key you wish to store the data under. (Maximum 128 characters.)
---@param value number | string | table | Element
---@param sync? boolean true; whether or not the data will be synchronized with the clients(server-side variation) or server(client-side variation)
---@return boolean success
function setElementData(element, key, value, sync) end

-- 💻 Client and 🖥 Server Function
---
-- This function retrieves element data attached to an element under a certain key.
---@param element Element the element with data you want to retrieve.
---@param key string name of the element data entry you want to retrieve. (Maximum 31 characters.)
---@param inherit? boolean true; whether or not the function should go up the hierarchy to find the requested key in case the specified element doesn't have it.
---@return number | string | table | Element
function getElementData(element, key, inherit) end

-- 💻 Client and 🖥 Server Function
---
-- This function destroys an element and all elements within it in the hierarchy (its children, the children of those children etc). Player elements cannot be destroyed using this function. A player can only be removed from the hierarchy when they quit or are kicked. The root element also cannot be destroyed, however, passing the root as an argument will wipe all elements from the server, except for the players and clients, which will become direct descendants of the root node, and other elements that cannot be destroyed, such as resource root elements.
---
-- **_BUG:_** There is bug when you try to destroy webbrowser that returned from guiGetBrowser so instead of that destroy the gui-element one that returned from guiCreateBrowser otherwise the game will be crushed (By Master_MTA).
---
-- **_NOTE:_** As element ids are eventually recycled, always make sure you nil variables containing the element after calling this function.
---
-- **_REMARKS:_** If a streamed-in element is destroyed then it is NOT streamed out, i.e. the onClientElementStreamOut client-side event is NOT triggered. Thus it is wrong to assume a clean stream-in and stream-out sequence on the client-side. Additionally to onClientElementStreamOut use a onClientElementDestroy event handler to detect the destruction of streamed-in elements.
---@param element Element
---@return boolean success Returns true if the element was destroyed successfully, false if either the element passed to it was invalid or it could not be destroyed for some other reason (for example, clientside destroyElement can't destroy serverside elements).
function destroyElement(element) end

---@alias keys_and_controls
---| "mouse1"
---| "mouse2"
---| "mouse3"
---| "mouse4"
---| "mouse5"
---| "mouse_wheel_up"
---| "mouse_wheel_down"
---| "arrow_l"
---| "arrow_u"
---| "arrow_r"
---| "arrow_d"
---| "0"
---| "1"
---| "2"
---| "3"
---| "4"
---| "5"
---| "6"
---| "7"
---| "8"
---| "9"
---| "a"
---| "b"
---| "c"
---| "d"
---| "e"
---| "f"
---| "g"
---| "h"
---| "i"
---| "j"
---| "k"
---| "l"
---| "m"
---| "n"
---| "o"
---| "p"
---| "q"
---| "r"
---| "s"
---| "t"
---| "u"
---| "v"
---| "w"
---| "x"
---| "y"
---| "z"
---| "num_0"
---| "num_1"
---| "num_2"
---| "num_3"
---| "num_4"
---| "num_5"
---| "num_6"
---| "num_7"
---| "num_8"
---| "num_9"
---| "num_mul"
---| "num_add"
---| "num_sep"
---| "num_sub"
---| "num_div"
---| "num_dec"
---| "num_enter"
---| "F1"
---| "F2"
---| "F3"
---| "F4"
---| "F5"
---| "F6"
---| "F7"
---| "F8"
---| "F9"
---| "F10"
---| "F11"
---| "F12"
---| "escape"
---| "backspace"
---| "tab"
---| "lalt"
---| "ralt"
---| "enter"
---| "space"
---| "pgup"
---| "pgdn"
---| "end"
---| "home"
---| "insert"
---| "delete"
---| "lshift"
---| "rshift"
---| "lctrl"
---| "rctrl"
---| "["
---| "]"
---| "pause"
---| "capslock"
---| "scroll"
---| ";"
---| ","
---| "-"
---| "."
---| "/"
---| "#"
---| "\"
---| "="
---| "fire"
---| "aim_weapon"
---| "next_weapon"
---| "previous_weapon"
---| "forwards"
---| "backwards"
---| "left"
---| "right"
---| "zoom_in"
---| "zoom_out"
---| "change_camera"
---| "jump"
---| "sprint"
---| "look_behind"
---| "crouch"
---| "action"
---| "walk"
---| "conversation_yes"
---| "conversation_no"
---| "group_control_forwards"
---| "group_control_back"
---| "enter_exit"
---| "vehicle_fire"
---| "vehicle_secondary_fire"
---| "vehicle_left"
---| "vehicle_right"
---| "steer_forward"
---| "steer_back"
---| "accelerate"
---| "brake_reverse"
---| "radio_next"
---| "radio_previous"
---| "radio_user_track_skip"
---| "horn"
---| "sub_mission"
---| "handbrake"
---| "vehicle_look_left"
---| "vehicle_look_right"
---| "vehicle_look_behind"
---| "vehicle_mouse_look"
---| "special_control_left"
---| "special_control_right"
---| "special_control_down"
---| "special_control_up"

-- 💻 Client and 🖥 Server Function
---
-- Binds a player's key to a handler function or command, which will be called when the key is pressed.
---
-- **_NOTE:_** Using escape key or F8 key will always return false. Use onClientKey event instead.
---
-- **_NOTE:_** Handler function won't be triggered while focused in CEGUI editbox. You can use guiSetInputMode or onClientKey in order to fix that.
---
---@param key keys_and_controls
---@param state "up" | "down" | "both"
---@param callback fun(key: keys_and_controls, state: "up" | "down", ...) | string
---@param ... any
---@return boolean success
---@overload fun(player: Player, key: keys_and_controls, state: "up" | "down" | "both", callback: fun(key: keys_and_controls, state: "up" | "down", ...) | string, ...: any): boolean
function bindKey(key, state, callback, ...) end

-- 💻 Client and 🖥 Server Function
---
-- Removes an existing key bind from the specified player.
---
-- **_NOTE:_** unbindKey will only work on binds that were added by the same resource.
---
-- **_NOTE:_** unbindKey on the server may return true on failure.
---
-- **_ISSUE:_** If you call unbindKey twice, it will break other scripts: [Issue 497](https://github.com/multitheftauto/mtasa-blue/issues/497)
---@param key keys_and_controls
---@param state "up" | "down" | "both"
---@param callback fun(key: keys_and_controls, state: "up" | "down", ...) | string
---@return boolean success
---@overload fun(player: Player, key: keys_and_controls, state: "up" | "down" | "both", callback: fun(key: keys_and_controls, state: "up" | "down", ...) | string): boolean
---@overload fun(player: Player, key: keys_and_controls): boolean
---@overload fun(key: keys_and_controls): boolean
function unbindKey(key, state, callback) end