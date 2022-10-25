local function data()
  local file = io.open("data.txt", "rb")
  if not file then return nil end

  return file:read("*a");
end

local function solve(str)
  local counter = 0
  local basement_step = nil

  for i = 1, #str do
    local c = str:sub(i,i)
    if c == "(" then
      counter = counter + 1
    elseif c == ")" then
      counter = counter - 1
    end

    if counter < 0 then
      basement_step = i
      break
    end
  end

  return basement_step
end

print(solve(data()))
