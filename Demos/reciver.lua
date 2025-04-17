local modem = peripheral.find("network_modem")
local myLan = modem.getIp("lan")
print("My Lan is: " .. myLan.value)

while true do
  local reply = modem.receiveLan()
  --local reply = modem.receive() -- use only if recive wan messages
  if reply.status  == true then
    print("Got message: " .. reply.message )
  elseif not reply.error == "No Message" then
    print("Error: ".. tostring(reply.error))
  end
  sleep(0.5)
end
