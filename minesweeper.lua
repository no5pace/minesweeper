--misc. necessity
math.randomseed(os.time())

--variables and tables
local gameLoop = false
local killScript = false
local dead
local win
local devMode = false

local firstDig = true

local backdropRep = ". "
local sizeX = 13
local sizeY = 8
local multiples = {}
for ind = 1,sizeX,1 do
	for i = 1,sizeX*sizeY,1 do
		if i/sizeX == ind then
			table.insert(multiples,i)
		end
	end
end
local coords = {}
for i = 1,sizeX*sizeY do
	table.insert(coords,"f")
end
local cursorRep = "O "
local cursorStartPos = math.floor((sizeX * sizeY)/2)
local cursorPos = cursorStartPos
local newCursorPos = cursorPos
local cursorDir = "d"

local flagRep = "P "
local flagsPlaced = 0

local mines = 10
local mineTab = {}
local minesLeft
local mineRep = "@ "
local minePos

local inTab

local start
local minutes = 0
local seconds = 0

--game functions
function startState()
	os.execute("cls")
	dead = false
	win = false
	firstDig = true
	cursorPos = cursorStartPos
	cursorDir = "d"
	minutes = 0
	seconds = 0
	multiples = {}
	minesLeft = mines
	flagsPlaced = 0
	cursorStartPos = math.floor((sizeX * sizeY)/2)
	cursorPos = cursorStartPos
	newCursorPos = cursorPos
	minePos = nil
	mineTab = {}

	multiples = {}
	for ind = 1,sizeX,1 do
		for i = 1,sizeX*sizeY,1 do
			if i/sizeX == ind then
				table.insert(multiples,i)
			end
		end
	end
	coords = {}
	for i = 1,sizeX*sizeY do
		table.insert(coords,"f")
	end
end

function wait(seconds) --for debug purposes
	local start = os.time()
	repeat until os.time() > start + seconds
end

function genBaby(cellPointer,v)
	if string.find(coords[cellPointer],mineRep) == nil then
		local numChar = string.sub(coords[cellPointer],2,2)
		local oldMineCount = tonumber(numChar)
		local newMineCount = oldMineCount + 1

		coords[cellPointer] = string.gsub(coords[cellPointer],numChar,tostring(newMineCount))
	end
end

function digBaby(cellPointer,v,digTab)
	if string.sub(coords[v],2,3) == "  " and string.sub(coords[v],1,1) ~= "t" and string.sub(coords[cellPointer],1,1) ~= "t" then
		table.insert(digTab,cellPointer)
		coords[v] = string.sub(coords[v],1,3)
		--elseif string.sub(coords[v],4,5) == "P " then
	else
		coords[v] = string.sub(coords[v],1,3)
	end
end

function findInTab(table,item)
	inTab = false
	for i,v in pairs(table) do
		if v == item then
			inTab = true
		else
		end
	end

	return inTab
end

function header()
	print("\n"..string.rep(" ",sizeX-(math.floor(15/2) - 1)).."MINESWEEPER.LUA\n"..string.rep(" ",sizeX-(math.floor(21/2) - 1)).."Developed by @no5pace\n")
	print(string.rep("=",(sizeX*2)+3))
	print(" Mines Left: "..minesLeft..string.rep(" ",(sizeX*2 + 1)-25)..string.format("Time: %02d:%02d", minutes, seconds))
	print(string.rep("=",(sizeX*2)+3))
end

function drawGrid(debugMode)
	header()

	io.write("| ")
	for i,v in pairs(coords) do
		io.write(string.sub(v,-2,-1))
		for ind,val in pairs(multiples) do
			if i == multiples[#multiples] then
				io.write("|\n|")
				break
			elseif i == val then
				io.write("|\n| ")
			end
		end
	end
	io.write(string.rep("_",(sizeX*2) + 1))
	print("|")

	if debugMode == true then
		io.write("| ")
		for i,v in pairs(coords) do
			io.write(string.sub(v,2,3))
			for ind,val in pairs(multiples) do
				if i == multiples[#multiples] then
					io.write("|\n|")
					break
				elseif i == val then
					io.write("|\n| ")
				end
			end
		end
		io.write(string.rep("_",(sizeX*2) + 1))
		print("|")
	else
	end

	io.write("Input R to go back to the Main Menu\n\nInput: ")
end

function generateGrid()
	for i,v in pairs(coords) do
		coords[i] = "f"
	end

	while true do
		for i = 1,mines do
			while true do
				minePos = math.random(sizeX*sizeY)
				if findInTab(mineTab,minePos) == false then
					table.insert(mineTab,minePos)
					break
				else
				end
			end
		end

		for i,v in pairs(coords) do
			if findInTab(mineTab,coords[i]) == true then
				coords[i] = coords[i]..mineRep
			else
				coords[i] = coords[i].."0 "
			end
		end

		for i,v in pairs(mineTab) do
			if v + 1 > 0 and v + 1 <= sizeX * sizeY and findInTab(multiples,v) == false then
				genBaby(v+1,v)
			else
			end

			if v + sizeX > 0 and v + sizeX <= sizeX * sizeY then
				genBaby(v+sizeX,v)
			else
			end

			if v - 1 > 0 and v - 1   <=  sizeX * sizeY and findInTab(multiples,v-1
				) == false then
				genBaby(v-1,v)
			else
			end

			if v - sizeX > 0   and v   - sizeX <= sizeX * sizeY then
				genBaby(v-sizeX,v)
			else
			end

			if v + 1 +   sizeX>   0 and v + 1 + sizeX <= sizeX * sizeY and findInTab(multiples, v) == false then
				genBaby(v+1+sizeX,v)
			else
			end

			if v + 1 -   sizeX>   0 and v + 1 - sizeX <= sizeX * sizeY and findInTab(multiples, v) == false then
				genBaby(v+1-sizeX,v)
			else
			end

			if v - 1 +   sizeX>   0 and v - 1 + sizeX <= sizeX * sizeY and findInTab(multiples, v-1) == false and v ~= 1 then
				genBaby(v-1+sizeX,v)
			else
			end

			if v - 1 -  sizeX>  0 and v - 1 - sizeX <= sizeX *  sizeY and findInTab(multiples,  v-1) == false then
				genBaby(v-1-sizeX,v)
			else
			end
		end

		if string.sub(coords[cursorPos],2,3) ~= "0 " or findInTab(mineTab, cursorPos) == true then
			coords = {}
			for i = 1,sizeX*sizeY do
				table.insert(coords,"f")
			end
			mineTab = {}
		elseif string.sub(coords[cursorPos],2,3) == "0 " and findInTab(mineTab, cursorPos) == false then
			break
		end
	end

	--[[for i,v in pairs (coords) do
	print(coords[i])
	end]]

	for i,v in pairs(coords) do
	coords[i] = coords[i]..backdropRep
	if string.sub(coords[i],2,2) == "0" then
	coords[i] = string.gsub(coords[i],"0"," ")
	end
	end

	for i,v in pairs(mineTab) do
	coords[v] = "f@ . "
	end

	--WHAT THE HEEEEEECK
	--coords[cursorStartPos] = coords[cursorStartPos]..cursorRep
	end

	function backFunc()
	os.execute("cls")
	if gameLoop == true then
	cursorPos = newCursorPos
	if cursorDir == "w" then
	newCursorPos = cursorPos-sizeX
	if newCursorPos <= 0 then
	newCursorPos = newCursorPos + (sizeX * sizeY)
	end
	coords[newCursorPos] = coords[newCursorPos]..cursorRep
	coords[cursorPos] = string.sub(coords[cursorPos],1,string.len(coords[cursorPos])-2)

	elseif cursorDir == "a" then
	newCursorPos = cursorPos-1
	for i,v in pairs(multiples) do
	if newCursorPos == v or newCursorPos == 0 then
	newCursorPos = cursorPos + (sizeX - 1)
	end
	end
	coords[newCursorPos] = coords[newCursorPos]..cursorRep
	coords[cursorPos] = string.sub(coords[cursorPos],1,string.len(coords[cursorPos])-2)

	elseif cursorDir == "s" then
	newCursorPos = cursorPos+sizeX
	if newCursorPos > (sizeX * sizeY) then
	newCursorPos = (newCursorPos - (sizeX * sizeY))
	end
	coords[newCursorPos] = coords[newCursorPos]..cursorRep
	coords[cursorPos] = string.sub(coords[cursorPos],1,string.len(coords[cursorPos])-2)

	elseif cursorDir == "d" then
	newCursorPos = cursorPos+1
	for i,v in pairs(multiples) do
	if cursorPos == v then
	newCursorPos = cursorPos - (sizeX - 1)
	end
	end
	coords[newCursorPos] = coords[newCursorPos]..cursorRep
	coords[cursorPos] = string.sub(coords[cursorPos],1,string.len(coords[cursorPos])-2)

	elseif cursorDir == "dig" then
	if firstDig == true then
	generateGrid()
	end
	firstDig = false

	if string.sub(coords[cursorPos],2,3) == "@ " then
	dead = true
	end

	local digTab = {cursorPos}

	for i,v in pairs(digTab) do
	if v + 1 > 0 and v + 1 <= sizeX * sizeY and findInTab(multiples,v) == false then
	digBaby(v+1,v,digTab)
	else
	end

	if v + sizeX > 0 and v + sizeX <= sizeX * sizeY then
	digBaby(v+sizeX,v,digTab)
	else
	end

	if v - 1 > 0 and v - 1 <= sizeX * sizeY and findInTab(multiples,v - 1) == false then
	digBaby(v-1,v,digTab)
	else
	end

	if v - sizeX > 0 and v - sizeX <= sizeX * sizeY then
	digBaby(v-sizeX,v,digTab)
	else
	end

	if v + 1 + sizeX > 0 and v + 1 + sizeX <= sizeX * sizeY and findInTab(multiples,v) == false then
	digBaby(v+1+sizeX,v,digTab)
	else
	end

	if v + 1 - sizeX > 0 and v + 1 - sizeX <= sizeX * sizeY and findInTab(multiples,v) == false then
	digBaby(v+1-sizeX,v,digTab)
	else
	end

	if v - 1 + sizeX > 0 and v - 1 + sizeX <= sizeX * sizeY and findInTab(multiples,v - 1) == false and v ~= 1 then
	digBaby(v-1+sizeX,v,digTab)
	else
	end

	if v - 1 - sizeX > 0 and v - 1 - sizeX <= sizeX * sizeY and findInTab(multiples,v - 1) == false then
	digBaby(v-1-sizeX,v,digTab)
	else
	end

	coords[v] = string.gsub(coords[v],"f","t")
	end

	digTab = {}
	coords[cursorPos] = coords[cursorPos]..cursorRep
	cursorDir = ""

	win = true
	for i,v in pairs (coords) do
	if findInTab(mineTab,i) == false then
	if string.sub(coords[i],1,1) == "f" then
	win = false
	else
	end
	else
	end
	end

	elseif cursorDir == "flag" then
	if string.find(coords[cursorPos],flagRep) ~= nil then
	coords[cursorPos] = string.gsub(string.sub(coords[cursorPos],1,-3),flagRep,"")
	flagsPlaced = flagsPlaced - 1
	else
	coords[cursorPos] = coords[cursorPos]..flagRep..cursorRep
	flagsPlaced = flagsPlaced + 1
	end
	cursorDir = ""
	else
	end
	end

	if dead == true then
	for i,v in pairs(mineTab) do
	coords[v] = string.sub(coords[v],1,3)
	end
	end

	drawGrid(devMode)

	if dead == true then
	io.write("\n\nYOU DIED D:\nPress enter to continue\n")
	elseif win == true then
	io.write("\n\nYOU WON!!! ^(*o*)^\nPress enter to continue\n")
	end
	end

	--game loop
	while true do
	if dead == true then
	break
	end
	os.execute("cls")
	io.write("\nWelcome to MineSweeper.lua!\n[1] Play\n[2] Settings\n[3] How to Play + Legend (IMPORTANT)\n[4] Quit\n\nInput: ")
	local menuInput = io.read()
	if menuInput == "1" then
	cursorPos = cursorStartPos
	coords[cursorStartPos] = string.sub(coords[cursorStartPos],1,3)..". "
	--generateGrid()
	for i,v in pairs(coords) do
	coords[i] = string.sub(coords[i],1,3)..". "
	end
	gameLoop = true
	start = os.time()
	elseif menuInput == "2" then
	while true do
	os.execute("cls")
	io.write("SETTINGS\n\n[1] Grid Size\n[2] Mine Concentration\n[3] Preset Difficulties\n[4] Developer Mode ("..tostring(devMode)..")\n[5] Exit\n\nInput: ")
	menuInput = io.read()
	if menuInput == "1" then
	io.write("\nWidth of playing field? ")
	sizeX = tonumber(io.read())
	io.write("Height of playing field? ")
	sizeY = tonumber(io.read())
	multiples = {}
	for ind = 1,sizeX,1 do
	for i = 1,sizeX*sizeY,1 do
	if i/sizeX == ind then
	table.insert(multiples,i)
	end
	end
	end
	coords = {}
	for i = 1,sizeX*sizeY do
	table.insert(coords,"f")
	end
	cursorStartPos = math.floor((sizeX * sizeY)/2)
	cursorPos = cursorStartPos
	newCursorPos = cursorPos
	elseif menuInput == "2" then
	io.write("\nAmount of mines? ")
	mines = tonumber(io.read())
	if mines > sizeX * sizeY then
	mines = sizeX * sizeY
	end
	elseif menuInput == "3" then
	while true do
	os.execute("cls")
	io.write("Preset Difficulties\n\n[1] Small\n[2] Medium\n[3] Large\n\nInput: ")
	menuInput = io.read()
	if menuInput == "1" then
	sizeX = 13
	sizeY = 8
	mines = 10

	multiples = {}
	for ind = 1,sizeX,1 do
	for i = 1,sizeX*sizeY,1 do
	if i/sizeX == ind then
	table.insert(multiples,i)
	end
	end
	end
	coords = {}
	for i = 1,sizeX*sizeY do
	table.insert(coords,"f")
	end
	cursorStartPos = math.floor((sizeX * sizeY)/2)
	cursorPos = cursorStartPos
	newCursorPos = cursorStartPos
	break
	elseif menuInput == "2" then
	sizeX = 18
	sizeY = 14
	mines = 40

	multiples = {}
	for ind = 1,sizeX,1 do
	for i = 1,sizeX*sizeY,1 do
	if i/sizeX == ind then
	table.insert(multiples,i)
	end
	end
	end
	coords = {}
	for i = 1,sizeX*sizeY do
	table.insert(coords,"f")
	end
	cursorStartPos = math.floor((sizeX * sizeY)/2)
	cursorPos = cursorStartPos
	newCursorPos = cursorPos
	break
	elseif menuInput == "3" then
	sizeX = 24
	sizeY = 20
	mines = 100

	multiples = {}
	for ind = 1,sizeX,1 do
	for i = 1,sizeX*sizeY,1 do
	if i/sizeX == ind then
	table.insert(multiples,i)
	end
	end
	end
	coords = {}
	for i = 1,sizeX*sizeY do
	table.insert(coords,"f")
	end
	cursorStartPos = math.floor((sizeX * sizeY)/2)
	cursorPos = cursorStartPos
	newCursorPos = cursorPos
	break
	else
	end
	end
	elseif menuInput == "4" then
	if devMode == false then
	devMode = true
	else
	devMode = false
	end
	elseif menuInput == "5" then
	break
	else
	end
	end
	elseif menuInput == "3" then
	os.execute("cls")
	io.write("HOW TO PLAY\n\nThe Overview\nMinesweeper is a game of numbers in which you used numerical clues from each tile to deduce what other tiles may or may not be mines.  If you dig on top of a mine, you lose, but if you dig every square that isn't a mine, you win!  (Notice that this means you don't acutally have to flag every mine to win, but it also means that you can't win by just flagging all the mines.)\n\nThe Basics\nEach tile you dig will have either a number (representing how many total tiles that contain mines are adjacent to it), no number (representing the fact that there are zero mines next to it, you won't have to deal with these as the game handles it for you), or a mine.  However, at the start of every game, none of these values will be visible to you, and you have to dig a random spot on the grid and hope you don't die.  Once you've made headway, however, you can use the aforementioned numbers to help you figure out where the mines are so that that you can flag them.\n\nThe Nuances\nIf you've every played any other iteration of Minesweeper, you'll notice that the way you interact with this game is very different.  That's because this game is played in the terminal, you can cant use your cursor to interact with the game.  Instead, you have to type an input on your keyboard where ever specifed (Where ever it says \"Input: \") and press enter.  While you're in a game, a circle will appear that represents your cursor.  You can move this to any cell you please and perform any action you like, just as with a normal cursor.  Please don't complain about this, it's the only way input will work in this format of game.\n\nThe Controls\nWASD - move the cursor\nE - dig a tile\nQ - flag a tile\n\nThe Legend\n .  - untouched tile\n    - tile with no number\n #  - a tile with n mines adjacent to it\n P  - flagged tile\n @  - active mine (only visible in the death screen)\n\nPress enter to continue")
	io.read()
	elseif menuInput == "4" then
	gameLoop = false
	win = false
	dead = false
	killScript = true
	else
	end

	while gameLoop == true do
	seconds = (os.time() - start)%60
	minutes = (os.time() - start)/60
	minesLeft = mines - flagsPlaced
	if minesLeft < 10 then
	minesLeft = " "..tostring(mines - flagsPlaced)
	end
	backFunc()
	local gameInput = io.read()
	if gameInput == "w" or gameInput == "W" then
	cursorDir = "w"
	elseif gameInput == "a" or gameInput == "A" then
	cursorDir = "a"
	elseif gameInput == "s" or gameInput == "S" then
	cursorDir = "s"
	elseif gameInput == "d" or gameInput == "D" then
	cursorDir = "d"
	elseif gameInput == "e" or gameInput == "E" then
	cursorDir = "dig"
	elseif gameInput == "q" or gameInput == "Q" then
	cursorDir = "flag"
	elseif gameInput == "r" or gameInput == "R" then
	startState()
	gameLoop = false
	else
	end

	while dead == true or win == true do
	io.write("To Main Menu?\n[1] yes\n[2] restart on current settings\n\nInput: ")
	local restart = io.read()
	if restart == "1" then
	startState()
	gameLoop = false
	win = false
	dead = false
	elseif restart == "2" then
	startState()
	win = false
	dead = false
	cursorPos = cursorStartPos
	coords[cursorStartPos] = string.sub(coords[cursorStartPos],1,3)..". "
	--generateGrid()
	for i,v in pairs(coords) do
	coords[i] = string.sub(coords[i],1,3)..". "
	end
	gameLoop = true
	start = os.time()
	else
	io.write("Pick a valid option\n\n")
	end
	end
	end
	if killScript == true then
	startState()
	break
	end
	end
